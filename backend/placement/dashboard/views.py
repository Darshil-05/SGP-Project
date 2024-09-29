from django.shortcuts import render

# Create your views here.
# your_app_name/views.py

import pandas as pd
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import JobDomain
import matplotlib.pyplot as plt
import base64
import io
from django.db import models
from django.http import FileResponse

class ImportPlacementData(APIView):
    def post(self, request, *args, **kwargs):
        if 'file' not in request.FILES:
            return Response({"error": "No file provided"}, status=status.HTTP_400_BAD_REQUEST)

        excel_file = request.FILES['file']

        try:
            df = pd.read_excel(excel_file)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

        # Assume your Excel has 'year', 'domain', and 'count' columns
        for _, row in df.iterrows():
            job_data = JobDomain(year=row['year'], domain=row['domain'], count=row['count'])
            job_data.save()

        return Response({"message": "Data imported successfully"}, status=status.HTTP_201_CREATED)

    def get(self, request, *args, **kwargs):
        years_param = request.query_params.get('years')
        
        if years_param:
            year_range = list(map(int, years_param.split(',')))  # Convert to a list of integers
            pie_chart_path = self.get_pie_chart(year_range)

            # Return the image as a downloadable file
            return FileResponse(open(pie_chart_path, 'rb'), as_attachment=True, filename='pie_chart.png')
        
        return Response({"error": "No years provided"}, status=status.HTTP_400_BAD_REQUEST)

    def get_pie_chart(self, year_range):
        # Fetch the data based on year range
        data = (
            JobDomain.objects
            .filter(year__in=year_range)
            .values('domain')
            .annotate(total_count=models.Sum('count'))
        )

        domains = [item['domain'] for item in data]
        counts = [item['total_count'] for item in data]

        plt.figure(figsize=(8, 6))
        plt.pie(counts, labels=domains, autopct='%1.1f%%', startangle=90)
        plt.axis('equal')

        # Save the pie chart as a PNG file
        pie_chart_path = 'pie_chart.png'
        plt.savefig(pie_chart_path)
        plt.close()

        return pie_chart_path

