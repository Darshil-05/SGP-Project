
# Create your views here.
from rest_framework import viewsets
from rest_framework.exceptions import NotFound
from rest_framework import generics
from .models import CompanyDetails,InterviewRound,CompanyRegistration
from .serializers import CompanyDetailsSerializer,InterviewRoundSerializer,CompanyRegistrationSerializer
from rest_framework.response import Response
from rest_framework import status
from rest_framework import serializers


class CompanyDetailsList(generics.ListCreateAPIView):
    queryset = CompanyDetails.objects.all()
    serializer_class = CompanyDetailsSerializer

class CompanyDetailsDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = CompanyDetails.objects.all()
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
    

class RegisteredStudentsByCompanyList(generics.ListAPIView):
    serializer_class = CompanyRegistrationSerializer
    def get_queryset(self):
        company_name = self.kwargs['company_name']
        # Filter registrations by the company name
        company = CompanyDetails.objects.filter(company_name=company_name).first()
        
        if not company:
            raise serializers.ValidationError({"company_name": "Company does not exist."})

        return CompanyRegistration.objects.filter(company=company)

# class CompanyPlacementDriveViewSet(viewsets.ModelViewSet):
#     queryset = CompanyPlacementDrive.objects.all()
#     serializer_class = CompanyPlacementDriveSerializer

