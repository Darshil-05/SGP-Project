from django.db import models
import re
import phonenumbers
from django.core.exceptions import ValidationError


# def validate_number(mobile_number):
#     """Validator for international mobile numbers."""
#     try:
#         # Parse the phone number with a default region (you can set it to 'IN' for India or use dynamic country code)
#         parsed_number = phonenumbers.parse(phone_number, None)
        
#         # Check if the number is valid
#         if not phonenumbers.is_valid_number(parsed_number):
#             raise ValidationError(f"{phone_number} is not a valid mobile number.")
        
#         # Optionally, you can check if the number is a mobile number specifically
#         if not phonenumbers.is_valid_number_for_region(parsed_number, 'IN'):
#             raise ValidationError(f"{phone_number} is not a valid mobile number for the specified region.")
        
#     except phonenumbers.NumberParseException:
#         raise ValidationError(f"{phone_number} is not a valid mobile number format.")

class CompanyDetails(models.Model):
    company_id = models.AutoField(primary_key=True)
    comapny_name = models.CharField(max_length=255)
    company_website = models.CharField(max_length=255)
    headquarters = models.CharField(max_length=255)
    industry = models.CharField(max_length=255)
    details = models.TextField()
    date_placementdrive = models.DateField()
    application_deadline = models.DateField()
    joining_date = models.DateField()
    hr_name = models.CharField(max_length=255)
    hr_email = models.EmailField(unique=True)
    hr_contact = models.CharField(max_length=15)
    bond = models.IntegerField(null=True)
    benefits = models.CharField(max_length=255)
    doc_required = models.CharField(max_length=255)
    process_stages = models.CharField(max_length=255)
    eligibility_criteria = models.CharField(max_length=255)
    no_round = models.IntegerField()
    cutoff_marks = models.CharField(max_length=200)
    selection_ratio = models.CharField(max_length=20)
    duration_internship = models.CharField(max_length=20)
    stipend = models.IntegerField()
    job_role = models.CharField(max_length=255)
    job_description = models.CharField(max_length=255)
    skills = models.CharField(max_length=200)
    job_location = models.CharField(max_length=200)
    job_salary = models.IntegerField()
    job_type = models.CharField(max_length=20)
    min_package = models.BigIntegerField()
    max_package = models.BigIntegerField()
    # company_contact = models.CharField(max_length=15)
    # company_contact = models.CharField(max_length=15)


    def __str__(self):
        return self.comapny_name 



class InterviewRound(models.Model):
    ROUND_STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('completed', 'Completed'),
        ('running', 'Running'),
        
    ]

    company = models.ForeignKey(CompanyDetails, related_name='interview_rounds', on_delete=models.CASCADE)
    round_number = models.PositiveIntegerField()
    status = models.CharField(max_length=10, choices=ROUND_STATUS_CHOICES, default='pending')
    # scheduled_date = models.DateField(null=True, blank=True)

    class Meta:
        unique_together = ('company', 'round_number')  # Ensure a company can't have the same round number multiple times

    def __str__(self):
        return f"Round {self.round_number} for {self.company.company_name} - Status: {self.status}"

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


