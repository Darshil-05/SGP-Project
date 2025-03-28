from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.db import transaction

@receiver(post_save, sender='company.CompanyRegistration')
def create_sortlisted_entry(sender, instance, created, **kwargs):
    """Create a record in sortlisted when a new CompanyRegistration is created"""
    if created:
        from .models import sortlisted
        try:
            # Create sortlisted entry directly without get_or_create
            sortlisted.objects.create(
                student=instance.student,
                student_id_no=instance.student_id_no,
                company=instance.company,
                company_name=instance.company_name
            )
            print(f"Sortlisted entry created for student {instance.student_id_no}")  # Debug print
        except Exception as e:
            print(f"Error creating sortlisted entry: {str(e)}")  # Debug print

@receiver(post_delete, sender='company.sortlisted')  # Use string reference
def delete_company_registration(sender, instance, **kwargs):
    """ Automatically delete corresponding CompanyRegistration entry when sortlisted entry is deleted """
    from .models import CompanyRegistration  # Import inside function
    try:
        CompanyRegistration.objects.filter(  # Changed from get to filter
            student=instance.student, 
            company=instance.company
        ).delete()
    except CompanyRegistration.DoesNotExist:
        pass
