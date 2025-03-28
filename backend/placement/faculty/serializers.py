# from rest_framework import serializers
# from .models import Faculty_auth


# class FacultyAuthSerializer(serializers.ModelSerializer):
#     password = serializers.CharField(write_only=True)

#     class Meta:
#         model = Faculty_auth
#         fields = ['email', 'name', 'password']

#     def create(self, validated_data):
#         password = validated_data.pop('password', None)
#         user = Faculty_auth.objects.create_user(**validated_data, password=password)
#         return user
    
   

# from rest_framework import serializers
# from .models import Faculty_auth, Faculty_details


# class FacultyAuthSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Faculty_auth
#         fields = ('id', 'email', 'name', 'password')
#         extra_kwargs = {'password': {'write_only': True}}

#     def create(self, validated_data):
#         user = Faculty_auth.objects.create_user(
#             email=validated_data['email'],
#             name=validated_data['name'],
#             password=validated_data['password']
#         )
#         return user

# class FacultyDetailsSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Faculty_details
#         fields = '__all__'
#         read_only_fields = ('created_at')
    
   

from rest_framework import serializers
from .models import  Faculty_details


# class FacultyAuthSerializer(serializers.ModelSerializer):
#     password = serializers.CharField(write_only=True)

#     class Meta:
#         model = Faculty_auth
#         fields = ('id', 'email', 'name', 'password')

#     def create(self, validated_data):
#         password = validated_data.pop('password', None)
#         user = Faculty_auth.objects.create_user(
#             email=validated_data['email'],
#             name=validated_data['name'],
#             password=password
#         )
#         return user

class FacultyDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Faculty_details
        fields = '__all__'
        read_only_fields = ('created_at',)
    