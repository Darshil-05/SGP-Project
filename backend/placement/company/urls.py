from django.urls import path
from .views import *


urlpatterns = [
    path('companies/', CompanyDetailsList.as_view(), name='company-list'),
    path('companies/<int:pk>/', CompanyDetailsDetail.as_view(), name='company-detail'),
    path('interview-rounds/', InterviewRoundCreateView.as_view(), name='interview-round-list'),
    path('interview-rounds/<int:pk>/', InterviewRoundDetail.as_view(), name='interview-round-detail'),
    path('company-registration/', CompanyRegistrationListCreate.as_view(), name='company-registration'),
    path('interview-rounds/company/<str:company_name>/', InterviewRoundByCompanyList.as_view(), name='interview-rounds-by-company'),
    path('students/registered/<str:company_name>/', RegisteredStudentsByCompanyList.as_view(), name='registered-students-by-company'),
    path('get-eligible-students/', RetrieveEligibleStudentsView.as_view(), name='get_eligible_students'),
    path('update-progress/<int:pk>/', UpdateStudentInterviewProgressView.as_view(), name='update_progress'),
    path('company/company-info/', CompanyInfoView.as_view(), name='company-details'),

] 