# Create your views here.
import pandas as pd
from django.http import HttpResponse
from rest_framework import viewsets
from rest_framework.exceptions import NotFound
from rest_framework import generics
from .models import CompanyDetails,InterviewRound,CompanyRegistration,sortlisted
from .serializers import CompanyDetailsSerializer,InterviewRoundSerializer,CompanyRegistrationSerializer,CompanyInfoSerializer
from rest_framework.response import Response
from rest_framework import status
from rest_framework import serializers
from rest_framework.views import APIView
from django.views.decorators.csrf import csrf_exempt
import logging,requests
from firebase_admin import messaging, credentials
from announcement.models import FacultyFCMToken, StudentFCMToken
import json



class ExportCompanyRegistrationData(APIView):
    
    def get(self, request, company_id):
        # Get all registrations for the given company_id
        registrations = CompanyRegistration.objects.filter(company_id=company_id).select_related('student', 'company')

        if not registrations.exists():
            return Response({"detail": "No students registered for this company."}, status=status.HTTP_404_NOT_FOUND)

        # Prepare data for each registered student
        data = []
        for reg in registrations:
            registration_info = {
                'Student ID': reg.student.id_no,
                'Student Name': f"{reg.student.first_name} {reg.student.last_name}",
                'Company Name': reg.company.company_name,
                'Registration Date': reg.registration_date,
            }
            data.append(registration_info)

        # Convert data into a Pandas DataFrame
        df = pd.DataFrame(data)

        # Create an HTTP response with Excel file format
        response = HttpResponse(content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        response['Content-Disposition'] = f'attachment; filename=students_registered_for_company_{company_id}.xlsx'

        # Write data to Excel file
        df.to_excel(response, index=False, engine='openpyxl')

        return response
# Create your views here.


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

class CompanyDetailsList(generics.ListCreateAPIView):
    

    queryset = CompanyDetails.objects.prefetch_related('interview_rounds')
    serializer_class = CompanyDetailsSerializer

    def create(self, request, *args, **kwargs):
        # Check if the request contains multiple records
        if isinstance(request.data, list):
            serializer = self.get_serializer(data=request.data, many=True)
        else:
            serializer = self.get_serializer(data=request.data)
        
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        
        # Get the latest created company
        if isinstance(request.data, list):
            company = self.get_queryset().latest("created_at")
        else:
            company = serializer.instance

        # Prepare push notification
        title = "New Company Arrived! 🏢"
        body = f"{company.company_name} has arrived for placement in CHARUSAT"

        # Send notification
        send_push_notification(title, body)

        return Response(serializer.data, status=status.HTTP_201_CREATED)

from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated

class CompanyDetailsDetail(generics.RetrieveUpdateDestroyAPIView):
  

    queryset = CompanyDetails.objects.prefetch_related('interview_rounds')
    serializer_class = CompanyDetailsSerializer

# class InterviewRoundCreateView(generics.CreateAPIView):
    
#     serializer_class = InterviewRoundSerializer

    
#     def perform_create(self, serializer):
#         company = serializer.validated_data['company']

#         last_round = InterviewRound.objects.filter(company=company).order_by('-index').first()
        
#         index = (last_round.index + 1) if last_round else 0  # Assign the next index
#         serializer.save(index=index)

# class InterviewRoundList(generics.ListCreateAPIView):
#     queryset = InterviewRound.objects.all()
#     serializer_class = InterviewRoundSerializer

# class InterviewRoundDetail(generics.RetrieveUpdateDestroyAPIView):
    
#     serializer_class = InterviewRoundSerializer
    
#     def get_queryset(self):
#         return InterviewRound.objects.all()

#     def get_object(self):
#         company_id = self.kwargs.get('company_id')
#         index = self.kwargs.get('index')

#         try:
#             return InterviewRound.objects.get(company_id=company_id, index=index)
#         except InterviewRound.DoesNotExist:
#             raise NotFound("Interview round not found for the given company_id and index.")
from rest_framework.exceptions import ValidationError, NotFound
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.exceptions import ValidationError, NotFound
from .models import InterviewRound
from .serializers import InterviewRoundSerializer

class InterviewRoundCreateView(generics.CreateAPIView):
    serializer_class = InterviewRoundSerializer

    def perform_create(self, serializer):
        company = serializer.validated_data['company']
        round_name = serializer.validated_data['round_name']

        # Check if an interview round already exists for the company
        if InterviewRound.objects.filter(company=company, round_name=round_name).exists():
            raise ValidationError({"error": "An interview round with this name already exists for this company."})

        # Assign the next index
        last_round = InterviewRound.objects.filter(company=company).order_by('-index').first()
        index = (last_round.index + 1) if last_round else 0  
        
        serializer.save(index=index)

class InterviewRoundList(generics.ListCreateAPIView):
    queryset = InterviewRound.objects.all()
    serializer_class = InterviewRoundSerializer

# class InterviewRoundDetail(generics.RetrieveUpdateDestroyAPIView):
#     authentication_classes = [JWTAuthentication]
#     permission_classes = [IsAuthenticated]
#     serializer_class = InterviewRoundSerializer

#     def get_queryset(self):
#         return InterviewRound.objects.all()

#     def get_object(self):
#         company_id = self.kwargs.get('company_id')
#         index = self.kwargs.get('index')

#         try:
#             return InterviewRound.objects.get(company_id=company_id, index=index)
#         except InterviewRound.DoesNotExist:
#             raise NotFound("Interview round not found for the given company_id and index.")

#     def patch(self, request, *args, **kwargs):
#         """Update the status of an interview round using company_id and index."""
#         interview_round = self.get_object()
        
#         # Allow updating only the status field
#         new_status = request.data.get('status')
#         if new_status is not None:
#             interview_round.status = new_status
#             interview_round.save()
#             return Response({"message": "Interview round status updated successfully!"}, status=status.HTTP_200_OK)
#         else:
#             return Response({"error": "Status field is required!"}, status=status.HTTP_400_BAD_REQUEST)




class InterviewRoundDetail(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def patch(self, request, company_id, index):
        try:
            interview_round = InterviewRound.objects.get(company_id=company_id, index=index)
        except InterviewRound.DoesNotExist:
            return Response({"error": "Interview round not found"}, status=status.HTTP_404_NOT_FOUND)

        new_status = request.data.get('status')
        if new_status is not None:
            interview_round.status = new_status
            interview_round.save()
            return Response({"message": "Interview round status updated successfully!"}, status=status.HTTP_200_OK)
        else:
            return Response({"error": "Status field is required!"}, status=status.HTTP_400_BAD_REQUEST)

class CompanyRegistrationListCreate(generics.ListCreateAPIView):
    queryset = CompanyRegistration.objects.all()
    serializer_class = CompanyRegistrationSerializer

    def get_queryset(self):
        queryset = CompanyRegistration.objects.all()
        company_id = self.request.query_params.get('company_id')

        if company_id:
            queryset = queryset.filter(company__company_id=company_id)

        return queryset

class InterviewRoundByCompanyList(generics.ListAPIView):
    serializer_class = InterviewRoundSerializer

    def get_queryset(self):
        company_id = self.kwargs.get('company_id')
        try:
            # Retrieve the company by name
            company = CompanyDetails.objects.get(company_id=company_id)
        except CompanyDetails.DoesNotExist:
            raise NotFound(f"Company '{company_id}' not found")

        # Return all interview rounds for the specified company
        return InterviewRound.objects.filter(company=company)
   


class CompanyInfoView(generics.ListAPIView):  # Using ListAPIView to allow filtering
    # serializer_class = CompanyInfoSerializer

    # def get_queryset(self):
    #     company_id = self.request.query_params.get('company_id')

    #     if company_id:
    #         return CompanyDetails.objects.filter(company_id=company_id).only(
    #             'company_name', 'date_placementdrive', 'job_location', 'job_description',
    #         )
    #     return CompanyDetails.objects.none()
    serializer_class = CompanyInfoSerializer

    def get_queryset(self):
        company_id = self.request.query_params.get('company_id')

        if company_id:
            return CompanyDetails.objects.filter(company_id=company_id)
        return CompanyDetails.objects.all()
    


class RegisteredStudentsByCompanyList(generics.ListAPIView):
    serializer_class = CompanyRegistrationSerializer
    def get_queryset(self):
        company_name = self.kwargs['company_name']
        # Filter registrations by the company name
        company = CompanyDetails.objects.filter(company_name=company_name).first()
        
        if not company:
            raise serializers.ValidationError({"company_name": "Company does not exist."})

        return CompanyRegistration.objects.filter(company=company)


from rest_framework.generics import ListAPIView, UpdateAPIView



class SortlistedStudentsByCompanyList(generics.ListAPIView):
    serializer_class = CompanyRegistrationSerializer
    def get_queryset(self):
        company_id = self.kwargs['company_id']
        # Filter sortlisted students by the company id
        company = CompanyDetails.objects.filter(company_id=company_id).first()
        
        if not company:
            raise serializers.ValidationError({"company_id": "Company does not exist."})

        return sortlisted.objects.filter(company=company)

class DeleteSortlistedStudent(APIView):
    def post(self, request, company_id):
        try:
            # Get the list of student IDs from the request body
            student_ids = request.data.get('student_ids', [])
            
            if not student_ids:
                return Response({
                    "error": "No student IDs provided in the request."
                }, status=status.HTTP_400_BAD_REQUEST)

            # Delete all students from the sortlisted table
            deleted_count = sortlisted.objects.filter(
                company_id=company_id,
                student_id_no__in=student_ids
            ).delete()[0]

            return Response({
                "message": f"Successfully deleted {deleted_count} students from sortlisted.",
                "deleted_count": deleted_count
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({
                "error": f"An error occurred while deleting students: {str(e)}"
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
