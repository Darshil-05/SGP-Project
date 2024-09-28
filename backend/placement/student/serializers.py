from rest_framework import serializers
from .models import *

class StudentDetailsSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = Student_auth
        fields = ['id','email', 'name', 'password']

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        user = Student_auth.objects.create_user(**validated_data, password=password)
        return user

class StudentInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student_details
        fields = '__all__'

        