from .views import *
from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('signup/', SignupView.as_view(), name='user-signup'),
    path('signin/',SigninView.as_view(), name='user-Login'),
    path('signout/',SignoutView.as_view(), name='user-Logout'),
    # path('generate-otp/', GenerateOTPView.as_view(), name='generate-otp'),
    path('verify-otp/', VerifyOTPView.as_view(), name='verify-otp'),
    path('resend-otp/', ResendOTPView.as_view(), name='Resend-otp'),
    # path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]
