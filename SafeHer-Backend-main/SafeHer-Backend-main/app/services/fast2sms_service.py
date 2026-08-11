import os
import requests
from dotenv import load_dotenv

load_dotenv()

FAST2SMS_API_KEY = os.getenv("FAST2SMS_API_KEY")

def send_sos_sms(phone_number, lat, lon, user_name="A user"):
    message = f"""SAFEHER EMERGENCY ALERT
{user_name} may be in danger.
Location:
https://maps.google.com/?q={lat},{lon}
Please check immediately."""

    # Fast2SMS requires comma separated numbers without '+'
    # Strip non-numeric characters just in case, but keep the 10 digits
    clean_phone = ''.join(filter(str.isdigit, phone_number))
    if len(clean_phone) > 10 and clean_phone.startswith("91"):
        clean_phone = clean_phone[-10:]

    url = "https://www.fast2sms.com/dev/bulkV2"
    
    payload = {
        "route": "v3",
        "sender_id": "TXTIND", # Default sender ID for Quick Transactional
        "message": message,
        "language": "english",
        "flash": 0,
        "numbers": clean_phone,
    }
    
    headers = {
        'authorization': FAST2SMS_API_KEY,
        'Content-Type': "application/x-www-form-urlencoded",
        'Cache-Control': "no-cache"
    }

    try:
        response = requests.post(url, data=payload, headers=headers)
        result = response.json()
        if result.get("return"):
            print(f"Fast2SMS Sent Successfully to {clean_phone}")
            return result.get("request_id")
        else:
            print(f"Fast2SMS Error: {result.get('message')}")
            return None
    except Exception as e:
        print(f"Fast2SMS Exception: {e}")
        return None
