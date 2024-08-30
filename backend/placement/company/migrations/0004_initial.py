# Generated by Django 5.0.6 on 2024-08-28 11:54

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('company', '0003_delete_companydetails'),
    ]

    operations = [
        migrations.CreateModel(
            name='CompanyDetails',
            fields=[
                ('company_id', models.AutoField(primary_key=True, serialize=False)),
                ('comapny_name', models.CharField(max_length=255)),
                ('details', models.TextField()),
                ('min_package', models.BigIntegerField()),
                ('max_package', models.BigIntegerField()),
                ('bond', models.IntegerField(null=True)),
                ('comapny_hq_location', models.CharField(max_length=255)),
                ('work_locations', models.CharField(max_length=255)),
                ('comapny_web', models.CharField(max_length=255)),
                ('company_contact', models.IntegerField()),
            ],
        ),
    ]
