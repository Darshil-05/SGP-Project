from django.db import models
import re
import phonenumbers
from django.core.exceptions import ValidationError
from student.models import Student_auth,Student_details


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
    company_name = models.CharField(max_length=255)
    company_website = models.CharField(max_length=255,null=True)
    headquarters = models.CharField(max_length=255,null=True)
    industry = models.CharField(max_length=255,null=True)
    details = models.TextField(null=True)
    date_placementdrive = models.DateField(null=True)
    application_deadline = models.DateField(null=True)
    joining_date = models.DateField(null=True)
    hr_name = models.CharField(max_length=255,null=True)
    hr_email = models.EmailField(unique=True,null=True)
    hr_contact = models.CharField(max_length=15,null=True)
    bond = models.IntegerField(null=True)
    benefits = models.CharField(max_length=255,null=True)
    doc_required = models.CharField(max_length=255,null=True)
    process_stages = models.CharField(max_length=255,null=True)
    eligibility_criteria = models.CharField(max_length=255,null=True)
    no_round = models.IntegerField()
    cutoff_marks = models.CharField(max_length=200,null=True)
    selection_ratio = models.CharField(max_length=20,null=True)
    duration_internship = models.CharField(max_length=20,null=True)
    stipend = models.IntegerField(null=True)
    job_role = models.CharField(max_length=255,null=True)
    job_description = models.CharField(max_length=255,null=True)
    skills = models.CharField(max_length=200,null=True)
    job_location = models.CharField(max_length=200)
    # job_salary = models.CharField(max_length=100,null=True)
    job_type = models.CharField(max_length=20 , null=True)
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


class CompanyRegistration(models.Model):
    student = models.ForeignKey(Student_details, on_delete=models.CASCADE, related_name='company_registrations')
    company = models.ForeignKey(CompanyDetails, on_delete=models.CASCADE, related_name='registered_students')
    registration_date = models.DateField(auto_now_add=True)

    class Meta:
        unique_together = ('student', 'company')  # Ensures that a student can register only once per company

    def __str__(self):
        return f"{self.student.name} registered for {self.company.company_name}"

