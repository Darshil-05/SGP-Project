from .views import *
from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    path('signup/', SignupView.as_view(), name='user-signup'),
    path('signin/',SigninView.as_view(), name='user-Login'),
    # path('generate-otp/', GenerateOTPView.as_view(), name='generate-otp'),
    path('verify-otp/', VerifyOTPView.as_view(), name='verify-otp'),
]
