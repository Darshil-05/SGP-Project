# Generated by Django 5.0.6 on 2025-02-03 03:45

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('company', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='companyregistration',
            name='company_name',
            field=models.CharField(default='demo', max_length=255),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='companyregistration',
            name='student_id_no',
            field=models.CharField(default='22itxxx', max_length=15),
            preserve_default=False,
        ),
    ]
