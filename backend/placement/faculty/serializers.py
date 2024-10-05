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
    
   

