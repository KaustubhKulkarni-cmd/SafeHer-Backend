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
https://maps.google.com/?q={lat},{lon}
Please check immediately.
"""

    message = client.messages.create(
        body=message,
        from_=TWILIO_PHONE,
        to=phone_number
    )

    return message.sid