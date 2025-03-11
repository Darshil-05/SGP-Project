# Create your views here.
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
import logging

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



# class RetrieveEligibleStudentsView(ListAPIView):
#     serializer_class = StudentProgressSerializer

#     def get_queryset(self):
#         company_id = self.kwargs.get('company_id')
#         round_id = self.kwargs.get('round_id')

#         if not company_id or not round_id:
#             return StudentInterviewProgress.objects.none()  # Return empty if params are missing

#         if round_id == 1:
#             # Get students from CompanyRegistration for the first round
#             registered_students = CompanyRegistration.objects.filter(company_id=company_id).values_list('student_id', flat=True)

#             return StudentInterviewProgress.objects.filter(
#                 company_id=company_id,
#                 student_id__in=registered_students
#             )

#         # Other Rounds: Only students who passed the previous round
#         previous_round_id = round_id - 1
#         passed_students = StudentInterviewProgress.objects.filter(
#             company_id=company_id,
#             round_id=previous_round_id,
#             is_passed=True
#         ).values_list('student_id', flat=True)

#         return StudentInterviewProgress.objects.filter(
#             company_id=company_id,
#             round_id=round_id,
#             student_id__in=passed_students
#         )

# class UpdateStudentInterviewProgressView(APIView):
#     def put(self, request, company_id, round_index):
#         print(f"Request Data: {request.data}")  # Debugging

#         student_id_no = request.data.get("student_id_no") or request.data.get("student_id")
#         if not student_id_no:
#             return Response({"error": "Student ID is missing in the request."}, status=status.HTTP_400_BAD_REQUEST)

#         student_id_no = student_id_no.strip()
#         is_present = request.data.get("is_present", False)
#         is_passed = request.data.get("is_passed", False)

#         print(f"Received student_id_no: {student_id_no}, company_id: {company_id}")

#         # 🔹 Check if student is in "sortlisted" table
#         sortlisted_entry = sortlisted.objects.filter(student_id_no__iexact=student_id_no, company_id=company_id).first()
#         print(f"Sortlisted entry found: {sortlisted_entry}")

#         if not sortlisted_entry:
#             return Response({"error": "Student is not registered for this company."}, status=status.HTTP_404_NOT_FOUND)

#         student = sortlisted_entry.student  # Get student object

#         # 🔹 Check if round_index is valid
#         rounds = InterviewRound.objects.filter(company_id=company_id).order_by('index')
#         if round_index < 0 or round_index >= len(rounds):
#             return Response({"error": "Invalid round index."}, status=status.HTTP_400_BAD_REQUEST)

#         # 🔹 Update or create student's interview progress
#         progress, created = StudentInterviewProgress.objects.update_or_create(
#             student=student,
#             company_id=company_id,
#             round_index=round_index,  # Store round index instead of round ForeignKey
#             defaults={"is_present": is_present, "is_passed": is_passed}
#         )

#         # 🔹 If student failed the round (is_passed=False), remove them from sortlisted
#         if not is_passed:
#             sortlisted_entry.delete()
#             return Response({
#                 "message": "Student failed the round and has been removed from sortlisted students.",
#                 "student_id": student_id_no,
#                 "company_id": company_id,
#                 "round_index": round_index,
#                 "is_present": progress.is_present,
#                 "is_passed": progress.is_passed
#             }, status=status.HTTP_200_OK)

#         return Response({
#             "student_id": student_id_no,
#             "company_id": company_id,
#             "round_index": round_index,
#             "is_present": progress.is_present,
#             "is_passed": progress.is_passed
#         }, status=status.HTTP_200_OK)





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
