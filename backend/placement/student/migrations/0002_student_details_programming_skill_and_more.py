# Generated by Django 5.1.1 on 2024-09-25 14:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('student', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='student_details',
            name='programming_skill',
            field=models.CharField(blank=True, max_length=50),
        ),
        migrations.AddField(
            model_name='student_details',
            name='tech_skill',
            field=models.CharField(blank=True, max_length=100),
        ),
    ]
