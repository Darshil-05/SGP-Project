# from django.db import models
# from student .models import Student_details
# from faculty .models import Faculty_details


# class CompanyDetails(models.Model):
#     company_id = models.AutoField(primary_key=True)
#     comapny_name = models.CharField(max_length=255)
#     details = models.TextField()
#     min_package = models.BigIntegerField()
#     max_package = models.BigIntegerField()
#     bond = models.IntegerField(null=True)
#     comapny_hq_location = models.CharField(max_length=255)
#     work_locations = models.CharField(max_length=255)
#     comapny_web = models.CharField(max_length=255)
#     company_contact = models.IntegerField()

#     def __str__(self):
#         return self.comapny_name

# # class CompanyPlacementDrive(models.Model):
# #     company = models.ForeignKey(CompanyDetails, on_delete=models.CASCADE)  # Relation
# #     date = models.DateField()
# #     recruiter_name = models.CharField(max_length=255)
# #     recruiter_email = models.EmailField()
# #     form_last_date = models.DateTimeField()
# #     form_filled = models.IntegerField()
# #     venue = models.CharField(max_length=255)
# #     no_of_rounds = models.SmallIntegerField()
# #     form_start_date = models.DateTimeField()
# #     no_of_student = models.IntegerField()

# #     def __str__(self):
# #         return f"{self.company.comapny_name} - {self.date}"