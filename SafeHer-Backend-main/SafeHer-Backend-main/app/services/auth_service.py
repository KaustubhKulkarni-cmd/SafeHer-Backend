import datetime

import requests
import os
from dotenv import load_dotenv

import json

load_dotenv()

FIREBASE_API_KEY = os.getenv("FIREBASE_API_KEY")
FIREBASE_PROJECT_ID = os.getenv("FIREBASE_PROJECT_ID")

# Automatically resolve FIREBASE_PROJECT_ID from FIREBASE_SERVICE_ACCOUNT or service_account.json if not set
if not FIREBASE_PROJECT_ID:
    # 1. Try from FIREBASE_SERVICE_ACCOUNT environment variable
    firebase_json = os.getenv("FIREBASE_SERVICE_ACCOUNT")
    if firebase_json:
        try:
            cred_dict = json.loads(firebase_json)
            FIREBASE_PROJECT_ID = cred_dict.get("project_id")
        except Exception as e:
            print(f"Error parsing FIREBASE_SERVICE_ACCOUNT for project ID: {e}")

    # 2. Try from local service_account.json file
    if not FIREBASE_PROJECT_ID:
        try:
            key_path = os.getenv("FIREBASE_KEY_PATH", "service_account.json")
            base_dir = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
            full_path = os.path.join(base_dir, key_path)
            if os.path.exists(full_path):
                with open(full_path, "r") as f:
                    cred_dict = json.load(f)
                    FIREBASE_PROJECT_ID = cred_dict.get("project_id")
        except Exception as e:
            print(f"Error reading local service_account.json for project ID: {e}")

globalUID = 0

def login_user(email, password):

    url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={FIREBASE_API_KEY}"

    payload = {
        "email": email,
        "password": password,
        "returnSecureToken": True
    }

    response = requests.post(url, json=payload)

    if response.status_code == 200:
        return True
    else:
        return False
    

def signup_user(email, password, name, phone):

    # Step 1 → Create user in Firebase Auth
    signup_url = f"https://identitytoolkit.googleapis.com/v1/accounts:signUp?key={FIREBASE_API_KEY}"

    payload = {
        "email": email,
        "password": password,
        "returnSecureToken": True
    }

    response = requests.post(signup_url, json=payload)

    if response.status_code != 200:
        return {"success": False, "message": response.json()}

    data = response.json()

    uid = data["localId"]
    globalUID = uid
    id_token = data["idToken"]

    # Step 2 → Store data in Firestore using the Admin SDK (bypasses security rules)
    try:
        from config.firebase_config import db
        db.collection("users").document(uid).set({
            "name": name,
            "email": email,
            "phone": phone,
            "date_of_joining": datetime.datetime.now().isoformat()
        })
        return {"success": True, "uid": uid}
    except Exception as e:
        return {"success": False, "message": f"Firestore Admin SDK Error: {str(e)}"}
    
