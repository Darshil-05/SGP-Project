# your_app_name/serializers.py

from rest_framework import serializers
from .models import JobDomain

class DataEntrySerializer(serializers.ModelSerializer):
    class Meta:
        model = JobDomain
        fields = '__all__'
