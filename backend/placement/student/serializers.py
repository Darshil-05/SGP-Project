from rest_framework import serializers
from .models import *
from rest_framework.response import Response

class StudentAuthSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = Student_auth
        fields = ['id','email', 'name', 'password']

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        user = Student_auth.objects.create_user(**validated_data, password=password)
        return user

    
# class StudentInfoSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Student_details
#         fields = '__all__'

class CertificateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Certificate
        fields = '__all__'

class ExperienceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Experience
        fields = '__all__'

class StudentDetailsSerializer(serializers.ModelSerializer):
    certificates = CertificateSerializer(many=True, read_only=True)
    experience = ExperienceSerializer(many=True,read_only=True)

    class Meta:
        model = Student_details
        fields = '__all__'