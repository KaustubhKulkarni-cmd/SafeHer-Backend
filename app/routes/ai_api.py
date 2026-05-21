
from flask import Blueprint, request, jsonify
from services.ai_service import AIService

ai_bp = Blueprint("ai_api", __name__)


@ai_bp.route("/chat", methods=["POST"])
def chat():

    data = request.json

    message = data.get("message")
    lat = data.get("lat")
    lng = data.get("lng")

    reply = AIService.generate_reply(message, lat, lng)

    return jsonify({"reply": reply})

