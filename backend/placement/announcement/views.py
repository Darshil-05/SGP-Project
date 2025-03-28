from rest_framework.response import Response
from rest_framework import generics, status
from django.utils.timezone import now, timedelta
from .serializers import AnnouncementSerializer
from .models import PublicAnnouncement
from rest_framework.views import APIView
from user.models import UserAuth, FCMToken  # Updated import
from firebase_admin import messaging, credentials
import requests
import json

def get_firebase_access_token():
    """
    Gets the OAuth2 access token for Firebase.
    """
    from google.oauth2 import service_account
    import google.auth.transport.requests

    credentials = service_account.Credentials.from_service_account_file(
        "firebase_credentials.json",
        scopes=["https://www.googleapis.com/auth/firebase.messaging"]
    )
    
    # Request a token
    request = google.auth.transport.requests.Request()
    credentials.refresh(request)
    
    access_token = credentials.token
    return access_token

def send_push_notification(title, body):
    """
    Sends a push notification to all users using Firebase HTTP v1 API.
    """
    # Load Firebase credentials
    cred = credentials.Certificate("firebase_credentials.json")
    project_id = cred.project_id

    # Firebase API endpoint
    url = f"https://fcm.googleapis.com/v1/projects/{project_id}/messages:send"

    # Get all FCM tokens from the new FCMToken model
    all_tokens = list(FCMToken.objects.values_list('token', flat=True))

    if not all_tokens:
        print("No FCM tokens found.")
        return

    headers = {
        "Authorization": f"Bearer {get_firebase_access_token()}",
        "Content-Type": "application/json"
    }

    for token in all_tokens:
        payload = {
            "message": {
                "token": token,
                "notification": {
                    "title": title,
                    "body": body
                }
            }
        }

        response = requests.post(url, headers=headers, data=json.dumps(payload))

        if response.status_code == 200:
            print(f"Sent Announcement notification successfully")
        else:
            print(f"Failed to send Announcement notification")

class AnnouncementList(generics.ListCreateAPIView):
    queryset = PublicAnnouncement.objects.all()
    serializer_class = AnnouncementSerializer

    def create(self, request, *args, **kwargs):
        try:
            # Save announcement
            response = super().create(request, *args, **kwargs)
            announcement = self.get_queryset().latest("created_at")

            # Prepare push notification
            title = "New Announcement 📢"
            body = f"{announcement.title}: {announcement.description[:50]}..."
            
            send_push_notification(title, body)

            return Response({
                "message": "Announcement posted successfully.",
            }, status=status.HTTP_201_CREATED)
            
        except Exception as e:
            print(f"\nError creating announcement: {str(e)}")
            return Response({
                "message": "Error creating announcement",
                "error": str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class AnnouncementEdit(generics.RetrieveUpdateDestroyAPIView):
    queryset = PublicAnnouncement.objects.all()
    serializer_class = AnnouncementSerializer   

# Remove FacultyFCMTokenView and StudentFCMTokenView since FCM token management 
# is now handled in the user app


