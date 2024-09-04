# Generated by Django 5.0.6 on 2024-08-24 14:20

import django.utils.timezone
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Student_details',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=255)),
                ('email', models.EmailField(max_length=254)),
                ('password', models.CharField(max_length=255)),
                ('last_login', models.DateTimeField(blank=True, default=django.utils.timezone.now, null=True)),
            ],
            options={
                'abstract': False,
            },
        ),
    ]