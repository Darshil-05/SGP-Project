from rest_framework import serializers
from .models import CompanyDetails

# serializers.py
from rest_framework import serializers
from .models import CompanyDetails


class CompanyDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = CompanyDetails
        fields = '__all__'

    def validate(self, data):
        if data['min_package'] > data['max_package']:
            raise serializers.ValidationError("Min package cannot be greater than max package")
        return data

    def create(self, validated_data):
            return CompanyDetails.objects.create(**validated_data)
        

    def update(self, instance, validated_data):
        
            instance.comapny_name = validated_data.get('comapny_name', instance.comapny_name)
            instance.details = validated_data.get('details', instance.details)
            instance.min_package = validated_data.get('min_package', instance.min_package)
            instance.max_package = validated_data.get('max_package', instance.max_package)
            instance.bond = validated_data.get('bond', instance.bond)
            instance.comapny_hq_location = validated_data.get('comapny_hq_location', instance.comapny_hq_location)
            instance.work_locations = validated_data.get('work_locations', instance.work_locations)
            instance.comapny_web = validated_data.get('comapny_web', instance.comapny_web)
            instance.company_contact = validated_data.get('company_contact', instance.company_contact)
            instance.save()
            return instance
        

    def delete(self, instance):
    
            instance.delete()
            return instance
    

    def to_representation(self, instance):
            return {
                'company_id': instance.company_id,
                'comapny_name': instance.comapny_name,
                'details': instance.details,
                'min_package': instance.min_package,
                'max_package': instance.max_package,
                'bond': instance.bond,
                'comapny_hq_location': instance.comapny_hq_location,
                'work_locations': instance.work_locations,
                'comapny_web': instance.comapny_web,
                'company_contact': instance.company_contact
            }
# # class CompanyPlacementDriveSerializer(serializers.ModelSerializer):
# #     class Meta:
# #         model = CompanyPlacementDrive
# #         fields = '__all__'