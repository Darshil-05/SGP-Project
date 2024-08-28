from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
# from .serializers import UserSignupSerializer,SignInSerializer
from student .models import Student_details
from faculty .models import Faculty_details
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate, login as auth_login
from student .serializers import StudentDetailsSerializer
from faculty .serializers import FacultyDetailsSerializer


class SignupView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        name = request.data.get('name')
        confirm_password= request.data.get('confirm_password')
        if password == confirm_password:
         if email.endswith('@charusat.ac.in'):
            serializer = FacultyDetailsSerializer(data={
                'email': email,
                'password': password,
                'name': name
            })
            if serializer.is_valid():
                serializer.save()
                return Response({'status': 'success', 'message': 'Faculty registered successfully'}, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        elif email.endswith('@charusat.edu.in'):
            serializer = StudentDetailsSerializer(data={
                'email': email,
                'password': password,
                'name': name
            })
            if serializer.is_valid():
                serializer.save()
                return Response({'status': 'success', 'message': 'Student registered successfully'}, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        return Response({'status': 'failure', 'message': 'Invalid email domain'}, status=status.HTTP_400_BAD_REQUEST)

class SigninView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')

        if email.endswith('@charusat.edu.in'):
         try:
            user = Student_details.objects.get(email=email)
            if user.check_password(password):  # Use the method to verify hashed passwords
                return Response({'status': 'success', 'message': 'User authenticated'}, status=status.HTTP_200_OK)
            else:
                return Response({'status': 'failure', 'message': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
         except Student_details.DoesNotExist:
            return Response({'status': 'failure', 'message': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
         
        elif email.endswith('@charusat.ac.in'):
         try:
            user = Faculty_details.objects.get(email=email)
            if user.check_password(password):  # Use the method to verify hashed passwords
                return Response({'status': 'success', 'message': 'User authenticated'}, status=status.HTTP_200_OK)
            else:
                return Response({'status': 'failure', 'message': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
         except Faculty_details.DoesNotExist:
            return Response({'status': 'failure', 'message': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)