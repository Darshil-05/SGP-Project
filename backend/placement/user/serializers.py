# from rest_framework import serializers
# from faculty.models import Faculty_details
# from student.models import Student_details
# from django.contrib.auth.hashers import make_password
# from rest_framework.exceptions import ValidationError
# from rest_framework.authtoken.models import Token
# from django.contrib.auth import authenticate, login as auth_login
# from rest_framework import status
# from rest_framework.response import Response





# # class UserSignupSerializer(serializers.Serializer):
# #     email = serializers.EmailField()
# #     password = serializers.CharField(write_only=True)
    

# #     def validate(self, data):
# #         is_faculty = serializers.BooleanField()
# #         if data['is_faculty']:
# #             if Faculty_details.objects.filter(email=data['email']).exists():
# #                 raise serializers.ValidationError('Faculty with this email already exists.')
# #         else:
# #             if Student_details.objects.filter(email=data['email']).exists():
# #                 raise serializers.ValidationError('Student with this email already exists.')
# #         return data

# #     def create(self, validated_data):
# #         email = validated_data['email']
# #         password = validated_data['password']
# #         is_faculty = validated_data['is_faculty']

# #         # Create the user
# #         user = User.objects.create_user(email=email, password=password)
        
# #         # Create related model instance
# #         if is_faculty:
# #             Faculty_details.objects.create(email=email, user=user)
# #         else:
# #             Student_details.objects.create(email=email, user=user)
        
# #         return user

# class UserSignupSerializer(serializers.ModelSerializer):
#     confirm_password = serializers.CharField(write_only=True)

#     class Meta:
#         model = Faculty_details
#         fields = ['name','email', 'password', 'confirm_password']

#     class Meta:
#         model = Student_details
#         fields = ['name','email', 'password', 'confirm_password']
 
#     # Add other fields as needed

#     def validate(self, data):
#         email = data.get('email')
        
#         if not email.endswith('@charusat.edu.in') and not email.endswith('@charusat.ac.in'):
#             raise serializers.ValidationError("Email must end with @charusat.edu.in or @charusat.ac.in")
#         return data

#     def create(self, validated_data):
        
#         email= validated_data.get('email')
#         password =validated_data.get('password')
#         if validated_data.get('password')==validated_data.get('confirm_password'):
#         #  user = User.objects.create_user(email=email, password=password,username=name)
#         #  if email.endswith('@charusat.ac.in'):
            
#         #     validated_data['password'] = make_password(validated_data['password'])
#         #     validated_data.pop('confirm_password')
#         #     user = Faculty_details.objects.create_user(
#         #     name=validated_data['name'],
#         #     email=validated_data['email'],
#         #     password=validated_data['password'],
#         #     )
#         #     return user
#         #  el
#          if email.endswith('@charusat.edu.in'):
#             validated_data['password'] = make_password(validated_data['password'])
#             validated_data.pop('confirm_password')
          
#             user = Student_details.objects.create_user(
#             name=validated_data['name'],
#             email=validated_data['email'],
#             password=validated_data['password'],
#             )
#             return user
#         raise serializers.ValidationError("Both password must be same")
        


# class SignInSerializer(serializers.Serializer):
#      email = serializers.EmailField()
#      password = serializers.CharField(write_only=True)

#     #  def validate(self, data):
#     #     email = data.get('email')
#     #     password = data.get('password')
        
#     #     # Check if email is registered as a faculty or student
#     #     if email and password:
#     #         user_exists = Student_details.objects.filter(email=email, password=password).exists()
            
#     #         if user_exists:
#     #             return Response({'status': 'success', 'message': 'User exists'}, status=status.HTTP_200_OK)
#     #         else:
#     #             return Response({'status': 'failure', 'message': 'User does not exist'}, status=status.HTTP_404_NOT_FOUND)
#     #     return Response({'status': 'error', 'message': 'Email and password required'}, status=status.HTTP_400_BAD_REQUEST)

from rest_framework import serializers
from .models import *

class OTPSerializer(serializers.ModelSerializer):
    class Meta:
        model = OTP
        fields = ['email', 'otp_code']
