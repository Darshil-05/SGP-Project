from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.utils import timezone

from django.conf import settings



# Create your models here.
class StudentManager(BaseUserManager):
    def create_user(self, email, password=None,**extra_fields):
        if not email:
            raise ValueError('Users must have an email address')
        user = self.model(email=self.normalize_email(email),**extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user



   # token = models.CharField(max_length=255)
    
    

class Student_auth(AbstractBaseUser):
    student_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)
    last_login = models.DateTimeField(null=True, blank=True, default=timezone.now)

    objects = StudentManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']

    def __str__(self):
        return self.email
    

    
class Student_details(AbstractBaseUser):
    
    student_auth = models.OneToOneField(Student_auth, on_delete=models.CASCADE)    
    id_no = models.CharField(max_length=15)
    last_name = models.CharField(max_length=255)
    first_name = models.CharField(max_length=255)
    birthdate = models.DateField()
    institute = models.CharField(max_length=255)
    department = models.CharField(max_length=255)
    cgpa = models.FloatField(max_length=4)
    passing_year = models.IntegerField()
    domains = models.CharField(max_length=255) 
   
    def __str__(self):
        return self.id_no
    
 
    


# class UserProfile(models.Model):
#     user = models.OneToOneField(Student_details, on_delete=models.CASCADE)
#     is_student = models.BooleanField(default=False)