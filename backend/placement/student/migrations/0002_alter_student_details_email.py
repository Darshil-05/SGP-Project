# Generated by Django 5.0.6 on 2024-08-25 05:45

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('student', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='student_details',
            name='email',
            field=models.EmailField(max_length=254, unique=True),
        ),
    ]
