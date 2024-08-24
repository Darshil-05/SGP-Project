from .views import SignupView
from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    path('signup/', SignupView.as_view(), name='user-signup'),
    # path('login/',LoginView.as_view(), name='user-Login'),
]
