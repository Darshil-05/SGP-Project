from django.db import models
import re
import phonenumbers
from django.core.exceptions import ValidationError
from student.models import Student_details
from django.utils.timezone import now

class CompanyImages(models.Model):
    id = models.AutoField(primary_key=True)
    image = models.ImageField(upload_to="company_images/")  # Store images in media folder

    def __str__(self):
        return self.image.name

class CompanyDetails(models.Model):
    company_id = models.AutoField(primary_key=True)
    company_name = models.CharField(max_length=255)
    company_website = models.CharField(max_length=255, null=True)
    headquarters = models.CharField(max_length=255, null=True)
    industry = models.CharField(max_length=255, null=True)
    details = models.TextField(null=True)
    date_placementdrive = models.DateField()
    application_deadline = models.DateField()
    joining_date = models.DateField(null=True)
    hr_name = models.CharField(max_length=255, null=True)
    hr_email = models.EmailField(unique=True, null=True)
    hr_contact = models.CharField(max_length=15, null=True)
    bond = models.IntegerField(null=True)
    benefits = models.CharField(max_length=255, null=True)
    doc_required = models.CharField(max_length=255, null=True)
    process_stages = models.CharField(max_length=255, null=True)
    eligibility_criteria = models.CharField(max_length=255, null=True)
    # no_round = models.IntegerField()
    cutoff_marks = models.CharField(max_length=200, null=True)
    selection_ratio = models.CharField(max_length=20, null=True)
    duration_internship = models.CharField(max_length=20, null=True)
    stipend = models.IntegerField(null=True)
    job_role = models.CharField(max_length=255, null=True)
    job_description = models.CharField(max_length=255)
    skills = models.CharField(max_length=200, null=True)
    job_location = models.CharField(max_length=200)
    job_type = models.CharField(max_length=20, null=True)
    min_package = models.BigIntegerField()
    max_package = models.BigIntegerField()

    image = models.ForeignKey(CompanyImages, on_delete=models.SET_NULL, null=True, blank=True)

    def save(self, *args, **kwargs):
        is_new = self.pk is None  # Check if object is new

        super().save(*args, **kwargs)  # Save first to generate company_id

        if is_new and not self.image:  # Assign an image only if it's a new entry
            total_images = CompanyImages.objects.count()
            if total_images > 0:
                image_list = list(CompanyImages.objects.all())  # Get all images
                assigned_image = image_list[self.company_id % total_images]  # Now company_id is assigned
                self.image = assigned_image  
                super().save(update_fields=['image'])  # Update only the image field

    def __str__(self):
        return self.company_name 



class InterviewRound(models.Model):
    ROUND_STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('completed', 'Completed'),
        ('running', 'Running'),
    ]

    company = models.ForeignKey(CompanyDetails, related_name='interview_rounds', on_delete=models.CASCADE)
    round_name = models.CharField(max_length=255)  # Changed from round_number to round_name
    status = models.CharField(max_length=10, choices=ROUND_STATUS_CHOICES, default='pending')
    index =  models.IntegerField()

    def save(self, *args, **kwargs):
        if self.index is None:  # Ensure the index is assigned only when not set
            last_round = InterviewRound.objects.filter(company=self.company).order_by('-index').first()
            self.index = (last_round.index + 1) if last_round else 0  # Increment index for the company
        super().save(*args, **kwargs)
        
    class Meta:
        unique_together = ('company', 'round_name')  # Ensure unique round names per company

    def __str__(self):
        return f"{self.round_name} for {self.company.company_name} - Status: {self.status}"



class CompanyRegistration(models.Model):
    student = models.ForeignKey(Student_details, on_delete=models.CASCADE, related_name='company_registrations')
    student_id_no = models.CharField(max_length=15)  # Store student ID explicitly
    company = models.ForeignKey(CompanyDetails, on_delete=models.CASCADE, related_name='registered_students')
    company_name = models.CharField(max_length=255)  # Store company name explicitly
    registration_date = models.DateField(auto_now_add=True)


    
    class Meta:
        unique_together = ('student', 'company')  # Ensures that a student can register only once per company

    def save(self, *args, **kwargs):
        """ Override save method to auto-populate student_id_no and company_name """
        if not self.student_id_no:
            self.student_id_no = self.student.id_no
        if not self.company_name:
            self.company_name = self.company.company_name
        super().save(*args, **kwargs)


    def __str__(self):
        return f"Student ID: {self.student_id_no} registered for {self.company_name}"
    
class sortlisted(models.Model):
    student = models.ForeignKey(Student_details, on_delete=models.CASCADE, related_name='sortlisted_registrations')
    student_id_no = models.CharField(max_length=15)  # Store student ID explicitly
    company = models.ForeignKey(CompanyDetails, on_delete=models.CASCADE, related_name='sortlisted_students')
    company_name = models.CharField(max_length=255)  # Store company name explicitly
    registration_date = models.DateField(auto_now_add=True)

    class Meta:
        unique_together = ('student', 'company')  # Ensures that a student can register only once per company

    def save(self, *args, **kwargs):
        """ Override save method to auto-populate student_id_no and company_name """
        if not self.student_id_no:
            self.student_id_no = self.student.id_no
        if not self.company_name:
            self.company_name = self.company.company_name
        super().save(*args, **kwargs)
    
        if not sortlisted.objects.filter(student=self.student, company=self.company).exists():
            sortlisted.objects.create(
                student=self.student,
                student_id_no=self.student_id_no,
                company=self.company,
                company_name=self.company_name
            )

    def __str__(self):
        return f"Student ID: {self.student_id_no} registered for {self.company_name}"

# class StudentInterviewProgress(models.Model):
#     student = models.ForeignKey(Student_details, on_delete=models.CASCADE, related_name='interview_progress')
#     company = models.ForeignKey(CompanyDetails, on_delete=models.CASCADE, related_name='student_progress')
#     round = models.ForeignKey(InterviewRound, on_delete=models.CASCADE, related_name='student_progress')
#     round_index = models.IntegerField()  # Explicit round number for quick access
#     is_passed = models.BooleanField(default=False)
#     is_present = models.BooleanField(default=False)
#     date_updated = models.DateTimeField(auto_now=True)

#     class Meta:
#         unique_together = ('student', 'company', 'round_index')  # Prevent duplicate records

#     def save(self, *args, **kwargs):
#         if self.interview_round and not self.round_index:
#             self.round_index = self.interview_round.index  # Auto-assign if not set
#         super().save(*args, **kwargs)

#     def __str__(self):
#         return f"{self.student.student_id} - {self.company.company_name} - Round {self.round_index}"



class CompanyApplications(models.Model):
    student = models.ForeignKey(Student_details, on_delete=models.CASCADE, related_name='applications')
    company = models.ForeignKey(CompanyDetails, on_delete=models.CASCADE, related_name='applications')
    student_unique_id = models.CharField(max_length=15)   # Store the student's unique ID
    company_name = models.CharField(max_length=255)  # Store the company's name
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    applied_date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Student {self.student_id} applied to {self.company_name}"





# neel