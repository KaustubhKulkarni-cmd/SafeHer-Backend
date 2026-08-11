import os
from dotenv import load_dotenv
from firebase_admin import messaging
from config.firebase_config import db

load_dotenv()


def send_sos_notification(user_id, lat, lon, user_name="A user"):
    """
    Send FCM push notifications to all guardians who have the app installed.
    Fetches FCM tokens from Firestore: users/{guardian_uid}/fcm_tokens collection
    OR from the guardian document's 'fcm_token' field.
    """

    title = "🚨 SAFEHER EMERGENCY ALERT"
    body = f"{user_name} may be in danger! Location: https://maps.google.com/?q={lat},{lon} - Please check immediately."

    # Collect FCM tokens from guardians
    fcm_tokens = []

    try:
        guardians_ref = db.collection("users").document(user_id).collection("guardians").stream()
        for g in guardians_ref:
            g_data = g.to_dict()
            token = g_data.get("fcm_token")
            if token:
                fcm_tokens.append(token)
    except Exception as e:
        print(f"Error fetching guardian FCM tokens: {e}")

    if not fcm_tokens:
        print("No FCM tokens found for guardians. No push notifications sent.")
        return None

    # Send to all tokens
    success_count = 0
    fail_count = 0

    for token in fcm_tokens:
        try:
            message = messaging.Message(
                notification=messaging.Notification(
                    title=title,
                    body=body,
                ),
                data={
                    "type": "SOS_ALERT",
                    "user_id": user_id,
                    "user_name": user_name,
                    "lat": str(lat),
                    "lon": str(lon),
                    "map_url": f"https://maps.google.com/?q={lat},{lon}",
                },
                token=token,
                android=messaging.AndroidConfig(
                    priority="high",
                    notification=messaging.AndroidNotification(
                        channel_id="sos_alerts",
                        priority="max",
                        sound="default",
                    ),
                ),
            )
            response = messaging.send(message)
            print(f"FCM sent successfully: {response}")
            success_count += 1
        except Exception as e:
            print(f"FCM send error for token {token[:20]}...: {e}")
            fail_count += 1

    print(f"FCM Results: {success_count} sent, {fail_count} failed")
    return {"success": success_count, "failed": fail_count}
