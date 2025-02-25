
# Create your views here.
from rest_framework import viewsets
from rest_framework.exceptions import NotFound
from rest_framework import generics
from .models import CompanyDetails,InterviewRound,CompanyRegistration,StudentInterviewProgress
from .serializers import CompanyDetailsSerializer,InterviewRoundSerializer,CompanyRegistrationSerializer,StudentInterviewProgress,CompanyInfoSerializer,StudentProgressSerializer
from rest_framework.response import Response
from rest_framework import status
from rest_framework import serializers
from rest_framework.views import APIView


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
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class CompanyDetailsDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = CompanyDetails.objects.prefetch_related('interview_rounds')
    serializer_class = CompanyDetailsSerializer

class InterviewRoundCreateView(generics.CreateAPIView):
    serializer_class = InterviewRoundSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            interview_round = serializer.save()
            return Response(serializer.to_representation(interview_round), status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class InterviewRoundList(generics.ListCreateAPIView):
    queryset = InterviewRound.objects.all()
    serializer_class = InterviewRoundSerializer

class InterviewRoundDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = InterviewRound.objects.all()
    serializer_class = InterviewRoundSerializer

    # views.py


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
        company_name = self.kwargs.get('company_name')
        try:
            # Retrieve the company by name
            company = CompanyDetails.objects.get(company_name=company_name)
        except CompanyDetails.DoesNotExist:
            raise NotFound(f"Company '{company_name}' not found")

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

class RetrieveEligibleStudentsView(ListAPIView):
    serializer_class = StudentProgressSerializer

    def get_queryset(self):
     company_id = self.request.query_params.get('company_id', None)
     round_id = self.request.query_params.get('round_id', None)

     if not company_id or not round_id:
        return StudentInterviewProgress.objects.none()  # Return empty if params are missing

     round_id = int(round_id)

     if round_id == 1:
        # Get students from CompanyRegistration for the first round
        registered_students = CompanyRegistration.objects.filter(company_id=company_id).values_list('student_id', flat=True)

        return StudentInterviewProgress.objects.filter(
            company_id=company_id,
            student_id__in=registered_students
        )

    # Other Rounds: Only students who passed the previous round
     previous_round_id = round_id - 1
     passed_students = StudentInterviewProgress.objects.filter(
        company_id=company_id,
        round_id=previous_round_id,
        is_passed=True
     ).values_list('student_id', flat=True)

     return StudentInterviewProgress.objects.filter(
        company_id=company_id,
        round_id=round_id,
        student_id__in=passed_students
     )

        
class UpdateStudentInterviewProgressView(UpdateAPIView):
    queryset = StudentInterviewProgress.objects.all()
    serializer_class = StudentProgressSerializer

    def put(self, request, *args, **kwargs):
        instance = self.get_object()
        is_present = request.data.get("is_present", instance.is_present)
        is_passed = request.data.get("is_passed", instance.is_passed)

        instance.is_present = is_present
        instance.is_passed = is_passed
        instance.save()

        return Response({"message": "Attendance and pass status updated successfully."}, status=status.HTTP_200_OK)


# class ApplyForCompanyView(APIView):
#     def post(self, request):
#         serializer = ApplyForCompanySerializer(data=request.data)

#         if serializer.is_valid():
#             # Extract validated data
#             student = serializer.validated_data['student']
#             company = serializer.validated_data['company']

#             # Create the application
#             application = CompanyApplications.objects.create(
#                 student=student,
#                 company=company,
#                 student_unique_id=student.id_no,  # Save the student's unique ID
#                 company_name=company.company_name,  # Save the company's name
#                 first_name=student.first_name,
#                 last_name=student.last_name
#             )

#             # Return success response with additional details
#             return Response({
#                 "message": "Application successful!",
#                 "student_id": application.student_id,
#                 "company_name": application.company_name
#             }, status=status.HTTP_201_CREATED)
        
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
