from rest_framework import serializers
from .models import Student_details

class StudentDetailsSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = Student_details
        fields = ['email', 'name', 'password']

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        user = Student_details.objects.create_user(**validated_data, password=password)
        return user
