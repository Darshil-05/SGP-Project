
# Create your views here.
from rest_framework import viewsets
from rest_framework import generics
from .models import CompanyDetails,InterviewRound
from .serializers import CompanyDetailsSerializer,InterviewRoundSerializer

class CompanyDetailsList(generics.ListCreateAPIView):
    queryset = CompanyDetails.objects.all()
    serializer_class = CompanyDetailsSerializer

class CompanyDetailsDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = CompanyDetails.objects.all()
    serializer_class = CompanyDetailsSerializer



class InterviewRoundList(generics.ListCreateAPIView):
    queryset = InterviewRound.objects.all()
    serializer_class = InterviewRoundSerializer

class InterviewRoundDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = InterviewRound.objects.all()
    serializer_class = InterviewRoundSerializer

# class CompanyPlacementDriveViewSet(viewsets.ModelViewSet):
#     queryset = CompanyPlacementDrive.objects.all()
#     serializer_class = CompanyPlacementDriveSerializer

