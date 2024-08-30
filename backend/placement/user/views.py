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
import random
from django.core.mail import send_mail
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import OTP
from .serializers import OTPSerializer
from django.conf import settings
import string

def generate_otp():
    return ''.join(random.choices(string.digits, k=6))

class SignupView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        name = request.data.get('name')
        confirm_password= request.data.get('confirm_password')
        if password != confirm_password:
         return Response({'status': 'failure', 'message': 'Password do not match'}, status=status.HTTP_400_BAD_REQUEST)

        if email.endswith('@charusat.ac.in'):
            serializer = FacultyDetailsSerializer(data={
                'email': email,
                'password': password,
                'name': name
            })
            if serializer.is_valid():
                serializer.save()
                otp_code = generate_otp()
                # otp_store[email] = otp  # Store OTP
                otp = OTP.objects.create(email=email, otp_code=otp_code)
                send_mail(
                        'Your OTP Code',
                        f'Your OTP code is {otp_code}',
                        'Sgp01911@gmail.com',  
                        [email],
                        fail_silently=False,
                )
                return Response({'status': 'success', 'message': 'otp sent successfully'}, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        elif email.endswith('@charusat.edu.in'):
            serializer = StudentDetailsSerializer(data={
                'email': email,
                'password': password,
                'name': name
            })
            if serializer.is_valid():
                serializer.save()
                otp_code = generate_otp()
                # otp_store[email] = otp  # Store OTP
                otp = OTP.objects.create(email=email, otp_code=otp_code)
                send_mail(
                        'Your OTP Code',
                        f'Your OTP code is {otp_code}',
                        'Sgp01911@gmail.com',  
                        [email],
                        fail_silently=False,
                )
                return Response({'status': 'success', 'message': 'otp sent successfully'}, status=status.HTTP_201_CREATED)
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
         


# class GenerateOTPView(APIView):
#     def post(self, request):
#         email = request.data.get('email')
#         if not email:
#             return Response({'error': 'Email is required'}, status=status.HTTP_400_BAD_REQUEST)

#         # Generate a random 6-digit OTP
#         otp_code = str(random.randint(100000, 999999))

#         # Save the OTP to the database
#         otp = OTP.objects.create(email=email, otp_code=otp_code)

#         # Send the OTP via email
#         send_mail(
#             'Your OTP Code',
#             f'Your OTP code is {otp_code}',
#             'Sgp01911@gmail.com',  
#             [email],
#             fail_silently=False,
#         )

#         return Response({'message': 'OTP sent to email'}, status=status.HTTP_200_OK)

class VerifyOTPView(APIView):
    def post(self, request):
        serializer = OTPSerializer(data=request.data)
        if serializer.is_valid():
            try:
                otp_instance = OTP.objects.get(email=serializer.validated_data['email'], otp_code=serializer.validated_data['otp_code'])
                if otp_instance.is_valid():
                    return Response({'message': 'OTP verified successfully'}, status=status.HTTP_200_OK)
                else:
                    return Response({'error': 'OTP has expired'}, status=status.HTTP_400_BAD_REQUEST)
            except OTP.DoesNotExist:
                return Response({'error': 'Invalid OTP or email'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
