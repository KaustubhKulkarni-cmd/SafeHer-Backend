import os
import json
import re
import uuid
from datetime import datetime, timezone
import google.generativeai as genai
from config.firebase_config import db
from services.crime_service import CrimeService, AREA_COORDINATES

class AIService:

    @staticmethod
    def generate_reply(message, user_id="gZjd2nm5MKPF20xJll9srBfoVao1", lat=None, lng=None):
        genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
        model = genai.GenerativeModel("gemini-2.5-flash")

        # 1. Specific suburb matches
        matched_suburb = None
        message_lower = message.lower()
        sorted_suburbs = sorted(AREA_COORDINATES.keys(), key=len, reverse=True)
        for suburb in sorted_suburbs:
            pattern = r'\b' + re.escape(suburb.lower()) + r'\b'
            if re.search(pattern, message_lower):
                matched_suburb = suburb
                break

        # 2. Safety score keywords matches
        asking_about_safety = False
        safety_keywords = ["safety score", "safe score", "how safe", "safety level", "am i safe", "safety rating", "score here"]
        for kw in safety_keywords:
            if kw in message_lower:
                asking_about_safety = True
                break

        suburb_safety_context = ""
        current_safety_context = ""

        # Fetch Specific Suburb Safety Details
        if matched_suburb:
            try:
                suburb_safety = CrimeService.calculate_route_safety([matched_suburb])
                safety_score = suburb_safety.get("safety_score", 80.0)
                safety_rating = suburb_safety.get("safety_rating", "Moderate Safety")

                # Get day vs night breakdown
                morning_stats = CrimeService.get_crime_stats(matched_suburb, "Morning", 6, 12)
                afternoon_stats = CrimeService.get_crime_stats(matched_suburb, "Afternoon", 12, 17)
                evening_stats = CrimeService.get_crime_stats(matched_suburb, "Evening", 17, 22)
                night_stats = CrimeService.get_crime_stats(matched_suburb, "Night", 22, 6)

                day_crimes = (
                    morning_stats.get("period_crimes", 0) +
                    afternoon_stats.get("period_crimes", 0) +
                    evening_stats.get("period_crimes", 0)
                )
                night_crimes = night_stats.get("period_crimes", 0)
                total_crimes = morning_stats.get("total_crimes", 0)

                crime_breakdown = morning_stats.get("breakdown", {})
                sorted_breakdown = sorted(crime_breakdown.items(), key=lambda x: x[1], reverse=True)[:5]
                breakdown_str = ", ".join([f"{k}: {v}" for k, v in sorted_breakdown]) if sorted_breakdown else "No records"

                suburb_safety_context = f"""
Safety Data for Requested Suburb ({matched_suburb}):
- Safety Score: {safety_score}/100 ({safety_rating})
- Total Registered Incidents: {total_crimes}
- Daytime Incidents (06:00 - 22:00): {day_crimes}
- Nighttime Incidents (22:00 - 06:00): {night_crimes}
- Top 5 Crime Categories: {breakdown_str}
"""
            except Exception as ex:
                print(f"[AIService] Error fetching suburb stats: {ex}")
                suburb_safety_context = f"\nError fetching safety statistics for {matched_suburb}.\n"

        # Fetch Current Location / Safety Score Details
        if asking_about_safety or (lat is not None and lng is not None and not matched_suburb):
            coords_missing = (lat is None or lng is None)
            lat_val = lat if lat is not None else 18.5168
            lng_val = lng if lng is not None else 73.8441

            try:
                closest_suburb, dist = CrimeService.get_closest_area(lat_val, lng_val)
                suburb_safety = CrimeService.calculate_route_safety([closest_suburb])
                safety_score = suburb_safety.get("safety_score", 80.0)
                safety_rating = suburb_safety.get("safety_rating", "Moderate Safety")

                # Fetch user feedback history from Firestore E.g., history/{user_id}/visited_routes
                feedback_list = []
                fb_docs = db.collection("history").document(user_id).collection("visited_routes").stream()
                for doc in fb_docs:
                    d = doc.to_dict()
                    fb = d.get("feedback", {})
                    route = d.get("route_details", {})
                    if fb:
                        feedback_list.append({
                            "rating": fb.get("rating"),
                            "text": fb.get("text"),
                            "suggestion": fb.get("suggestion"),
                            "route_name": route.get("name", "Unknown Route"),
                            "timestamp": d.get("timestamp", "")
                        })
                
                feedback_list.sort(key=lambda x: x.get("timestamp", ""), reverse=True)
                feedback_list = feedback_list[:5]

                feedback_str_list = []
                for idx, fb in enumerate(feedback_list, 1):
                    feedback_str_list.append(
                        f"Trip {idx}: Rating: {fb['rating']}/5, Comment: '{fb['text']}', "
                        f"Route: '{fb['route_name']}', Suggestion: '{fb['suggestion']}'"
                    )
                feedback_context = "\n".join(feedback_str_list) if feedback_str_list else "No recent trip feedbacks logged."

                current_safety_context = f"""
Current Location Details:
- Closest Suburb: {closest_suburb} (Distance: {dist:.2f} km)
- Safety Score: {safety_score}/100
- Safety Rating: {safety_rating}
- Coordinates Missing: {coords_missing} (If True, remind the user to enable location/GPS services for current location scoring, noting Deccan is used as fallback)

Recent User Trip Feedbacks:
{feedback_context}
"""
            except Exception as ex:
                print(f"[AIService] Error fetching current location safety: {ex}")
                current_safety_context = "\nError fetching current location safety statistics.\n"

        location_context = ""
        if lat is not None and lng is not None:
            location_context = f"""
User current coordinates:
Latitude: {lat}
Longitude: {lng}
"""

        prompt = f"""
You are SafeHer AI, a women's personal safety assistant.

Your task is to analyze the user's message and determine if they want to perform an action. You MUST return your response as a valid JSON object.

Available Actions:
1. "ADD_GUARDIAN": If the user explicitly wants to add a trusted contact, guardian, or emergency contact.
   - Parameters: {{"name": "Name of guardian", "phone": "Phone number with country code (e.g. +919876543210)", "relation": "relationship, e.g. Mom, Dad, Sister, Friend"}}
2. "START_TRACKING": If the user wants to start tracking, monitoring, or sharing their journey, walk, or run.
   - Parameters: {{"destination": "Destination name if specified, otherwise empty string"}}
3. "ALERT_GUARDIANS": If the user states they are in danger, need help immediately, are being followed, or want to trigger SOS.
   - Parameters: {{}}
4. "NONE": For general questions, safety advice, small talk, self-defense tips, or safety score queries.
   - Parameters: {{}}

Rules:
- Only answer questions or execute actions related to personal safety, self-defense, harassment prevention, travel safety, emergency advice, or safe routes.
- If the query is unrelated to safety, set "action" to "NONE" and respond: "I can only answer questions related to personal safety."

Specific Suburb Safety Query Instructions:
- If suburb safety context is provided (e.g., Swargate), you MUST present:
  1. The suburb name, safety score, and safety rating.
  2. The crime counts/statistics (total registered incidents, day incidents, and night incidents).
  3. The top crime categories reported in that suburb.
  4. A clear daytime/nighttime travel recommendation (e.g. recommending traveling during the day if night incidents are high or safety rating is Caution Advised).
- Present this information in a friendly, conversational, and highly structured format (using bullet points).

Current Location Safety Query Instructions:
- If the user asks about their current safety score/rating:
  1. Present the current suburb name, safety score, and safety rating.
  2. If coordinates are missing (indicated by Coordinates Missing: True), remind the user to enable location/GPS services and note that Deccan is used as fallback.
  3. Provide personalized safety suggestions incorporating their past trip feedback history (e.g., if they previously rated a route low or commented on poor lighting, connect it to their current environment with actionable advice).

Output Format:
You must return a valid JSON object. Do NOT wrap it in any Markdown code blocks or include extra text outside the JSON. Just output the JSON.
{{
  "action": "ACTION_NAME",
  "parameters": {{ ... }},
  "reply": "Your friendly, conversational response to the user here."
}}

{location_context}
{suburb_safety_context}
{current_safety_context}

User message:
"{message}"
"""
        try:
            response = model.generate_content(prompt)
            raw_text = response.text.strip()

            # Clean markdown wrappers if returned
            raw_text = re.sub(r"^```(?:json)?\s*", "", raw_text, flags=re.IGNORECASE)
            raw_text = re.sub(r"\s*```$", "", raw_text, flags=re.IGNORECASE)
            raw_text = raw_text.strip()

            parsed = json.loads(raw_text)
            action = parsed.get("action", "NONE")
            parameters = parsed.get("parameters", {})
            reply = parsed.get("reply", "")
        except Exception as e:
            print(f"[AIService] Gemini API call or parsing failed: {e}. Falling back to rule-based parser.")
            
            # --- LOCAL RULE-BASED FALLBACK PARSER ---
            # 1. ADD_GUARDIAN fallback
            phone_match = re.search(r'\+?\d{10,12}', message)
            if ("add" in message_lower or "guardian" in message_lower or "contact" in message_lower) and phone_match:
                action = "ADD_GUARDIAN"
                phone = phone_match.group(0)
                # Heuristic for name
                name_match = re.search(r'(?:add|name is|contact)\s+([A-Z][a-zA-Z]+)', message)
                name = name_match.group(1) if name_match else "Guardian"
                # Heuristic for relation
                relation = "Trusted Contact"
                for rel in ["mom", "dad", "sister", "brother", "friend", "spouse", "mother", "father"]:
                    if rel in message_lower:
                        relation = rel.capitalize()
                        break
                parameters = {"name": name, "phone": phone, "relation": relation}
                reply = f"I am adding {name} as your trusted guardian."
            
            # 2. ALERT_GUARDIANS fallback
            elif any(x in message_lower for x in ["help", "unsafe", "danger", "sos", "alert", "follow"]):
                action = "ALERT_GUARDIANS"
                parameters = {}
                reply = "🚨 I have triggered your SOS! An emergency alert has been sent to your trusted guardians with your live location coordinates."

            # 3. START_TRACKING fallback
            elif any(x in message_lower for x in ["track", "monitor", "walk", "journey", "route"]):
                action = "START_TRACKING"
                dest_match = re.search(r'(?:to|dest|destination)\s+([a-zA-Z\s]+)', message)
                dest = dest_match.group(1).strip() if dest_match else ""
                parameters = {"destination": dest}
                reply = f"I will start tracking your journey to {dest}." if dest else "I will start tracking your journey."

            # 4. SAFETY SCORE fallback
            elif asking_about_safety or matched_suburb:
                action = "NONE"
                parameters = {}
                
                replies = []
                if matched_suburb:
                    # Construct detailed suburb safety text
                    try:
                        suburb_safety = CrimeService.calculate_route_safety([matched_suburb])
                        safety_score = suburb_safety.get("safety_score", 80.0)
                        safety_rating = suburb_safety.get("safety_rating", "Moderate Safety")
                        morning_stats = CrimeService.get_crime_stats(matched_suburb, "Morning", 6, 12)
                        afternoon_stats = CrimeService.get_crime_stats(matched_suburb, "Afternoon", 12, 17)
                        evening_stats = CrimeService.get_crime_stats(matched_suburb, "Evening", 17, 22)
                        night_stats = CrimeService.get_crime_stats(matched_suburb, "Night", 22, 6)
                        day_crimes = morning_stats.get("period_crimes", 0) + afternoon_stats.get("period_crimes", 0) + evening_stats.get("period_crimes", 0)
                        night_crimes = night_stats.get("period_crimes", 0)
                        total_crimes = morning_stats.get("total_crimes", 0)
                        crime_breakdown = morning_stats.get("breakdown", {})
                        sorted_breakdown = sorted(crime_breakdown.items(), key=lambda x: x[1], reverse=True)[:5]
                        breakdown_str = ", ".join([f"{k}: {v}" for k, v in sorted_breakdown]) if sorted_breakdown else "No records"
                        
                        rec = "Traveling during the daytime is highly recommended." if night_crimes > day_crimes or safety_score < 75 else "The safety conditions are moderate for travel."
                        
                        replies.append(
                            f"Safety analysis for **{matched_suburb}**:\n"
                            f"- **Safety Score**: {safety_score}/100 ({safety_rating})\n"
                            f"- **Total Registered Incidents**: {total_crimes}\n"
                            f"  - Daytime Incidents (06:00 - 22:00): {day_crimes}\n"
                            f"  - Nighttime Incidents (22:00 - 06:00): {night_crimes}\n"
                            f"- **Top Crime Types**: {breakdown_str}\n"
                            f"- **Travel Recommendation**: {rec}"
                        )
                    except Exception as e_sub:
                        replies.append(f"Safety score details for {matched_suburb} are currently unavailable.")
                
                if asking_about_safety or (lat is not None and lng is not None and not matched_suburb):
                    try:
                        coords_missing = (lat is None or lng is None)
                        lat_val = lat if lat is not None else 18.5168
                        lng_val = lng if lng is not None else 73.8441
                        closest_suburb, dist = CrimeService.get_closest_area(lat_val, lng_val)
                        suburb_safety = CrimeService.calculate_route_safety([closest_suburb])
                        safety_score = suburb_safety.get("safety_score", 80.0)
                        safety_rating = suburb_safety.get("safety_rating", "Moderate Safety")
                        
                        loc_part = f"Current location safety analysis (closest suburb: **{closest_suburb}**, dist: {dist:.2f} km):\n"
                        loc_part += f"- **Safety Score**: {safety_score}/100\n"
                        loc_part += f"- **Safety Rating**: {safety_rating}\n"
                        if coords_missing:
                            loc_part += "- **Note**: GPS coordinates were not provided, Deccan is used as fallback. Please enable GPS services.\n"
                        
                        # Add feedback suggestions
                        # Fetch user feedback history from Firestore
                        feedback_list = []
                        fb_docs = db.collection("history").document(user_id).collection("visited_routes").stream()
                        for doc in fb_docs:
                            d = doc.to_dict()
                            fb = d.get("feedback", {})
                            if fb:
                                feedback_list.append(fb.get("suggestion", ""))
                        
                        feedback_list = [f for f in feedback_list if f]
                        if feedback_list:
                            loc_part += f"- **Personalized Suggestion**: Based on your previous trips, remember: {feedback_list[0]}"
                        else:
                            loc_part += "- **Personalized Suggestion**: Keep sharing your journey and rating routes to get custom safety tips!"
                        
                        replies.append(loc_part)
                    except Exception as e_loc:
                        replies.append("Current safety score details are currently unavailable.")
                
                reply = "\n\n".join(replies)

            # 5. General fallback
            else:
                action = "NONE"
                parameters = {}
                reply = "I'm here as your safety companion. I can help you check safety scores for suburbs or locations (e.g. Swargate, Deccan), track your route, add guardians, or trigger emergency alerts."

        # --- EXECUTE ACTIONS ---
        if action == "ADD_GUARDIAN":
            name = parameters.get("name")
            phone = parameters.get("phone")
            relation = parameters.get("relation", "Trusted Contact")
            if name and phone:
                try:
                    phone_clean = phone.strip().replace(" ", "")
                    doc_ref = db.collection("users").document(user_id).collection("guardians").document(phone_clean)
                    doc_ref.set({
                        "name": name,
                        "phone": phone_clean,
                        "relation": relation,
                        "added_at": datetime.now(timezone.utc).isoformat()
                    })
                    reply = f"I have successfully added {name} ({phone_clean}, {relation}) to your trusted guardians!"
                except Exception as ex:
                    print(f"[AIService] Error adding guardian: {ex}")
                    reply = f"I tried to add {name} as a guardian, but ran into a database error."
            else:
                reply = "I'd love to add a guardian for you, but I couldn't find both a name and a phone number in your message. Please try saying: 'Add [Name] with phone [Number]'."

        elif action == "START_TRACKING":
            from agents.sync_agent import run_synchronization_agent
            session_id = f"chat_{uuid.uuid4().hex[:8]}"
            dest = parameters.get("destination", "Destination")
            lat_val = lat if lat is not None else 18.5204 # Default center fallback if null
            lng_val = lng if lng is not None else 73.8567
            route_details = {
                "name": f"Walk to {dest}" if dest else "Monitored Walk",
                "safety_score": 100.0,
                "distance": 0.0,
                "duration": 0.0,
                "start_suburb": "Current Location",
                "end_suburb": dest or "Destination"
            }
            try:
                run_synchronization_agent(
                    user_id=user_id,
                    session_id=session_id,
                    lat=lat_val,
                    lon=lng_val,
                    safety_score=100.0,
                    action="track",
                    route_details=route_details
                )
                parameters["session_id"] = session_id
                reply = f"I've started active tracking for your walk to {dest}. I'm keeping an eye on your journey." if dest else "I've started active tracking for your walk. I'll monitor your coordinates!"
            except Exception as ex:
                print(f"[AIService] Error starting tracking session: {ex}")
                reply = "I tried to start tracking your route, but encountered a system error."

        elif action == "ALERT_GUARDIANS":
            from agents.emergency_agent import run_emergency_agent
            lat_val = lat if lat is not None else 18.5204
            lng_val = lng if lng is not None else 73.8567
            try:
                run_emergency_agent(user_id, lat_val, lng_val)
                reply = "🚨 I have triggered your SOS! An emergency alert has been sent to your trusted guardians with your live location coordinates."
            except Exception as ex:
                print(f"[AIService] Error triggering emergency SOS: {ex}")
                reply = "🚨 I detected danger and tried to trigger your SOS, but ran into an issue. Please press the big red SOS button on your screen immediately!"

        return {
            "action": action,
            "parameters": parameters,
            "reply": reply
        }