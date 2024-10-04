from django.db import models
from django.utils import timezone
from datetime import timedelta

class OTP(models.Model):
    email = models.EmailField()
    otp_code = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    user_type = models.CharField(max_length=10,default='student')

    def is_valid(self):
        # OTP is valid for 10 minutes
        return timezone.now() < self.created_at + timedelta(minutes=10)
    
    def created_at_local(self):
        # Convert created_at to local time (IST)
        return self.created_at.astimezone(timezone.pytz.timezone('Asia/Kolkata'))

    def __str__(self):
        return f"{self.email} - {self.otp_code}"
