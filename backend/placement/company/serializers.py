from rest_framework import serializers
from .models import CompanyDetails


class CompanyDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = CompanyDetails
        fields = '__all__'

# # class CompanyPlacementDriveSerializer(serializers.ModelSerializer):
# #     class Meta:
# #         model = CompanyPlacementDrive
# #         fields = '__all__'