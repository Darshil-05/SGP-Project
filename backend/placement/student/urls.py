from django.urls import path
from .views import *

urlpatterns = [
    path('studentinfo/',StudentDetailsPost.as_view(), name='student-detials'),
    path('studentinfoget/',StudentDetailsview.as_view(), name='student-detials-get'),
    path('export-students/', ExportStudentData.as_view(), name='export-students'),
    # path('import-students/', ImportStudentData.as_view(), name='import-students'),
]