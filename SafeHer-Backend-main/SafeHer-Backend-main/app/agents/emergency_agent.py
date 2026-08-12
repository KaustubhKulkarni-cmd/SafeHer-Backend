from datetime import datetime

from langgraph.graph import StateGraph, END
from typing import TypedDict, List, Any
from config.firebase_config import db
from services.twilio_service import send_sos_sms


class EmergencyState(TypedDict):
    user_id: str
    lat: float
    lon: float
    contacts_alerted: bool
    authorities_alerted: bool
    incident_logged: bool
    sms_results: List[Any]


# --- Step 1: Alert trusted contacts ---
def alert_contacts(state: EmergencyState):

    print("Sending SMS to trusted contacts...")

    user_name = "A SafeHer User"
    try:
        user_id = state.get("user_id")
        if user_id:
            user_ref = db.collection("users").document(user_id).get()
            if user_ref.exists:
                user_data = user_ref.to_dict()
                user_name = user_data.get("name", "A SafeHer User")
    except Exception as e:
        print(f"Error fetching user name from Firestore: {e}")

    user_id = state.get("user_id")
    contacts = []
    if user_id:
        try:
            guardians_ref = db.collection("users").document(user_id).collection("guardians").stream()
            for g in guardians_ref:
                g_data = g.to_dict()
                phone = g_data.get("phone")
                if phone:
                    contacts.append(phone)
        except Exception as e:
            print(f"Error fetching dynamic contacts from Firestore: {e}")

    if not contacts:
        contacts = [
            "+919699447120"
            #"+919373351445",
            #"+917058541200"
            #"+919021436064",
        ]

    sms_results = []

    for contact in contacts:
        res = send_sos_sms(contact, state["lat"], state["lon"], user_name=user_name)
        print(f"send_sos_sms result for {contact}: {res}")
        sms_results.append({"to": contact, **res})

    state["contacts_alerted"] = True
    state["sms_results"] = sms_results
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
        "incident_logged": False,
        "sms_results": []
    })

    return result