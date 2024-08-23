from rest_framework import serializers
from .models import Student,Faculty
from django.contrib.auth.hashers import make_password
from rest_framework.exceptions import ValidationError


# # class StudentSerializer(serializers.ModelSerializer):
#     confirm_password = serializers.CharField(write_only=True)

#     class Meta:
#         model = Student
#         fields = ['name', 'email', 'password','confirm_password']
#         extra_kwargs = {'password': {'write_only': True}}
        
class StudentSerializer(serializers.ModelSerializer):
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = Student
        fields = ['name','email', 'password', 'confirm_password']

    def validate(self, data):
        if data['password'] != data['confirm_password']:
            raise serializers.ValidationError("Passwords do not match.")
        return data
    
    def create(self, validated_data):
        # Remove confirm_password before creating user
        validated_data['password'] = make_password(validated_data['password'])
        validated_data.pop('confirm_password')
        student = Student.objects.create_user(
            name=validated_data['name'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        return student
    
    

class FacultySerializer(serializers.ModelSerializer):
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = Faculty
        fields = ['name','email', 'password', 'confirm_password']

    def validate(self, data):
        if data['password'] != data['confirm_password']:
            raise serializers.ValidationError("Passwords do not match.")
        return data
    
    def create(self, validated_data):
        # Remove confirm_password before creating user
        validated_data['password'] = make_password(validated_data['password'])
        validated_data.pop('confirm_password')
        faculty = Faculty.objects.create_user(
            name=validated_data['name'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        return faculty


    # def create(self, validated_data):
    #     validated_data['password'] = make_password(validated_data['password'])  # Hash the password
    #     # validated_data.pop('confirm_password')
    #     return super().create(validated_data)
    
    # def create(self, validated_data):
    #     # Remove confirm_password before creating user
    #     validated_data['password'] = make_password(validated_data['password'])
    #     validated_data.pop('confirm_password')
    #     user = Student.objects.create_user(
    #         name=validated_data['name'],
    #         email=validated_data['email'],
    #         password=validated_data['password']
    #     )
    #     return user