from django.urls import path
from .views import *


urlpatterns = [
    path('export-company-registrations/<int:company_id>/', ExportCompanyRegistrationData.as_view(), name='export-company-registrations'),
    path('companies-create&list/', CompanyDetailsList.as_view(), name='company-list'),
    path('companies-detail-edit/<int:pk>/', CompanyDetailsDetail.as_view(), name='company-detail'),
    # path('interview-rounds/', InterviewRoundCreateView.as_view(), name='interview-round-create'),
    path('interview-round/<int:company_id>/<int:index>/', InterviewRoundDetail.as_view(), name='interview-round-detail'),
    path('company-registration/', CompanyRegistrationListCreate.as_view(), name='company-registration'),
    path('interview-rounds/company/<int:company_id>/', InterviewRoundByCompanyList.as_view(), name='interview-rounds-by-company'),
    path('students/registered/<str:company_name>/', RegisteredStudentsByCompanyList.as_view(), name='registered-students-by-company'),
    # path('get-eligible-students/<int:company_id>/<int:round_id>/', RetrieveEligibleStudentsView.as_view(), name='get_eligible_students'),
    # path('update-progress/<int:company_id>/<int:round_index>/', UpdateStudentInterviewProgressView.as_view(), name='update_progress'),
    # path('company/company-info/', CompanyInfoView.as_view(), name='company-details'),
    path('interview-rounds-get/', InterviewRoundList.as_view(), name='interview-round-list'),
    path('sortlisted-students/<int:company_id>/', SortlistedStudentsByCompanyList.as_view(), name='sortlisted-students'),
    path('delete-sortlisted/<int:company_id>/', DeleteSortlistedStudent.as_view(), name='delete-sortlisted-student'),
] 