from django.urls import path, include

from .views import *


urlpatterns = [
    path('announcement/', AnnouncementView.as_view(), name='company-detials'),
    path('announcement-crud/<int:pk>/',Announcementedit.as_view(),name='company-crud'),
    path('announcement-post/',AnnouncementPost.as_view(),name='company-post'),
]
