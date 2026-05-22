from datetime import datetime, timezone
from config.firebase_config import db

def run_history_logging(user_id, session_id, route_details, rating, feedback_text, suggestion=None):
    """
    Logs the user's completed route details and feedback to Firestore.
    Path: history -> user_id -> visited_routes -> document
    """
    trip_data = {
        "session_id": session_id,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "route_details": route_details,
        "feedback": {
            "rating": rating,
            "text": feedback_text,
            "suggestion": suggestion or "No specific concerns reported. Safe travels!"
        }
    }
    
    try:
        db.collection("history").document(user_id).collection("visited_routes").add(trip_data)
        print(f"Logged trip history successfully for user {user_id}")
        return {"success": True}
    except Exception as e:
        print(f"Error logging trip history: {e}")
        return {"success": False, "error": str(e)}
