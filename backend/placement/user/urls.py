from .views import StudentSignupView
from django.urls import path

urlpatterns = [
    path('signup/', StudentSignupView.as_view(), name='user-signup'),
]
