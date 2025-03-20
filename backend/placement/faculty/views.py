
# Create your views here.
# Create your views here.
from rest_framework import viewsets
from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import Faculty_details
from .serializers import FacultyDetailsSerializer

class FacultyDetailsListCreateView(generics.ListCreateAPIView):
    queryset = Faculty_details.objects.all()
    serializer_class = FacultyDetailsSerializer
    permission_classes = [IsAuthenticated]

    
class FacultyDetailsRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Faculty_details.objects.all()
    serializer_class = FacultyDetailsSerializer
    permission_classes = [IsAuthenticated]
    lookup_field = 'faculty_id'





