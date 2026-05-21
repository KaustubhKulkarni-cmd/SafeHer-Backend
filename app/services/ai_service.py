
# import os
# import google.generativeai as genai


# class AIService:

#     @staticmethod
#     def generate_reply(message):

#         genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

#         model = genai.GenerativeModel("gemini-2.5-flash")

#         prompt = f"""
# You are SafeHer AI, a women's personal safety assistant.

# Rules:
# - Only answer questions about safety, self-defense, harassment prevention, travel safety, emergency advice, or safe routes.
# - If the question is unrelated to safety, respond with:
#   "I can only answer questions related to personal safety."

# User question:
# {message}
# """

#         response = model.generate_content(prompt)

#         return response.text

import os
import google.generativeai as genai


class AIService:

    @staticmethod
    def generate_reply(message, lat=None, lng=None):

        genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

        model = genai.GenerativeModel("gemini-2.5-flash")

        location_context = ""

        if lat and lng:
            location_context = f"""
User current location:
Latitude: {lat}
Longitude: {lng}
"""

        prompt = f"""
You are SafeHer AI, a women's safety assistant.

Only answer questions related to:
- personal safety
- harassment prevention
- emergency advice
- safe routes
- travel safety

{location_context}

User question:
{message}
"""

        response = model.generate_content(prompt)

        return response.text