from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager,PermissionsMixin
from django.utils import timezone
from django.contrib.postgres.fields import ArrayField


class Student_details(models.Model):
    id_no = models.CharField(max_length=15,unique=True,primary_key=True)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    birthdate = models.DateField()
    institute = models.CharField(max_length=255)
    department = models.CharField(max_length=255)
    cgpa = models.FloatField(max_length=4)
    passing_year = models.IntegerField()
    domains = models.CharField(max_length=255)
    city = models.CharField(max_length=255,null=True)
    programming_skill = models.CharField(max_length=255)
    tech_skill = models.CharField(max_length=255)
    student_email_id = models.EmailField(unique=True)
    created_at = models.DateTimeField(auto_now_add=True)



    def __str__(self):
        return self.id_no
    
class Certificate(models.Model):
    student = models.ForeignKey(Student_details, related_name='certificates', on_delete=models.CASCADE,max_length=255)
    name = models.CharField(max_length=255)
    platform = models.CharField(max_length=255)
    
    class Meta:
        unique_together = ('student', 'name')

    def __str__(self):
        return f"{self.name} - {self.student.id_no}"
    
class Experience(models.Model):
    student = models.ForeignKey(Student_details, related_name='experience', on_delete=models.CASCADE)
    role = models.CharField(max_length=255)
    organization = models.CharField(max_length=255)

    

    def __str__(self):
        return f"{self.role} - {self.student.id_no}"
    