# Generated by Django 5.1.1 on 2024-09-28 11:06

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('student', '0010_remove_student_details_experience'),
    ]

    operations = [
        migrations.AddField(
            model_name='student_details',
            name='experience',
            field=models.CharField(blank=True, max_length=500),
        ),
    ]
