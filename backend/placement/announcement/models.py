from django.db import models
from django.utils.timezone import now, timedelta

class PublicAnnouncement(models.Model):
    title = models.CharField(max_length=250)
    description = models.TextField(max_length=500)
    company_name = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

    def is_expired(self):
        """Check if the announcement is expired (older than 15 days)."""
        return now() > self.created_at + timedelta(days=15)

    def __str__(self):
        return self.title

from django.db import models
from student.models import  Student_details

