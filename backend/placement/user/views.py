
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from django.core.mail import send_mail
from django.conf import settings
from django.contrib.auth.hashers import make_password
import random
import string
import re
from rest_framework.permissions import AllowAny
from .models import UserAuth, OTP,FCMToken
from .serializers import UserAuthSerializer
from django.utils import timezone

def generate_otp():
    return ''.join(random.choices(string.digits, k=6))

class SignupView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        name = request.data.get('name')
        confirm_password = request.data.get('confirm_password')

        if not all([email, password, name, confirm_password]):
            return Response({'status': 'failure', 'message': 'All fields are required'}, status=status.HTTP_400_BAD_REQUEST)

        if password != confirm_password:
            return Response({'status': 'failure', 'message': 'Passwords do not match'}, status=status.HTTP_400_BAD_REQUEST)

        # Validate email domain
        if not (email.endswith('@charusat.ac.in') or email.endswith('@charusat.edu.in')):
            return Response({'status': 'failure', 'message': 'Invalid email domain'}, status=status.HTTP_400_BAD_REQUEST)

        if not self.is_password_valid(password):
            return Response({'status': 'failure', 'message': 'Password must be strong.'}, status=status.HTTP_400_BAD_REQUEST)

        # Prepare user data
        user_data = {
            'email': email,
            'name': name,
            'password': password
        }

        serializer = UserAuthSerializer(data=user_data)
        
        if serializer.is_valid():
            # Generate OTP
            otp_code = generate_otp()
            
            # Save OTP 
            OTP.objects.update_or_create(
                email=email,
                defaults={
                    'otp_code': otp_code,
                    'created_at': timezone.now()
                }
            )

            # Send OTP to the user's email
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
            return Response({'status': 'failure', 'errors': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
    
    def is_password_valid(self, password):
        """Validate the password strength."""
        if len(password) < 8:
            return False
        if not re.search(r'\d', password):
            return False
        if not re.search(r'[A-Za-z]', password):
            return False
        if not re.search(r'[!@#$%^&*()_+=-]', password):
            return False
        return True
from .utils import store_or_update_fcm_token

class SigninView(APIView):
    permission_classes = [AllowAny]
    
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        fcm_token = request.data.get('fcm_token')  # Get FCM token from request

        if not email or not password:
            return Response({
                'status': 'error',
                'message': 'Email and password are required'
            }, status=status.HTTP_400_BAD_REQUEST)

        # Authenticate user
        user = authenticate(email=email, password=password)

        if user:
            # Generate JWT tokens
            refresh = RefreshToken.for_user(user)
            refresh.payload["user_id"] = str(user.id)
            refresh.payload["email"] = user.email
            refresh.payload["role"] = user.role

            # Handle FCM token if provided
            fcm_message = None
            if fcm_token:
                success, message = store_or_update_fcm_token(
                    email=email,
                    token=fcm_token,
                    user_type=user.role  # Using role from user model
                )
                if not success:
                    fcm_message = message

            response_data = {
                'status': 'success',
                'message': 'Login successful',
                'user_id': user.id,
                'role': user.role,
                'access': str(refresh.access_token),
                'refresh': str(refresh)
            }

            # Add FCM token status to response if there was an error
            if fcm_message:
                response_data['fcm_status'] = 'warning'
                response_data['fcm_message'] = fcm_message

            return Response(response_data, status=status.HTTP_200_OK)
        else:
            return Response({
                'status': 'error',
                'message': 'Invalid email or password'
            }, status=status.HTTP_400_BAD_REQUEST)



class SignoutView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        try:
            refresh_token = request.data.get('refresh_token')
            fcm_token = request.data.get('fcm_token')

            if not refresh_token:
                return Response({'status': 'failure', 'message': 'Refresh token is required'}, status=status.HTTP_400_BAD_REQUEST)

            # Blacklist the refresh token
            token = RefreshToken(refresh_token)
            token.blacklist()

            # If FCM token is provided, try to delete it
            if fcm_token:
                FCMToken.objects.filter(token=fcm_token).delete()

            return Response({
                'status': 'success', 
                'message': 'User signed out successfully'
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({
                'status': 'failure', 
                'message': 'Failed to sign out', 
                'error': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class VerifyOTPView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        otp_code = request.data.get('otp_code')
        email = request.data.get('email')
        name = request.data.get('name')
        password = request.data.get('password')

        if not all([otp_code, email, name, password]):
            return Response({'error': 'All fields are required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            otp_instance = OTP.objects.filter(email=email, otp_code=otp_code).first()
            if otp_instance is None:
                return Response({'error': 'Invalid OTP'}, status=status.HTTP_400_BAD_REQUEST)

            if otp_instance.is_valid():
                # Create user with auto-assigned role based on email domain
                user = UserAuth.objects.create_user(
                    email=email,
                    password=password,
                    name=name
                )

                otp_instance.delete()

                # Generate JWT token
                refresh = RefreshToken.for_user(user)
                refresh.payload["user_id"] = str(user.id)
                refresh.payload["email"] = user.email
                refresh.payload["role"] = user.role

                return Response({
                    'status': 'success',
                    'message': 'OTP verified successfully, and user created',
                    'user_id': user.id,
                    'role': user.role,
                    'access': str(refresh.access_token),
                    'refresh': str(refresh)
                }, status=status.HTTP_201_CREATED)

            else:
                return Response({'error': 'OTP has expired'}, status=status.HTTP_400_BAD_REQUEST)

        except OTP.DoesNotExist:
            return Response({'error': 'Invalid OTP or email'}, status=status.HTTP_400_BAD_REQUEST)

class ResendOTPView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')

        if not email or not password:
            return Response({
                'status': 'failure',
                'message': 'Email and password are required to resend OTP.'
            }, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Generate a new OTP
            new_otp_code = generate_otp()

            # Update the existing OTP if it exists, otherwise create a new one
            otp_instance, created = OTP.objects.update_or_create(
                email=email,
                defaults={
                    'otp_code': new_otp_code,
                    'created_at': timezone.now()
                }
            )

            # Send the new OTP via email
            send_mail(
                'Your New OTP Code',
                f'Your new OTP code is {new_otp_code}',
                settings.DEFAULT_FROM_EMAIL,
                [email],
                fail_silently=False,
            )

            return Response({
                'status': 'success',
                'message': 'A new OTP has been sent to your email.'
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({
                'status': 'failure',
                'message': 'Failed to resend OTP. Please try again later.',
                'error': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)