from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager,PermissionsMixin
from django.utils import timezone

from django.conf import settings


   
class Faculty_details(models.Model):
    faculty_id = models.CharField(max_length=15, primary_key=True)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    institute = models.CharField(max_length=255)
    department = models.CharField(max_length=100)
    faculty_email_id = models.EmailField(unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    

    def __str__(self):
        return f"{self.first_name} {self.last_name} ({self.faculty_id})"
    
    