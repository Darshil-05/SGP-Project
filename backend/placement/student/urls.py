from django.urls import path
from .views import *

urlpatterns = [
    path('studentinfo/',StudentDetailsPost.as_view(), name='student-detials'),
  

]