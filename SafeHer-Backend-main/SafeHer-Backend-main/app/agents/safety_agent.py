from datetime import datetime, timezone
import math
from config.firebase_config import db

def calculate_distance(lat1, lon1, lat2, lon2):
    """Calculates distance in meters between two coordinates."""
    R = 6371000.0  # Earth's radius in meters
    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lon2 - lon1)
    a = math.sin(delta_phi / 2.0)**2 + math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2.0)**2
    c = 2.0 * math.atan2(math.sqrt(a), math.sqrt(1.0 - a))
    return R * c

def run_safety_analysis(user_id, session_id, lat, lon, safety_score):
    """
    Analyzes user safety score and movement anomalies.
    Returns:
      dict: { 'show_safe_check': bool, 'status': str }
    """
    session_ref = db.collection("tracking_sessions").document(session_id)
    session_doc = session_ref.get()
    
    now = datetime.now(timezone.utc)
    
    if not session_doc.exists:
        # Create a new tracking session
        session_data = {
            "user_id": user_id,
            "session_id": session_id,
            "status": "active",
            "start_time": now.isoformat(),
            "last_update_time": now.isoformat(),
            "last_moved_time": now.isoformat(),
            "last_lat": lat,
            "last_lon": lon,
            "warning_sent_time": None,
            "emergency_triggered_time": None,
            "safety_score": safety_score
        }
        session_ref.set(session_data)
        return {"show_safe_check": False, "status": "active"}

    session_data = session_doc.to_dict()
    status = session_data.get("status", "active")
    
    if status in ["completed", "emergency"]:
        return {"show_safe_check": False, "status": status}
        
    last_lat = session_data.get("last_lat")
    last_lon = session_data.get("last_lon")
    last_moved_time_str = session_data.get("last_moved_time")
    warning_sent_time_str = session_data.get("warning_sent_time")
    
    last_moved_time = datetime.fromisoformat(last_moved_time_str)
    
    # Check for movement anomaly (stationary for 10 minutes = 600s)
    dist = calculate_distance(lat, lon, last_lat, last_lon)
    movement_anomaly = False
    
    if dist > 20.0:
        session_data["last_moved_time"] = now.isoformat()
        session_data["last_lat"] = lat
        session_data["last_lon"] = lon
    else:
        elapsed_seconds = (now - last_moved_time).total_seconds()
        if elapsed_seconds >= 180.0:
            movement_anomaly = True
            
    # Check safety score anomaly (< 50)
    score_anomaly = (safety_score < 70.0)
    
    show_safe_check = False
    
    if status == "active":
        if score_anomaly or movement_anomaly:
            # Elevate to warning state
            status = "warning_sent"
            session_data["status"] = "warning_sent"
            session_data["warning_sent_time"] = now.isoformat()
            show_safe_check = True
    elif status == "warning_sent":
        # Check if user missed the 5-minute reply deadline (300s)
        if warning_sent_time_str:
            warning_sent_time = datetime.fromisoformat(warning_sent_time_str)
            elapsed_warning_seconds = (now - warning_sent_time).total_seconds()
            if elapsed_warning_seconds >= 300.0:
                # Escalation
                status = "emergency"
                session_data["status"] = "emergency"
                session_data["emergency_triggered_time"] = now.isoformat()
                
    session_data["last_update_time"] = now.isoformat()
    session_data["safety_score"] = safety_score
    session_ref.set(session_data)
    
    return {"show_safe_check": show_safe_check, "status": status}
