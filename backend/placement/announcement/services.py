import firebase_admin
from firebase_admin import messaging
from announcement.models import FacultyFCMToken, StudentFCMToken


from firebase_admin import credentials, messaging
from django.conf import settings

def initialize_firebase():
    if not firebase_admin._apps:  # Check if Firebase is already initialized
        try:
            cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS)
            firebase_admin.initialize_app(cred)
        except Exception as e:
            print(f"Firebase initialization error: {e}")

def send_push_notification(registration_token, title, body, data=None):
    initialize_firebase()
    try:
        message = messaging.Message(
            token=registration_token,
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            data=data,
        )
        response = messaging.send(message)
        print(f"Successfully sent message: {response}")
        return response
    except Exception as e:
        print(f"Error sending message: {e}")
        return None