# Security Add-ons & Suggestions for SafeHer Backend

Based on the analysis of your Flask backend, here are the crucial security add-ons and best practices to implement before going to production:

## 1. CORS Configuration
**Current State:** `CORS(app)` allows cross-origin requests from any domain, which is risky.
**Action:** Restrict it to your specific frontend URL.
```python
# In main.py
CORS(app, resources={r"/api/*": {"origins": ["https://your-frontend-url.com"]}})
```

## 2. Disable Debug Mode in Production
**Current State:** `app.run(debug=True, port=5000)` runs the app in debug mode, which can expose sensitive stack traces.
**Action:** Use a production WSGI server like `gunicorn` and ensure debug is False.
*Note: I have added `gunicorn` to your requirements.txt for Render deployment.*

## 3. Rate Limiting
**Add-on:** `Flask-Limiter`
**Why:** To prevent DDoS attacks and brute-force attempts on sensitive routes like `/api/auth` and `/api/agent/emergency`.
```python
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(get_remote_address, app=app, default_limits=["200 per day", "50 per hour"])
```

## 4. HTTP Security Headers
**Add-on:** `Flask-Talisman`
**Why:** It adds important security headers like Content-Security-Policy (CSP), HTTP Strict Transport Security (HSTS), and X-Frame-Options to protect against XSS and clickjacking.

## 5. Firebase Credentials Management
**Current State:** There is a `service_account.json` file in your repository.
**Action:** NEVER commit this file to GitHub! Use environment variables to store the JSON string (often base64 encoded) or individual fields, and parse it in your application code. Add `service_account.json` to your `.gitignore`.

## 6. Input Validation
**Add-on:** `marshmallow` or `pydantic`
**Why:** Validate all incoming JSON payloads to ensure they match the expected data types and prevent SQL/NoSQL injection or application crashes.

## 7. Authentication Middleware
**Why:** Ensure all protected routes verify the Firebase Auth token or JWT before processing the request. This prevents unauthorized access to the SOS/Emergency endpoints.

---

# Render Deployment Guide

To deploy this backend to Render, follow these steps:

1. **Add `gunicorn`**: A production server is needed. I can add this for you.
2. **Push to GitHub**: Make sure all your code is pushed to a GitHub repository (excluding `.env` and `service_account.json`).
3. **Create Web Service on Render**:
   - Go to [Render Dashboard](https://dashboard.render.com/).
   - Click "New +" -> "Web Service".
   - Connect your GitHub repository.
4. **Configure Service**:
   - **Environment**: Python 3
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn "app.main:create_app()"` or `cd app && gunicorn "main:create_app()"` depending on how the working directory is set. If the root folder of the repo is `SafeHer-Backend-main`, you might need to set the Root Directory in Render.
5. **Environment Variables**:
   - Copy all variables from your `.env` file into the Render Environment tab.
   - For `service_account.json`, it's safer to store its content as an environment variable (e.g., `FIREBASE_SERVICE_ACCOUNT`) and load it via `json.loads(os.getenv("FIREBASE_SERVICE_ACCOUNT"))` rather than uploading the file.

---

# Mobile Integration (3 Taps SOS & Voice Recognition)

To use your backend API on a mobile phone (Android/iOS) and utilize hardware features:

## 1. The Mobile Frontend (Android/iOS/Flutter)
The actual logic for "3 taps of the power button" or "Voice Recognition triggering SOS" happens **on the mobile device**, not the backend.
- **Power Button (3 Taps):** You can use native OS accessibility services (like Android `AccessibilityService` or `KeyEvent` listeners in a background service) or specific plugins if using Flutter/React Native.
- **Voice Recognition:** You can use background speech-to-text libraries (like Android's `SpeechRecognizer` or iOS's `SFSpeechRecognizer`) to listen for a specific wake word like "Help" or "SOS".

## 2. Connecting to the API
Once the mobile app detects the hardware trigger (3 taps) or the voice command:
1. It gathers the current GPS coordinates of the user.
2. It makes an HTTP POST request to your Render backend API.

**Example Request from Mobile App to Render:**
```http
POST https://your-app-name.onrender.com/api/agent/emergency
Content-Type: application/json
Authorization: Bearer <Firebase_User_Token>

{
    "user_id": "12345",
    "latitude": 18.5204,
    "longitude": 73.8567,
    "trigger_type": "hardware_button"
}
```

## 3. Backend Processing
When Render receives this POST request, your Flask backend will:
1. Verify the user token.
2. Save the emergency event to Firebase Firestore.
3. Trigger any Twilio SMS or notification to nearby guardians via the endpoints you already have.

When you're ready to show me how you plan to integrate it, I can provide the exact Flutter/Android code or API adjustments you need!
