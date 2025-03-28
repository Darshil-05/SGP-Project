from django.urls import path
from .views import (
    SignupView, 
    SigninView, 
    SignoutView, 
    VerifyOTPView, 
    ResendOTPView
)
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('signup/', SignupView.as_view(), name='user-signup'),
    path('signin/', SigninView.as_view(), name='user-login'),
    path('signout/', SignoutView.as_view(), name='user-logout'),
    path('verify-otp/', VerifyOTPView.as_view(), name='verify-otp'),
    path('resend-otp/', ResendOTPView.as_view(), name='resend-otp'),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]