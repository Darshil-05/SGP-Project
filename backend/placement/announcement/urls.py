from django.urls import path
from .views import AnnouncementList, AnnouncementEdit

urlpatterns = [
    path('announcements/', AnnouncementList.as_view(), name='announcement-list'),
    path('announcements/<int:pk>/', AnnouncementEdit.as_view(), name='announcement-edit'),
]
