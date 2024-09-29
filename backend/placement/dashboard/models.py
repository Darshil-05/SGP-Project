from django.db import models


class JobDomain(models.Model):
    year = models.IntegerField()
    domain = models.CharField(max_length=100)
    count = models.IntegerField()

    def __str__(self):
        return f"{self.year} - {self.domain}"
