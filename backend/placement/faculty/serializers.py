from rest_framework import serializers
from .models import Faculty_details


class FacultyAuthSerializer(serializers.ModelSerializer):
    class Meta:
        model = Faculty_details
        fields = '__all__'