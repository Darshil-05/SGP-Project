from rest_framework import serializers
from .models import CompanyDetails,InterviewRound,CompanyRegistration,CompanyApplications
from student.models import Student_details


    


# class InterviewRoundSerializer(serializers.ModelSerializer):
#     company_name = serializers.CharField(source='company.comapny_name', read_only=True)  # Get company name instead of ID

#     class Meta:
#         model = InterviewRound
#         fields = ['company_name', 'round_number', 'status']  # Exclude 'company' field, include 'company_name'



from rest_framework import serializers
from .models import CompanyDetails, InterviewRound

class InterviewRoundSerializer(serializers.ModelSerializer):
    # company_name = serializers.CharField(source='company.company_name', read_only=True)  # Read-only for display
    # company = serializers.PrimaryKeyRelatedField(queryset=CompanyDetails.objects.all())  # Select company by ID
    company_id = serializers.IntegerField(source='company.id', read_only=True)


    class Meta:
        model = InterviewRound
        fields = ['round_name', 'status', 'index', 'company_id']
        read_only_fields = ['index', 'company_id']

class CompanyDetailsSerializer(serializers.ModelSerializer):
    interview_rounds = InterviewRoundSerializer(many=True, required=False)

    class Meta:
        model = CompanyDetails
        fields = '__all__'  # Includes interview_rounds

    def create(self, validated_data):
        # Extract interview rounds data
        interview_rounds_data = validated_data.pop('interview_rounds', [])

        # Create company
        company = CompanyDetails.objects.create(**validated_data)

        # Create interview rounds
        for round_data in interview_rounds_data:
            InterviewRound.objects.create(company=company, **round_data)

        return company

    def update(self, instance, validated_data):
    # Extract interview rounds data
     interview_rounds_data = validated_data.pop('interview_rounds', [])

    # Update company details dynamically
     for attr, value in validated_data.items():
        setattr(instance, attr, value)  # Set each field dynamically

     instance.save()

    # Handle interview rounds
     if interview_rounds_data:
        instance.interview_rounds.all().delete()  # Remove old rounds if updating all
        for round_data in interview_rounds_data:
            InterviewRound.objects.create(company=instance, **round_data)

     return instance


class CompanyRegistrationSerializer(serializers.ModelSerializer):
    # Fields to display in the response
    student_name = serializers.CharField(source='student.first_name', read_only=True)  # Get student first name
    student_id = serializers.CharField(source='student.id_no', read_only=True)  # Get student ID (id_no)
    company_name = serializers.CharField(source='company.company_name', read_only=True)  # Get company name

    # Fields to accept from the request
    input_student_id = serializers.CharField(write_only=True)  # Accept student_id from request
    input_company_id = serializers.CharField(write_only=True)  # Accept company name from request

    class Meta:
        model = CompanyRegistration
        fields = ['student_name', 'student_id', 'company_name', 'registration_date', 'input_student_id', 'input_company_id']
        extra_kwargs = {
            'registration_date': {'read_only': True}  # Registration date should be automatically set
        }

    def create(self, validated_data):
        # Extract student_id and company_name from validated data
        student_id = validated_data.pop('input_student_id')
        company_id = validated_data.pop('input_company_id')

        # Fetch the student and company based on the provided values
        try:
            student = Student_details.objects.get(id_no=student_id)
        except Student_details.DoesNotExist:
            raise serializers.ValidationError({"student_id": "Student with this ID does not exist."})

        try:
            company = CompanyDetails.objects.get(company_id=company_id)
        except CompanyDetails.DoesNotExist:
            raise serializers.ValidationError({"company_id": "Company with this name does not exist."})

        # Create the CompanyRegistration instance
        registration = CompanyRegistration.objects.create(student=student, company=company, **validated_data)
        return registration
    
    def to_representation(self, instance):
        """Customize the output format."""
        representation = super().to_representation(instance)
        representation['company_name'] = instance.company.company_name  # Ensure company_name is included
        return representation


# from rest_framework import serializers
# from .models import StudentInterviewProgress, InterviewRound

# class StudentProgressSerializer(serializers.ModelSerializer):
#     student_name = serializers.CharField(source="student.name", read_only=True)
#     company_name = serializers.CharField(source="company.company_name", read_only=True)
#     round_name = serializers.CharField(source="round.round_name", read_only=True)

#     class Meta:
#         model = StudentInterviewProgress
#         fields = ['id', 'student', 'student_name', 'company', 'company_name', 'round', 'round_name', 'is_passed', 'is_present']

        




from rest_framework import serializers
from .models import CompanyDetails
from django.conf import settings


class CompanyInfoSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()
    class Meta:
        model = CompanyDetails
        fields = ['company_name', 'date_placementdrive', 'job_location', 'job_description', 'image_url']

    def get_image_url(self, obj):
        # Check if the image exists and access the related image object
        if obj.image:
            return f"{settings.MEDIA_URL}{obj.image.image.url.lstrip('/')}"
        return None

    
class ApplyForCompanySerializer(serializers.Serializer):
    student_id = serializers.CharField()  # Changed to CharField to match `student_unique_id`
    company_id = serializers.IntegerField()

    def validate(self, data):
        student_id = data.get('student_id')
        company_id = data.get('company_id')

        # Validate student existence
        try:
            data['student'] = Student_details.objects.get(id_no=student_id)  # Use `id_no` to find the student
        except Student_details.DoesNotExist:
            raise serializers.ValidationError({"student_id": "Student not found."})

        # Validate company existence
        try:
            data['company'] = CompanyDetails.objects.get(company_id=company_id)
        except CompanyDetails.DoesNotExist:
            raise serializers.ValidationError({"company_id": "Company not found."})

        # Check if student already applied
        if CompanyApplications.objects.filter(student=data['student'], company=data['company']).exists():
            raise serializers.ValidationError("Student has already applied to this company.")

        return data
