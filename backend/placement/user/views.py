from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
# from .serializers import UserSignupSerializer,SignInSerializer
from student .models import Student_auth
from faculty .models import Faculty_auth
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate, login as auth_login
from student .serializers import StudentAuthSerializer
from faculty .serializers import FacultyAuthSerializer
import random
from django.core.mail import send_mail
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import OTP
from .serializers import *
from django.contrib.auth.hashers import make_password
from django.conf import settings
import string

def generate_otp():
    return ''.join(random.choices(string.digits, k=6))


class SignupView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        name = request.data.get('name')
        confirm_password = request.data.get('confirm_password')

        if not all([email, password, name, confirm_password]):
            return Response({'status': 'failure', 'message': 'All Fields are Required'}, status=status.HTTP_400_BAD_REQUEST)

        if password != confirm_password:
            return Response({'status': 'failure', 'message': 'Passwords do not match'}, status=status.HTTP_400_BAD_REQUEST)

        if email.endswith('@charusat.ac.in'):
            user_type = 'faculty'
            serializer = FacultyAuthSerializer(data={'email': email, 'password': password, 'name': name})
        elif email.endswith('@charusat.edu.in'):
            user_type = 'student'
            serializer = StudentAuthSerializer(data={'email': email, 'password': password, 'name': name})
        else:
            return Response({'status': 'failure', 'message': 'Invalid email domain'}, status=status.HTTP_400_BAD_REQUEST)

        # Check serializer validity and log errors
        if serializer.is_valid():
            # Store user data in session
            request.session['user_data'] = {
                'email': email,
                'password': password,
                'name': name,
                'user_type': user_type
            }

            # Generate and send OTP
            otp_code = generate_otp()
            OTP.objects.create(email=email, otp_code=otp_code)
            send_mail(
                'Your OTP Code',
                f'Your OTP code is {otp_code}',
                settings.DEFAULT_FROM_EMAIL,
                [email],
                fail_silently=False,
            )

            return Response({
                'status': 'success',
                'message': 'OTP sent successfully. Please verify your OTP to complete registration.'
            }, status=status.HTTP_201_CREATED)
        else:
            # Log serializer errors for debugging
            return Response({'status': 'failure', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

         

class SigninView(APIView):
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')

        if email is None or password is None:
            return Response({'status': 'failure', 'message': 'Email and password are required'}, status=status.HTTP_400_BAD_REQUEST)

        if email.endswith('@charusat.edu.in'):
            try:
                user = Student_auth.objects.get(email=email)
                if user.check_password(password):  # Use the method to verify hashed passwords
                    refresh = RefreshToken.for_user(user)  # Generate JWT tokens
                    return Response({
                        'status': 'success',
                        'message': 'User authenticated',
                        'access': str(refresh.access_token),  # Access token
                        'refresh': str(refresh),               # Refresh token
                    }, status=status.HTTP_200_OK)
                else:
                    return Response({'status': 'failure', 'message': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
            except Student_auth.DoesNotExist:
                return Response({'status': 'failure', 'message': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

        elif email.endswith('@charusat.ac.in'):
            try:
                user = Faculty_auth.objects.get(email=email)
                if user.check_password(password):  # Use the method to verify hashed passwords
                    refresh = RefreshToken.for_user(user)  # Generate JWT tokens
                    return Response({
                        'status': 'success',
                        'message': 'User authenticated',
                        'access': str(refresh.access_token),  # Access token
                        'refresh': str(refresh),               # Refresh token
                    }, status=status.HTTP_200_OK)
                else:
                    return Response({'status': 'failure', 'message': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
            except Faculty_auth.DoesNotExist:
                return Response({'status': 'failure', 'message': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

        return Response({'status': 'failure', 'message': 'Invalid email domain'}, status=status.HTTP_400_BAD_REQUEST)




class VerifyOTPView(APIView):
    def post(self, request):
        otp_code = request.data.get('otp_code')
        user_data = request.session.get('user_data')

        if not user_data:
            return Response({'error': 'No user data found in session. Please sign up again.'}, status=status.HTTP_400_BAD_REQUEST)

        email = user_data['email']
        password = user_data['password']
        name = user_data['name']
        user_type = user_data['user_type']

        try:
            otp_instance = OTP.objects.get(email=email, otp_code=otp_code)
            if otp_instance.is_valid():
                # OTP verified, now create the user
                if user_type == 'faculty':
                    user = Faculty_auth.objects.create(
                        email=email,
                        password=make_password(password),  # Save the password (hashed)
                        name=name
                    )
                elif user_type == 'student':
                    user = Student_auth.objects.create(
                        email=email,
                        password=make_password(password),  # Save the password (hashed)
                        name=name
                    )
                
                # Generate JWT tokens after the user is created
                refresh = RefreshToken.for_user(user)
                access_token = str(refresh.access_token)

                return Response({
                    'status': 'success',
                    'message': 'OTP verified successfully and user created',
                    'access_token': access_token,
                    'refresh_token': str(refresh)
                }, status=status.HTTP_200_OK)
            else:
                return Response({'error': 'OTP has expired'}, status=status.HTTP_400_BAD_REQUEST)
        except OTP.DoesNotExist:
            return Response({'error': 'Invalid OTP or email'}, status=status.HTTP_400_BAD_REQUEST)
