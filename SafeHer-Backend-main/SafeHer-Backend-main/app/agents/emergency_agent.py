from datetime import datetime

from langgraph.graph import StateGraph, END
from typing import TypedDict
from config.firebase_config import db
from services.twilio_service import send_sos_sms


class EmergencyState(TypedDict):
    user_id: str
    lat: float
    lon: float
    contacts_alerted: bool
    authorities_alerted: bool
    incident_logged: bool


# --- Step 1: Alert trusted contacts ---
def alert_contacts(state: EmergencyState):

    print("Sending SMS to trusted contacts...")

    contacts = [
        "+919699447120",
        "+919373351445"
    ]

    for contact in contacts:
        send_sos_sms(contact, state["lat"], state["lon"])

    state["contacts_alerted"] = True
    return state


# --- Step 2: Alert authorities ---
def alert_authorities(state: EmergencyState):

    print("Notifying emergency services...")

    state["authorities_alerted"] = True
    return state


# --- Step 3: Log incident ---
def log_incident(state: EmergencyState):

    print("Logging emergency incident...")

    uid = state["user_id"]

    log_data = {
        "time": datetime.utcnow(),
        "lat": state["lat"],
        "lon": state["lon"],
        "uid": uid,
        "contacts_alerted": state["contacts_alerted"]
    }

    # logs -> uid -> incident document
    db.collection("logs").document(uid).collection("incidents").add(log_data)

    state["incident_logged"] = True
    return state


# --- Build LangGraph workflow ---
def build_graph():

    graph = StateGraph(EmergencyState)

    graph.add_node("alert_contacts", alert_contacts)
    graph.add_node("alert_authorities", alert_authorities)
    graph.add_node("log_incident", log_incident)

    graph.set_entry_point("alert_contacts")

    graph.add_edge("alert_contacts", "alert_authorities")
    graph.add_edge("alert_authorities", "log_incident")
    graph.add_edge("log_incident", END)

    return graph.compile()


emergency_graph = build_graph()


def run_emergency_agent(user_id, lat, lon):

    result = emergency_graph.invoke({
        "user_id": user_id,
        "lat": lat,
        "lon": lon,
        "contacts_alerted": False,
        "authorities_alerted": False,
        "incident_logged": False
    })

    return result