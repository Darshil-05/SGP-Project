from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializers import UserSignupSerializer
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate, login as auth_login



class SignupView(APIView):
    
    def post(self, request, *args, **kwargs):
        serializer = UserSignupSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response({'detail': 'User registered successfully'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


