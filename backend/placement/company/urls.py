from django.urls import path, include

from .views import *


urlpatterns = [
    path('company_Details/', CompanyDetailsView.as_view(), name='company-detials'),
    path('company_Details-crud/<int:pk>/',CompanyDetailsedit.as_view(),name='company-crud'),
    path('company_Details-post/',CompanyDetailsPost.as_view(),name='company-post'),

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