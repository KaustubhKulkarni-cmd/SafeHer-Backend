import os
import json
from datetime import datetime, timezone
import google.generativeai as genai
from config.firebase_config import db

def run_feedback_analysis(user_id, session_id, rating, feedback_text, route_details=None):
    """
    Analyzes user feedback text using Gemini to extract safety concerns.
    Saves feedback intelligence under Firestore 'feedback_suggestions'.
    """
    genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
    model = genai.GenerativeModel("gemini-2.5-flash")
    
    prompt = f"""
You are the SafeHer Feedback Learning Agent.
Analyze the user's route feedback and extract any safety hazards, alerts, or positive indicators.

Feedback Rating: {rating}/5
User Feedback text: "{feedback_text}"

Format your response as a valid JSON object with the following structure:
{{
  "safety_concern": true/false,
  "categories": ["poor lighting", "harassment", "closed road", etc.],
  "suggestion": "A helpful guidance message for future travelers passing through this area"
}}
Return ONLY the raw JSON text. No markdown, no ```json tags.
"""
    
    suggestion_data = {
        "user_id": user_id,
        "session_id": session_id,
        "rating": rating,
        "feedback_text": feedback_text,
        "safety_concern": False,
        "categories": [],
        "suggestion": "No specific concerns reported. Safe travels!"
    }
    
    try:
        response = model.generate_content(prompt)
        text = response.text.strip()
        
        # Strip any code block fences if added
        if text.startswith("```json"):
            text = text[7:]
        elif text.startswith("```"):
            text = text[3:]
        if text.endswith("```"):
            text = text[:-3]
        text = text.strip()
        
        analysis = json.loads(text)
        suggestion_data.update({
            "safety_concern": analysis.get("safety_concern", False),
            "categories": analysis.get("categories", []),
            "suggestion": analysis.get("suggestion", suggestion_data["suggestion"])
        })
    except Exception as e:
        print(f"Error parsing feedback AI output: {e}")
        
    try:
        db.collection("feedback_suggestions").add({
            "user_id": user_id,
            "session_id": session_id,
            "rating": rating,
            "feedback_text": feedback_text,
            "safety_concern": suggestion_data["safety_concern"],
            "categories": suggestion_data["categories"],
            "suggestion": suggestion_data["suggestion"],
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "route_details": route_details
        })
    except Exception as e:
        print(f"Error storing feedback suggestion: {e}")
        
    return suggestion_data
