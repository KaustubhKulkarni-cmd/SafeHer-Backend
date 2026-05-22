from flask import Blueprint, request, jsonify
from agents.sync_agent import run_synchronization_agent
from config.firebase_config import db

monitoring_bp = Blueprint("monitoring", __name__)

@monitoring_bp.route("/start", methods=["POST"])
def start_monitoring():
    data = request.get_json() or {}
    user_id = data.get("user_id")
    session_id = data.get("session_id")
    lat = data.get("lat")
    lon = data.get("lon")
    safety_score = data.get("safety_score", 100.0)
    route_details = data.get("route_details", {})

    if not user_id or not session_id:
        return jsonify({"error": "Missing user_id or session_id"}), 400

    result = run_synchronization_agent(
        user_id=user_id,
        session_id=session_id,
        lat=lat,
        lon=lon,
        safety_score=safety_score,
        action="track",
        route_details=route_details
    )
    return jsonify(result)

@monitoring_bp.route("/update", methods=["POST"])
def update_monitoring():
    data = request.get_json() or {}
    user_id = data.get("user_id")
    session_id = data.get("session_id")
    lat = data.get("lat")
    lon = data.get("lon")
    safety_score = data.get("safety_score", 100.0)

    if not user_id or not session_id:
        return jsonify({"error": "Missing user_id or session_id"}), 400

    result = run_synchronization_agent(
        user_id=user_id,
        session_id=session_id,
        lat=lat,
        lon=lon,
        safety_score=safety_score,
        action="track"
    )
    return jsonify(result)

@monitoring_bp.route("/respond-safe", methods=["POST"])
def respond_safe():
    data = request.get_json() or {}
    user_id = data.get("user_id")
    session_id = data.get("session_id")

    if not user_id or not session_id:
        return jsonify({"error": "Missing user_id or session_id"}), 400

    result = run_synchronization_agent(
        user_id=user_id,
        session_id=session_id,
        lat=0.0,
        lon=0.0,
        safety_score=100.0,
        action="respond_safe"
    )
    return jsonify(result)

@monitoring_bp.route("/complete", methods=["POST"])
def complete_monitoring():
    data = request.get_json() or {}
    user_id = data.get("user_id")
    session_id = data.get("session_id")
    rating = data.get("rating", 5)
    feedback_text = data.get("feedback_text", "")
    route_details = data.get("route_details", {})

    if not user_id or not session_id:
        return jsonify({"error": "Missing user_id or session_id"}), 400

    result = run_synchronization_agent(
        user_id=user_id,
        session_id=session_id,
        lat=0.0,
        lon=0.0,
        safety_score=100.0,
        action="feedback",
        rating=rating,
        feedback_text=feedback_text,
        route_details=route_details
    )
    return jsonify(result)

@monitoring_bp.route("/history/<uid>", methods=["GET"])
def get_history(uid):
    try:
        # Try ordering by timestamp descending
        docs = db.collection("history").document(uid).collection("visited_routes").order_by("timestamp", direction="DESCENDING").stream()
        history_list = []
        for doc in docs:
            d = doc.to_dict()
            d["id"] = doc.id
            history_list.append(d)
        return jsonify(history_list)
    except Exception as e:
        print(f"Error fetching history with order_by: {e}. Trying in-memory sorting...")
        try:
            docs = db.collection("history").document(uid).collection("visited_routes").stream()
            history_list = []
            for doc in docs:
                d = doc.to_dict()
                d["id"] = doc.id
                history_list.append(d)
            history_list.sort(key=lambda x: x.get("timestamp", ""), reverse=True)
            return jsonify(history_list)
        except Exception as e2:
            return jsonify({"error": str(e2)}), 500