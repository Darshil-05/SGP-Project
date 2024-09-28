from rest_framework import serializers
from .models import CompanyDetails,InterviewRound


class CompanyDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = CompanyDetails
        fields = '__all__'




class InterviewRoundSerializer(serializers.ModelSerializer):
    class Meta:
        model = InterviewRound
        fields = '__all__'

# # class CompanyPlacementDriveSerializer(serializers.ModelSerializer):
# #     class Meta:
# #         model = CompanyPlacementDrive
# #         fields = '__all__'