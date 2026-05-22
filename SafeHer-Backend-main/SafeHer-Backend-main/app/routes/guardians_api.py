from flask import Blueprint, request, jsonify
from config.firebase_config import db
from datetime import datetime, timezone

guardians_bp = Blueprint("guardians_api", __name__)

@guardians_bp.route("/<uid>", methods=["GET"])
def get_guardians(uid):
    try:
        guardians_ref = db.collection("users").document(uid).collection("guardians").stream()
        guardians_list = []
        for g in guardians_ref:
            d = g.to_dict()
            d["id"] = g.id
            guardians_list.append(d)
        return jsonify({"success": True, "guardians": guardians_list}), 200
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@guardians_bp.route("/add", methods=["POST"])
def add_guardian():
    data = request.get_json() or {}
    uid = data.get("uid")
    name = data.get("name")
    phone = data.get("phone")
    relation = data.get("relation", "Trusted Contact")

    if not uid or not name or not phone:
        return jsonify({"success": False, "error": "Missing uid, name, or phone"}), 400

    try:
        phone_clean = phone.strip().replace(" ", "")
        doc_ref = db.collection("users").document(uid).collection("guardians").document(phone_clean)
        doc_ref.set({
            "name": name,
            "phone": phone_clean,
            "relation": relation,
            "added_at": datetime.now(timezone.utc).isoformat()
        })
        return jsonify({"success": True, "message": "Guardian added successfully"}), 200
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

@guardians_bp.route("/delete", methods=["POST"])
def delete_guardian():
    data = request.get_json() or {}
    uid = data.get("uid")
    phone = data.get("phone")

    if not uid or not phone:
        return jsonify({"success": False, "error": "Missing uid or phone"}), 400

    try:
        phone_clean = phone.strip().replace(" ", "")
        db.collection("users").document(uid).collection("guardians").document(phone_clean).delete()
        return jsonify({"success": True, "message": "Guardian deleted successfully"}), 200
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500
