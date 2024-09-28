from django.urls import path
from .views import *

urlpatterns = [
    path('companies/', CompanyDetailsList.as_view(), name='company-list'),
    path('companies/<int:pk>/', CompanyDetailsDetail.as_view(), name='company-detail'),
    path('interview-rounds/', InterviewRoundList.as_view(), name='interview-round-list'),
    path('interview-rounds/<int:pk>/', InterviewRoundDetail.as_view(), name='interview-round-detail'),
  
]


# {
#     "comapny_name": "Patel @ sons",
#     "details": "JS,REACT",
#     "min_package": "300000",
#     "max_package": "800000",
#     "comapny_hq_location": "Ahemdvad",
#     "work_locations": "Nadiad",
#     "comapny_web": "www.neel.com",
#     "company_contact": "123465879"
# }