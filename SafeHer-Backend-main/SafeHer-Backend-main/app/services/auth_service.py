import datetime

import requests
import os
from dotenv import load_dotenv

load_dotenv()

FIREBASE_API_KEY = os.getenv("FIREBASE_API_KEY")
FIREBASE_PROJECT_ID = os.getenv("FIREBASE_PROJECT_ID")
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

    # Step 2 → Store data in Firestore
    firestore_url = f"https://firestore.googleapis.com/v1/projects/{FIREBASE_PROJECT_ID}/databases/(default)/documents/users/{uid}"

    firestore_payload = {
        "fields": {
            "name": {"stringValue": name},
            "email": {"stringValue": email},
            "phone": {"stringValue": phone},
            "date_of_joining": {"stringValue": str(datetime.datetime.now())}
        }
    }

    headers = {
        "Authorization": f"Bearer {id_token}"
    }

    firestore_response = requests.patch(
        firestore_url,
        headers=headers,
        json=firestore_payload
    )

    if firestore_response.status_code in [200, 201]:
        return {"success": True, "uid": uid}
    else:
        return {"success": False, "message": firestore_response.json()}
    
