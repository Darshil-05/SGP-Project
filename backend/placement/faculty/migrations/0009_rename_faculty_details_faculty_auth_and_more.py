# Generated by Django 5.0.6 on 2024-09-02 03:14

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('faculty', '0008_delete_userprofile'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='Faculty_details',
            new_name='Faculty_auth',
        ),
        migrations.RenameField(
            model_name='faculty_auth',
            old_name='id',
            new_name='faculty_id',
        ),
    ]