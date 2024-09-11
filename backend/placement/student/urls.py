from django.urls import path
from .views import *

urlpatterns = [
    path('studentinfo/',StudentDetailsPost.as_view(), name='student-detials'),
    path('studentinfoget/',StudentDetailsview.as_view(), name='student-detials-get'),

]