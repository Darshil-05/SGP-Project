# Generated by Django 5.0.6 on 2024-09-29 08:38

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='JobDomain',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('year', models.IntegerField(max_length=4)),
                ('domain', models.CharField(max_length=100)),
                ('count', models.IntegerField()),
            ],
        ),
    ]
