

from rest_framework.response import Response
from rest_framework import generics, status
from django.utils.timezone import now, timedelta
from .serializers import AnnouncementSerializer
from .models import PublicAnnouncement
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import FacultyFCMToken, StudentFCMToken
from .serializers import FacultyFCMTokenSerializer, StudentFCMTokenSerializer
from student.models import Student_details
from faculty.models import Faculty_auth
from django.http import JsonResponse
from firebase_admin import messaging
# from .services import firebase_admin 
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
    Sends a push notification to all faculty and student users using Firebase HTTP v1 API.
    """

    # Load Firebase credentials
    cred = credentials.Certificate("firebase_credentials.json")
    project_id = cred.project_id

    # Firebase API endpoint
    url = f"https://fcm.googleapis.com/v1/projects/{project_id}/messages:send"

    # Get FCM tokens
    faculty_tokens = list(FacultyFCMToken.objects.values_list('token', flat=True))
    student_tokens = list(StudentFCMToken.objects.values_list('token', flat=True))
    all_tokens = faculty_tokens + student_tokens

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
            print(f" Sent Announcement notification successfully")
        else:
            print(f" Failed to send Announcement notification")



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
            

            # Return success response
            return Response({
                "message": "Announcement posted successfully.",
                # "announcement": AnnouncementSerializer(announcement).data,
                # "notification_status": "sent"
            }, status=status.HTTP_201_CREATED)
            
        except Exception as e:
            print(f"\n Error creating announcement: {str(e)}")
            return Response({
                "message": "Error creating announcement",
                "error": str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class AnnouncementEdit(generics.RetrieveUpdateDestroyAPIView):
    queryset = PublicAnnouncement.objects.all()
    serializer_class = AnnouncementSerializer   



class FacultyFCMTokenView(APIView):
    def post(self, request):
        faculty_id = request.data.get('faculty')
        token = request.data.get('token')

        try:
            faculty = Faculty_auth.objects.get(pk=faculty_id)
        except Faculty_auth.DoesNotExist:
            return Response({'error': 'Faculty not found'}, status=status.HTTP_404_NOT_FOUND)

        fcm_token, created = FacultyFCMToken.objects.get_or_create(faculty=faculty, token=token)
        serializer = FacultyFCMTokenSerializer(fcm_token)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

# class StudentFCMTokenView(APIView):
#     def post(self, request):
#         student_id = request.data.get('student')
#         token = request.data.get('token')

#         try:
#             student = Student_auth.objects.get(pk=student_id)
#         except Student_auth.DoesNotExist:
#             return Response({'error': 'Student not found'}, status=status.HTTP_404_NOT_FOUND)

#         fcm_token, created = StudentFCMToken.objects.get_or_create(student=student, token=token)
#         serializer = StudentFCMTokenSerializer(fcm_token)
#         return Response(serializer.data, status=status.HTTP_201_CREATED)
    


class StudentFCMTokenView(APIView):
    def post(self, request):
        student_idno = request.data.get('student_idno')
        token = request.data.get('token')

        try:
            # Verify that the student exists
            Student_details.objects.get(id_no=student_idno)
            
            fcm_token, created = StudentFCMToken.objects.get_or_create(
                student_idno=student_idno, 
                token=token
            )
            
            serializer = StudentFCMTokenSerializer(fcm_token)
            return Response({
                'message': 'FCM token saved successfully',
                'data': serializer.data
            }, status=status.HTTP_201_CREATED)
            
        except Student_details.DoesNotExist:
            return Response({
                'error': 'Student not found',
                'message': f'No student found with ID: {student_idno}'
            }, status=status.HTTP_404_NOT_FOUND)
    
    

