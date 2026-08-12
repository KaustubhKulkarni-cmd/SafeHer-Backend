import os
from twilio.rest import Client
from dotenv import load_dotenv

load_dotenv()

ACCOUNT_SID = os.getenv("TWILIO_ACCOUNT_SID")
AUTH_TOKEN = os.getenv("TWILIO_AUTH_TOKEN")
TWILIO_PHONE = os.getenv("TWILIO_PHONE_NUMBER")

client = Client(ACCOUNT_SID, AUTH_TOKEN)


def send_sos_sms(phone_number, lat, lon, user_name="A user"):
    message = f"""
SAFEHER EMERGENCY ALERT

{user_name} may be in danger.

Location:
https://www.google.com/maps?q={lat},{lon}

Please check on them immediately.
"""

    try:
        sms = client.messages.create(
            body=message,
            from_=TWILIO_PHONE,
            to=phone_number
        )

        # Log helpful debug info for each send
        print(f"Twilio SMS sent: to={phone_number} sid={getattr(sms, 'sid', None)} status={getattr(sms, 'status', None)}")

        return {
            "success": True,
            "message_sid": sms.sid,
            "status": getattr(sms, "status", None)
        }

    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }