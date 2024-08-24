from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
from .models import Faculty_details
from .serializers import FacultyAuthSerializer

class FacultyAuthViewSet(viewsets.ModelViewSet):
    queryset = Faculty_details.objects.all()
    serializer_class = FacultyAuthSerializer