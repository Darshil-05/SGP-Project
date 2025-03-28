from rest_framework import serializers
from .models import UserAuth, OTP

class UserAuthSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = UserAuth
        fields = ['id', 'email', 'name', 'password', 'role']
        read_only_fields = ['role']

    def create(self, validated_data):
        # The create_user method in the model will handle role assignment
        user = UserAuth.objects.create_user(**validated_data)
        return user

class OTPSerializer(serializers.ModelSerializer):
    class Meta:
        model = OTP
        fields = ['email', 'otp_code']