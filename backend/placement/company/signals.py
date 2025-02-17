from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver

@receiver(post_save, sender='company.CompanyRegistration')  # Use string reference
def create_sortlisted_entry(sender, instance, created, **kwargs):
    """ Automatically create a record in sortlisted when a new CompanyRegistration is created """
    if created:
        from .models import sortlisted  # Import inside function
        sortlisted.objects.create(
            student=instance.student,
            student_id_no=instance.student_id_no,
            company=instance.company,
            company_name=instance.company_name
        )

@receiver(post_delete, sender='company.sortlisted')  # Use string reference
def delete_company_registration(sender, instance, **kwargs):
    """ Automatically delete corresponding CompanyRegistration entry when sortlisted entry is deleted """
    from .models import CompanyRegistration  # Import inside function
    try:
        company_registration = CompanyRegistration.objects.get(student=instance.student, company=instance.company)
        company_registration.delete()
    except CompanyRegistration.DoesNotExist:
        pass
