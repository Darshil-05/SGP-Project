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
import re
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.tokens import BlacklistMixin


from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import AllowAny



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

        if email.endswith('@charusat.ac.in'):
            user_type = 'faculty'
            serializer = FacultyAuthSerializer(data={'email': email, 'password': password, 'name': name})
        elif email.endswith('@charusat.edu.in'):
            user_type = 'student'
            serializer = StudentAuthSerializer(data={'email': email, 'password': password, 'name': name})
        else:
            return Response({'status': 'failure', 'message': 'Invalid email domain'}, status=status.HTTP_400_BAD_REQUEST)
        

        if not self.is_password_valid(password):
            return Response({'status': 'failure', 'message': 'Password must be strong.'}, status=status.HTTP_400_BAD_REQUEST)

        # Check serializer validity
        if serializer.is_valid():
            # Generate OTP
            otp_code = generate_otp()
            

            # Save OTP with user_type, name, and password in the OTP model
            OTP.objects.update_or_create(
                email=email,
                defaults={
                    'otp_code': otp_code,
                    'user_type': user_type,
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

         



class SigninView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')

        if not email or not password:
            return Response({'error': 'Email and password are required'}, status=status.HTTP_400_BAD_REQUEST)

        user = None
        user_type = None

        # Check if user is Student
        if Student_auth.objects.filter(email=email).exists():
            user = Student_auth.objects.get(email=email)
            user_type = 'student'

        # Check if user is Faculty
        elif Faculty_auth.objects.filter(email=email).exists():
            user = Faculty_auth.objects.get(email=email)
            user_type = 'faculty'

        # Check if password is correct
        if user and user.check_password(password):
            # 🔹 Manually generate JWT tokens without `for_user(user)`
            refresh = RefreshToken()
            refresh.payload["user_id"] = str(user.id)  # Store user ID in token
            refresh.payload["email"] = user.email
            refresh.payload["user_type"] = user_type  # Add user type for distinction

            return Response({
                'status': 'success',
                'message': 'Login successful',
                'user_id': user.id,
                'access': str(refresh.access_token),  # ✅ Custom JWT token
                'refresh': str(refresh)
            }, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Invalid email or password'}, status=status.HTTP_400_BAD_REQUEST)


# from rest_framework_simplejwt.tokens import RefreshToken
# from rest_framework.permissions import IsAuthenticated

# class SignoutView(APIView):
#     permission_classes = [AllowAny]

#     def post(self, request):
#         try:
#             refresh_token = request.data.get('refresh_token')
#             if not refresh_token:
#                 return Response({'status': 'failure', 'message': 'Refresh token is required'}, status=status.HTTP_400_BAD_REQUEST)

#             token = RefreshToken(refresh_token)
#             token.blacklist()  # Blacklist the refresh token

#             return Response({'status': 'success', 'message': 'User signed out successfully'}, status=status.HTTP_200_OK)

#         except Exception as e:
#             return Response({'status': 'failure', 'message': 'Failed to sign out', 'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)





from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated
from announcement.models import StudentFCMToken, FacultyFCMToken

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

            # If FCM token is provided, try to delete it from both tables
            if fcm_token:
                try:
                    # Try to delete from StudentFCMToken
                    StudentFCMToken.objects.filter(token=fcm_token).delete()
                except Exception as e:
                    pass  # Ignore if not found in student tokens

                try:
                    # Try to delete from FacultyFCMToken
                    FacultyFCMToken.objects.filter(token=fcm_token).delete()
                except Exception as e:
                    pass  # Ignore if not found in faculty tokens

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

        if not otp_code or not email or not name or not password:
            return Response({'error': 'Please Enter OTP'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            otp_instance = OTP.objects.filter(email=email, otp_code=otp_code).first()
            if otp_instance is None:
                return Response({'error': 'Invalid OTP'}, status=status.HTTP_400_BAD_REQUEST)

            if otp_instance.is_valid():
                user_type = otp_instance.user_type

                if user_type == 'faculty':
                    user = Faculty_auth.objects.create(
                        email=email,
                        password=make_password(password),
                        name=name
                    )
                elif user_type == 'student':
                    user = Student_auth.objects.create(
                        email=email,
                        password=make_password(password),
                        name=name
                    )

                otp_instance.delete()

                # 🔹 Manually create the JWT token (without using `for_user`)
                refresh = RefreshToken()
                refresh.payload["user_id"] = str(user.id)  # Store user ID in token
                refresh.payload["email"] = user.email
                refresh.payload["user_type"] = user_type  # Add user type for distinction

                return Response({
                    'status': 'success',
                    'message': 'OTP verified successfully, and user created',
                    'user_id': user.id,
                    'access': str(refresh.access_token),  # ✅ Custom JWT token
                    'refresh': str(refresh)
                }, status=status.HTTP_201_CREATED)

            else:
                return Response({'error': 'OTP has expired'}, status=status.HTTP_400_BAD_REQUEST)

        except OTP.DoesNotExist:
            return Response({'error': 'Invalid OTP or email'}, status=status.HTTP_400_BAD_REQUEST)



class ResendOTPView(APIView):
    permission_classes = [AllowAny]
    def post(self, request):
        email = request.data.get('email')  # Get the email from the request
           # Get the name from the request
        password = request.data.get('password')  # Get the password from the request

        if not email  or not password:
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
                    'created_at': timezone.now()  # Update the created_at field to the current time
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
