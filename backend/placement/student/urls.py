from django.urls import path
from .views import *

urlpatterns = [
    # path('studentinfo/',StudentDetailsPost.as_view(), name='student-detials'),
    # path('studentinfoget/',StudentDetailsview.as_view(), name='student-detials-get'),
    path('export-students/', ExportStudentData.as_view(), name='export-students'),
    path('students-create&list/', StudentDetailsList.as_view(), name='student-list'),
    path('students-detail-edit/<str:id_no>/', StudentDetailsEdit.as_view(), name='student-detail'),
    path('certificates/', CertificateList.as_view(), name='certificate-list'),
    path('certificates/<int:pk>/', CertificateDetail.as_view(), name='certificate-detail'),
    path('experience/', ExperienceList.as_view(), name='experience-list'),
    path('experience/<int:pk>/', ExperienceDetails.as_view(), name='experience-detail'),
    # path('import-students/', ImportStudentData.as_view(), name='import-students'),
]