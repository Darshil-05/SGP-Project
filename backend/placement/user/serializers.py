

from rest_framework import serializers
from .models import *

class OTPSerializer(serializers.ModelSerializer):
    class Meta:
        model = OTP
        fields = ['email', 'otp_code']
