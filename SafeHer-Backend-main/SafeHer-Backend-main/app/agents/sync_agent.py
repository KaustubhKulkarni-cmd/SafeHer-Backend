from typing import TypedDict, Optional
from langgraph.graph import StateGraph, END
from agents.safety_agent import run_safety_analysis
from agents.emergency_agent import run_emergency_agent
from agents.feedback_agent import run_feedback_analysis
from agents.history_agent import run_history_logging
from config.firebase_config import db

class SyncState(TypedDict):
    user_id: str
    session_id: str
    lat: float
    lon: float
    safety_score: float
    status: str
    show_safe_check: bool
    action: str  # 'track', 'feedback', 'respond_safe'
    rating: Optional[int]
    feedback_text: Optional[str]
    route_details: Optional[dict]
    is_safe: Optional[bool]
    contacts_alerted: bool

# --- Node 1: Safety Node ---
def check_safety(state: SyncState):
    print(f"[SyncAgent] Running safety node for session {state['session_id']}")
    
    if state["action"] == "feedback":
        return state
    
    if state["action"] == "respond_safe":
        session_ref = db.collection("tracking_sessions").document(state["session_id"])
        session_doc = session_ref.get()
        if session_doc.exists:
            session_data = session_doc.to_dict()
            session_data["status"] = "active"
            session_data["warning_sent_time"] = None
            session_ref.set(session_data)
        state["status"] = "active"
        state["show_safe_check"] = False
        return state

    result = run_safety_analysis(
        user_id=state["user_id"],
        session_id=state["session_id"],
        lat=state["lat"],
        lon=state["lon"],
        safety_score=state["safety_score"]
    )
    
    state["show_safe_check"] = result["show_safe_check"]
    state["status"] = result["status"]
    return state

# --- Node 2: Emergency Node ---
def trigger_emergency(state: SyncState):
    print(f"[SyncAgent] Escalating to Emergency Node for session {state['session_id']}")
    
    emergency_result = run_emergency_agent(
        user_id=state["user_id"],
        lat=state["lat"],
        lon=state["lon"]
    )
    
    state["contacts_alerted"] = emergency_result.get("contacts_alerted", True)
    state["status"] = "emergency"
    return state

# --- Node 3: Feedback & History Node ---
def process_feedback_and_history(state: SyncState):
    print(f"[SyncAgent] Logging History & Feedback Node for session {state['session_id']}")
    
    rating = state.get("rating", 5)
    feedback_text = state.get("feedback_text", "")
    route_details = state.get("route_details", {})
    
    # Run Feedback Learning Agent
    fb_res = run_feedback_analysis(
        user_id=state["user_id"],
        session_id=state["session_id"],
        rating=rating,
        feedback_text=feedback_text,
        route_details=route_details
    )
    
    suggestion = fb_res.get("suggestion", "No specific concerns reported. Safe travels!")
    
    # Run History Keeping Agent
    run_history_logging(
        user_id=state["user_id"],
        session_id=state["session_id"],
        route_details=route_details,
        rating=rating,
        feedback_text=feedback_text,
        suggestion=suggestion
    )
    
    session_ref = db.collection("tracking_sessions").document(state["session_id"])
    if session_ref.get().exists:
        session_ref.update({"status": "completed"})
        
    state["status"] = "completed"
    return state

# --- Routing Logic ---
def route_sync(state: SyncState):
    if state["action"] == "feedback":
        return "feedback_node"
    if state["status"] == "emergency":
        return "emergency_node"
    return END

def build_sync_graph():
    graph = StateGraph(SyncState)
    
    graph.add_node("check_safety", check_safety)
    graph.add_node("emergency_node", trigger_emergency)
    graph.add_node("feedback_node", process_feedback_and_history)
    
    graph.set_entry_point("check_safety")
    
    graph.add_conditional_edges(
        "check_safety",
        route_sync,
        {
            "emergency_node": "emergency_node",
            "feedback_node": "feedback_node",
            END: END
        }
    )
    
    graph.add_edge("emergency_node", END)
    graph.add_edge("feedback_node", END)
    
    return graph.compile()

sync_graph = build_sync_graph()

def run_synchronization_agent(user_id, session_id, lat, lon, safety_score, action="track", rating=5, feedback_text="", route_details=None):
    """
    Invokes the Sync Agent graph to orchestrate tracking, safety, and feedback logic.
    """
    initial_state = {
        "user_id": user_id,
        "session_id": session_id,
        "lat": lat,
        "lon": lon,
        "safety_score": safety_score,
        "status": "active",
        "show_safe_check": False,
        "action": action,
        "rating": rating,
        "feedback_text": feedback_text,
        "route_details": route_details or {},
        "is_safe": True,
        "contacts_alerted": False
    }
    
    result = sync_graph.invoke(initial_state)
    return result
