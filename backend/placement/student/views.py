
from django.shortcuts import get_object_or_404
from rest_framework import status
import pandas as pd # type: ignore
from django.http import HttpResponse
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.response import Response
from .models import Student_details
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import generics
from .models import Student_details, Certificate, Experience
from .serializers import StudentDetailsSerializer, CertificateSerializer,ExperienceSerializer

class StudentDetailsList(generics.ListCreateAPIView):
    queryset = Student_details.objects.all()
    serializer_class = StudentDetailsSerializer



class StudentDetailsEdit(generics.RetrieveUpdateDestroyAPIView):
    queryset = Student_details.objects.all()
    serializer_class = StudentDetailsSerializer

    def get_object(self):
        id_no = self.kwargs.get("id_no")
        return get_object_or_404(Student_details, id_no=id_no)

class CertificateList(generics.ListCreateAPIView):
    queryset = Certificate.objects.all()
    serializer_class = CertificateSerializer

class CertificateDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Certificate.objects.all()
    serializer_class = CertificateSerializer

class ExperienceList(generics.ListCreateAPIView):
    queryset = Experience.objects.all()
    serializer_class = ExperienceSerializer

class ExperienceDetails(generics.RetrieveUpdateDestroyAPIView):
    queryset = Experience.objects.all()
    serializer_class = ExperienceSerializer

class ExportStudentData(APIView):
    
    def get(self, request):
        # Get all student details with related fields
        students = Student_details.objects.prefetch_related('certificates', 'experience').all()

        # Prepare data for each student
        data = []

        for student in students:
            student_info = {
                'Student ID': student.id_no,
                'First Name': student.first_name,
                'Last Name': student.last_name,
                'Birthdate': student.birthdate,
                'Institute': student.institute,
                'Department': student.department,
                'CGPA': student.cgpa,
                'Passing Year': student.passing_year,
                'Domains': student.domains,
                'City': student.city,
                'Programming Skill': student.programming_skill,
                'Tech Skill': student.tech_skill,
                'Certificates': [
                    f"{cert.name} - {cert.platform}" for cert in student.certificates.all()
                ],
                'Experience': [
                    f"{exp.role} at {exp.organization}" for exp in student.experience.all()
                ]
            }
            data.append(student_info)

        # Convert the list of student data into a Pandas DataFrame
        df = pd.DataFrame(data)

        # Export DataFrame to Excel
        response = HttpResponse(content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        response['Content-Disposition'] = 'attachment; filename=students.xlsx'
        df.to_excel(response, index=False, engine='openpyxl')
        
        return response  
# class ExportStudentData(APIView):
#     def get(self, request):
#         # Get all student details
#         students= Student_details.objects.all().values()
        
#         data = []

#         # Prepare lists for each section
#         for student in students:
#             # Gather student info including related fields like certificates and experience
#             student_info = {
#                 'Student ID': student['id_no'],
#                 'First Name': student['first_name'],
#                 'Last Name': student['last_name'],
#                 'Birthdate': student['birthdate'],
#                 'Institute': student['institute'],
#                 'Department': student['department'],
#                 'CGPA': student['cgpa'],
#                 'Passing Year': student['passing_year'],
#                 'Domains': student['domains'],
#                 'City': student['city'],
#                 'Programming Skill': student['programming_skill'],
#                 'Tech Skill': student['tech_skill'],
#                 'Certificates': [
#                     {
#                         'Certificate': cert['name'],
#                         'Platform': cert['platform']
#                     } for cert in student['certificates']
#                 ],
#                 'Experience': [
#                     {
#                         'Position': exp['role'],
#                         'Organization': exp['organization']
#                     } for exp in student.experience.all()
#                 ]
#             }
#             data.append(student_info)

#         # Convert the QuerySet to a Pandas DataFrame
#         df = pd.DataFrame(students)

#         # Export DataFrame to Excel
#         response = HttpResponse(content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
#         response['Content-Disposition'] = 'attachment; filename=students.xlsx'
#         df.to_excel(response, index=False, engine='openpyxl')
        
#         return response


# class ImportStudentData(APIView):
#     parser_classes = [MultiPartParser, FormParser]  # Supports file and form data parsing

#     def post(self, request, *args, **kwargs):
#         excel_file = request.FILES.get('file', None)  # Get the uploaded file
        
#         if not excel_file:
#             return Response({"error": "No file uploaded."}, status=status.HTTP_400_BAD_REQUEST)

#         # Check if the file is in the correct Excel format
#         if not excel_file.name.endswith(('.xlsx', '.xls')):
#             return Response({"error": "File is not an Excel file."}, status=status.HTTP_400_BAD_REQUEST)

#         try:
#             # Read the uploaded Excel file into a pandas DataFrame
#             df = pd.read_excel(excel_file)

#             # Convert the DataFrame into a list of dictionaries
#             data_dict = df.to_dict(orient="records")

#             # Loop through and save data to the database
#             for student_data in data_dict:
#                 student_id_no = student_data.get('id_no')
#                 student, created = Student_details.objects.update_or_create(
#                     id_no=student_id_no,
#                     defaults=student_data
#                 )
#             return Response({"message": "Data imported successfully."}, status=status.HTTP_201_CREATED)
#         except Exception as e:
#             return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)