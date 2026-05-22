
from flask import Blueprint, request, jsonify
from services.ai_service import AIService

ai_bp = Blueprint("ai_api", __name__)


@ai_bp.route("/chat", methods=["POST"])
def chat():

    data = request.json or {}

    message = data.get("message")
    user_id = data.get("user_id", "gZjd2nm5MKPF20xJll9srBfoVao1")
    lat = data.get("lat")
    lng = data.get("lng")

    result = AIService.generate_reply(message, user_id, lat, lng)

    return jsonify(result)

