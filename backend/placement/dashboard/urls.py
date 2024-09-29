from django.urls import path
from .views import ImportPlacementData

urlpatterns = [
    path('import-excel/', ImportPlacementData.as_view(), name='import_excel'),
    path('get-pie-charts/', ImportPlacementData.as_view(), name='get_pie_charts'),  # New endpoint
]