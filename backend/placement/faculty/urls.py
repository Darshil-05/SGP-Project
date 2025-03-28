from django.urls import path
from .views import *


urlpatterns = [
    path('faculty-details/', FacultyDetailsListCreateView.as_view(), name='faculty-details-list-create'),
    path('faculty-details/<str:faculty_email_id>/', FacultyDetailsRetrieveUpdateDestroyView.as_view(), name='faculty-details-detail'),
]
