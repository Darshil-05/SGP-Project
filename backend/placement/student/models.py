from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.utils import timezone
from django.contrib.postgres.fields import ArrayField



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
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)
    last_login = models.DateTimeField(null=True, blank=True)

    objects = StudentManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']

    def __str__(self):
        return self.email
    

    
class Student_details(models.Model):
   

    id_no = models.CharField(max_length=15,unique=True)
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
    # phone_no=models.BigIntegerField(null=True)
    # experience = models.CharField(max_length=500,null=False,blank=True)
    # certification = ArrayField(models.CharField(max_length=255),blank=True,default=list)
    # city,prog-skill and tech-skill,experince,certification
   
    def __str__(self):
        return self.id_no
    
class Certificate(models.Model):
    student = models.ForeignKey(Student_details, related_name='certificates', on_delete=models.CASCADE)
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
    