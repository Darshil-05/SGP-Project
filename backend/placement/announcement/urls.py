from django.urls import path, include

from .views import *


urlpatterns = [
    path('announcements/', AnnouncementList.as_view(), name='company-list'),
    path('announcements/<int:pk>/', AnnouncementEdit.as_view(), name='company-detail'),
    path('fcm/faculty/', FacultyFCMTokenView.as_view(), name='faculty-fcm-token'),
    path('fcm/student/', StudentFCMTokenView.as_view(), name='student-fcm-token'),
    
]
