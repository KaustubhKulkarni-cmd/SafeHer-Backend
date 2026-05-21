import firebase_admin
from firebase_admin import credentials, firestore, auth
import os
from dotenv import load_dotenv

load_dotenv()

key_path = os.getenv("FIREBASE_KEY_PATH")

# Convert to absolute path
base_dir = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
full_path = os.path.join(base_dir, key_path)

cred = credentials.Certificate(full_path)

if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)

print("Firebase initialized successfully")

db = firestore.client()