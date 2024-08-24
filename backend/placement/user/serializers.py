from rest_framework import serializers
from faculty.models import Faculty_details
from student.models import Student_details
from django.contrib.auth.hashers import make_password
from rest_framework.exceptions import ValidationError
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate, login as auth_login
   

class UserSignupSerializer(serializers.ModelSerializer):
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = Faculty_details
        fields = ['name','email', 'password', 'confirm_password']

    class Meta:
        model = Student_details
        fields = ['name','email', 'password', 'confirm_password']
 
    # Add other fields as needed

    def validate(self, data):
        email = data.get('email')
        if not email.endswith('@charusat.edu.in') and not email.endswith('@charusat.ac.in'):
            raise serializers.ValidationError("Email must end with @charusat.edu.in or @charusat.ac.in")
        return data

    def create(self, validated_data):
        email= validated_data.get('email')
        if email.endswith('@charusat.ac.in'):
            
            validated_data['password'] = make_password(validated_data['password'])
            validated_data.pop('confirm_password')
            faculty = Faculty_details.objects.create_user(
            name=validated_data['name'],
            email=validated_data['email'],
            password=validated_data['password']
            )
            return faculty
        elif email.endswith('@charusat.edu.in'):
            validated_data['password'] = make_password(validated_data['password'])
            validated_data.pop('confirm_password')
            student = Student_details.objects.create_user(
            name=validated_data['name'],
            email=validated_data['email'],
            password=validated_data['password']
            )
            return student
        
