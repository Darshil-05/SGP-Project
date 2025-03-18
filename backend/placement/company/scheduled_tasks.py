import threading
import time
from django.utils import timezone
from datetime import timedelta
from .models import CompanyDetails
from announcement.models import FacultyFCMToken, StudentFCMToken
import requests
import json
from firebase_admin import credentials

# Global flag to track if the thread is running
_thread_running = False

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
            print(f"Sent notification successfully")
        else:
            print(f"Failed to send notification")

def check_deadlines():
    """
    Checks for companies with application deadlines tomorrow and sends notifications.
    """
    global _thread_running
    _thread_running = True
    
    print("\n=== Starting Deadline Checker ===")
    print(f"Current time: {timezone.now()}")
    
    while _thread_running:
        try:
            # Get tomorrow's date
            tomorrow = timezone.now().date() + timedelta(days=1)
            print(f"\nChecking for deadlines on: {tomorrow}")
            
            # Find companies with application deadline tomorrow
            companies = CompanyDetails.objects.filter(application_deadline=tomorrow)
            print(f"Found {companies.count()} companies with deadline tomorrow")
            
            if companies.count() > 0:
                print("\nCompanies with deadlines tomorrow:")
                for company in companies:
                    print(f"- {company.company_name} (Deadline: {company.application_deadline})")
                    title = "Application Deadline Tomorrow!"
                    body = f"Last day to register for {company.company_name}"
                    
                    # Send notification
                    send_push_notification(title, body)
                    print(f"✓ Sent deadline notification for {company.company_name}")
            else:
                print("No companies found with deadlines tomorrow")
            
            print("\nWaiting for 24 hours before next check...")
            # Sleep for 24 hours before checking again
            time.sleep(24 * 60 * 60)
        except Exception as e:
            print(f"\n❌ Error in deadline checker: {str(e)}")
            time.sleep(60)  # Wait a minute before retrying if there's an error

def start_deadline_checker():
    """
    Starts the deadline checker in a background thread if it's not already running.
    """
    global _thread_running
    
    if not _thread_running:
        print("\n=== Initializing Deadline Checker ===")
        thread = threading.Thread(target=check_deadlines, daemon=True)
        thread.start()
        print("✓ Deadline checker thread started successfully")
    else:
        print("⚠ Deadline checker thread is already running") 


