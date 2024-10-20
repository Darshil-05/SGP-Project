from rest_framework import serializers
from .models import CompanyDetails,InterviewRound,CompanyRegistration
from student.models import Student_details

class CompanyDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = CompanyDetails
        fields = '__all__'


# class InterviewRoundSerializer(serializers.ModelSerializer):
#     company_name = serializers.CharField(source='company.comapny_name', read_only=True)  # Get company name instead of ID

#     class Meta:
#         model = InterviewRound
#         fields = ['company_name', 'round_number', 'status']  # Exclude 'company' field, include 'company_name'



class InterviewRoundSerializer(serializers.Serializer):
    company_name = serializers.CharField()  # Input for company name
    round_number = serializers.IntegerField()  # Input for round number
    status = serializers.ChoiceField(choices=InterviewRound.ROUND_STATUS_CHOICES)  # Input for status

    def validate_company_name(self, value):
        """Validate if the company exists in the database."""
        if not CompanyDetails.objects.filter(company_name__iexact=value).exists():
            raise serializers.ValidationError(f"Company '{value}' does not exist.")
        return value

    def create(self, validated_data):
        """Create an InterviewRound entry using validated data."""
        company = CompanyDetails.objects.get(company_name__iexact=validated_data['company_name'])
        return InterviewRound.objects.create(
            company=company,
            round_number=validated_data['round_number'],
            status=validated_data['status']
        )

    def to_representation(self, instance):
        """Format the output as desired."""
        return {
            "company_name": instance.company.company_name,
            "round_number": instance.round_number,
            "status": instance.status,
        }

# class InterviewRoundSerializer(serializers.ModelSerializer):
#     company_name = serializers.CharField(write_only=True)  # Accept company name as input
#     round_number = serializers.IntegerField()  # Accept round number as input
#     status = serializers.ChoiceField(choices=InterviewRound.ROUND_STATUS_CHOICES)  # Accept status as input
    
#     # Fields to return in the response
#     output_company_name = serializers.CharField(source='company.company_name', read_only=True)  # Fetch company name for output

#     class Meta:
#         model = InterviewRound
#         fields = ['company_name', 'round_number', 'status', 'output_company_name']
#         extra_kwargs = {
#             'output_company_name': {'read_only': True}  # Company name is read-only in the response
#         }

#     def create(self, validated_data):
#         company_name = validated_data.pop('company_name')  # Get the company name from input
        
#         # Fetch the company based on the provided name
#         try:
#             company = CompanyDetails.objects.get(company_name=company_name)  # Ensure to use correct field name
#         except CompanyDetails.DoesNotExist:
#             raise serializers.ValidationError({"company_name": "Company with this name does not exist."})

#         # Create the InterviewRound instance
#         interview_round = InterviewRound.objects.create(company=company, **validated_data)
#         return interview_round

# class CompanyRegistrationSerializer(serializers.ModelSerializer):
#     student_name = serializers.CharField(source='student.first_name', read_only=True)  # Get student first name
#     student_id = serializers.CharField(source='student.id_no', read_only=True)  # Get student ID (id_no)
#     company_name = serializers.CharField(source='company.comapny_name', read_only=True)  # Get company name

#     class Meta:
#         model = CompanyRegistration
#         fields = ['student_name', 'student_id','company_name', 'registration_date']

class CompanyRegistrationSerializer(serializers.ModelSerializer):
    # Fields to display in the response
    student_name = serializers.CharField(source='student.first_name', read_only=True)  # Get student first name
    student_id = serializers.CharField(source='student.id_no', read_only=True)  # Get student ID (id_no)
    company_name = serializers.CharField(source='company.comapny_name', read_only=True)  # Get company name

    # Fields to accept from the request
    input_student_id = serializers.CharField(write_only=True)  # Accept student_id from request
    input_company_name = serializers.CharField(write_only=True)  # Accept company name from request

    class Meta:
        model = CompanyRegistration
        fields = ['student_name', 'student_id', 'company_name', 'registration_date', 'input_student_id', 'input_company_name']
        extra_kwargs = {
            'registration_date': {'read_only': True}  # Registration date should be automatically set
        }

    def create(self, validated_data):
        # Extract student_id and company_name from validated data
        student_id = validated_data.pop('input_student_id')
        company_name = validated_data.pop('input_company_name')

        # Fetch the student and company based on the provided values
        try:
            student = Student_details.objects.get(id_no=student_id)
        except Student_details.DoesNotExist:
            raise serializers.ValidationError({"student_id": "Student with this ID does not exist."})

        try:
            company = CompanyDetails.objects.get(comapny_name=company_name)
        except CompanyDetails.DoesNotExist:
            raise serializers.ValidationError({"company_name": "Company with this name does not exist."})

        # Create the CompanyRegistration instance
        registration = CompanyRegistration.objects.create(student=student, company=company, **validated_data)
        return registration
    
    def to_representation(self, instance):
        """Customize the output format."""
        representation = super().to_representation(instance)
        representation['company_name'] = instance.company.company_name  # Ensure company_name is included
        return representation