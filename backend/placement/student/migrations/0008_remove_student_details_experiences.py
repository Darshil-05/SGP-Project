# Generated by Django 5.1.1 on 2024-09-28 11:04

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('student', '0007_student_details_experiences'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='student_details',
            name='experiences',
        ),
    ]