from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone
from datetime import timedelta

class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('Users must have an email address')
        email = self.normalize_email(email)
        
        # Determine role based on email domain
        if email.endswith('@charusat.ac.in'):
            extra_fields['role'] = 'faculty'
        elif email.endswith('@charusat.edu.in'):
            extra_fields['role'] = 'student'
        else:
            raise ValueError('Invalid email domain. Must end with @charusat.ac.in for faculty or @charusat.edu.in for student')
        
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('role', 'admin')
        return self.create_user(email, password, **extra_fields)

class UserAuth(AbstractBaseUser, PermissionsMixin):
    ROLE_CHOICES = (
        ('student', 'Student'),
        ('faculty', 'Faculty'),
        ('admin', 'Admin'),
    )

    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    email = models.EmailField(unique=True)
    role = models.CharField(max_length=10, choices=ROLE_CHOICES)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    date_joined = models.DateTimeField(default=timezone.now)
    last_login = models.DateTimeField(null=True, blank=True)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']

    def __str__(self):
        return self.email

    def is_student(self):
        return self.role == 'student'

    def is_faculty(self):
        return self.role == 'faculty'

class OTP(models.Model):
    email = models.EmailField()
    otp_code = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)

    def is_valid(self):
        # OTP is valid for 10 minutes
        return timezone.now() < self.created_at + timedelta(minutes=10)
    
    def created_at_local(self):
        # Convert created_at to local time (IST)
        return self.created_at.astimezone(timezone.pytz.timezone('Asia/Kolkata'))

    def __str__(self):
        return f"{self.email} - {self.otp_code}"

class FCMToken(models.Model):
    fcm_id_no = models.CharField(max_length=255)
    token = models.CharField(max_length=255)
    user_type = models.CharField(max_length=20)  # student/faculty
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('fcm_id_no', 'token')
