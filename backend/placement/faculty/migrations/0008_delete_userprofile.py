# Generated by Django 5.0.6 on 2024-09-01 15:56

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('faculty', '0007_remove_faculty_details_user'),
    ]

    operations = [
        migrations.DeleteModel(
            name='UserProfile',
        ),
    ]
