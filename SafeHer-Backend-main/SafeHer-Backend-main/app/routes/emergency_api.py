from flask import Blueprint, request, jsonify
from agents.emergency_agent import run_emergency_agent

emergency_bp = Blueprint("emergency", __name__)

@emergency_bp.route("/sos", methods=["POST"])
def sos():

    data = request.get_json()

    user_id = data.get("user_id")
    lat = data.get("lat")
    lon = data.get("lon")

    result = run_emergency_agent(user_id, lat, lon)

    return jsonify(result)