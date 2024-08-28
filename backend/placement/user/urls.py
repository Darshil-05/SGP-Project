from .views import SignupView,SigninView
from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    path('signup/', SignupView.as_view(), name='user-signup'),
    path('signin/',SigninView.as_view(), name='user-Login'),
]
