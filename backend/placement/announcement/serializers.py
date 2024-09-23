
# serializers.py
from rest_framework import serializers
from .models import public_announcement


class AnnouncementSerializer(serializers.ModelSerializer):
    class Meta:
        model = public_announcement
        fields = '__all__'