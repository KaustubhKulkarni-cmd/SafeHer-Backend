import firebase_admin
from firebase_admin import credentials, firestore, auth
import os
from dotenv import load_dotenv

import json

load_dotenv()

# Try loading from JSON string (Render Environment Variable)
firebase_json = os.getenv("FIREBASE_SERVICE_ACCOUNT")

if firebase_json:
    cred_dict = json.loads(firebase_json)
    cred = credentials.Certificate(cred_dict)
else:
    # Fallback to local file path
    key_path = os.getenv("FIREBASE_KEY_PATH", "service_account.json")
    base_dir = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
    full_path = os.path.join(base_dir, key_path)
    cred = credentials.Certificate(full_path)

if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)

print("Firebase initialized successfully")

db = firestore.client()