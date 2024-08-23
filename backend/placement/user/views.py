from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializers import StudentSerializer,FacultySerializer
from rest_framework.authtoken.models import Token

class StudentSignupView(APIView):
    
    def post(self, request):
        email = request.data.get('email', '').lower()

        if email.endswith('@charusat.ac.in'):
            serializer = FacultySerializer(data=request.data)
        elif email.endswith('@charusat.edu.in'):
            serializer = StudentSerializer(data=request.data)
        else:
            return Response({'error': 'Invalid email domain'}, status=status.HTTP_400_BAD_REQUEST)
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)









    # def post(self, request, *args, **kwargs):
    #     serializer = UserRegistrationSerializer(data=request.data)
    #     if serializer.is_valid():
    #         user = serializer.save()
    #         return Response({'message': 'User registered successfully.'}, status=status.HTTP_201_CREATED)
            
    #     print(serializer.error_messages)
    #     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
   