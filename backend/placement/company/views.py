
# Create your views here.
from rest_framework import viewsets
from rest_framework import generics
from .models import CompanyDetails
from .serializers import CompanyDetailsSerializer

class CompanyDetailsList(generics.ListCreateAPIView):
    queryset = CompanyDetails.objects.all()
    serializer_class = CompanyDetailsSerializer

class CompanyDetailsDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = CompanyDetails.objects.all()
    serializer_class = CompanyDetailsSerializer

# class CompanyPlacementDriveViewSet(viewsets.ModelViewSet):
#     queryset = CompanyPlacementDrive.objects.all()
#     serializer_class = CompanyPlacementDriveSerializer

