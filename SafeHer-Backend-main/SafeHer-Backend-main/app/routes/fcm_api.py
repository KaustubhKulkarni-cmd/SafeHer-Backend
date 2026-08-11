from flask import Blueprint, request, jsonify
from config.firebase_config import db

fcm_bp = Blueprint("fcm_api", __name__)


@fcm_bp.route("/register", methods=["POST"])
def register_fcm_token():
    """
    Save FCM token for a user.
    Called by the Flutter app on login/startup.
    Body: { "uid": "...", "fcm_token": "..." }
    """
    data = request.get_json() or {}
    uid = data.get("uid")
    fcm_token = data.get("fcm_token")

    if not uid or not fcm_token:
        return jsonify({"success": False, "error": "Missing uid or fcm_token"}), 400

    try:
        # Save the FCM token to the user's document
        db.collection("users").document(uid).set(
            {"fcm_token": fcm_token}, merge=True
        )

        # Also update FCM token in any guardian entries that reference this user
        # Find all users who have this uid as a guardian (by phone match)
        user_doc = db.collection("users").document(uid).get()
        if user_doc.exists:
            user_data = user_doc.to_dict()
            raw_user_phone = user_data.get("phone", "")
            
            # Remove all spaces to match the Guardian document IDs (e.g. "+91 123" -> "+91123")
            user_phone = raw_user_phone.replace(" ", "")

            if user_phone:
                # Search all users' guardians subcollections for this phone
                all_users = db.collection("users").stream()
                for u in all_users:
                    if u.id == uid:
                        continue
                    guardian_ref = db.collection("users").document(u.id).collection("guardians").document(user_phone)
                    guardian_doc = guardian_ref.get()
                    if guardian_doc.exists:
                        guardian_ref.set({"fcm_token": fcm_token}, merge=True)
                        print(f"Updated FCM token for guardian {user_phone} under user {u.id}")

        return jsonify({"success": True, "message": "FCM token registered"}), 200

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500
