from rest_framework import serializers
from .models import Faculty_auth


class FacultyAuthSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = Faculty_auth
        fields = ['email', 'name', 'password']

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        user = Faculty_auth.objects.create_user(**validated_data, password=password)
        return user
    
    def validate_password(self, value):
        """Validate the password strength."""
        if len(value) < 8:
            re
        if not any(char.isdigit() for char in value):
            raise serializers.ValidationError("Password must contain at least one digit.")
        if not any(char.isalpha() for char in value):
            raise serializers.ValidationError("Password must contain at least one letter.")
        if not any(char in "!@#$%^&*()-_=+[]{}|;:,.<>?/" for char in value):
            raise serializers.ValidationError("Password must contain at least one special character.")
        return value

