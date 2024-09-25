
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializers import StudentInfoSerializer
from .models import Student_details


# Create your views here.
class StudentDetailsview(APIView):
      def get(self, request):
           Studentdetails= Student_details.objects.all()
           serializer = StudentInfoSerializer(Studentdetails, many=True, context={'request': request})
           return Response(serializer.data)

class StudentDetailsPost(APIView):   
      def post(self, request):
        serializer = StudentInfoSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)