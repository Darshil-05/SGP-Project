from django.db import models

# Create your models here.
class public_announcement(models.Model):
    
    
    title = models.CharField(max_length=250)
    description = models.TextField(max_length=500)
    comapny_name = models.CharField(max_length=255)

    def __str__(self):
        return self.title