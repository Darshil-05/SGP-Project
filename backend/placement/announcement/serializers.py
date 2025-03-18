
# # serializers.py
# from rest_framework import serializers
# from .models import public_announcement


# class AnnouncementSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = public_announcement
#         fields = '__all__'
from rest_framework import serializers
from .models import PublicAnnouncement


class AnnouncementSerializer(serializers.ModelSerializer):
    is_expired = serializers.SerializerMethodField()

    class Meta:
        model = PublicAnnouncement
        fields = '__all__'

    def get_is_expired(self, obj):
        return obj.is_expired()
    


from rest_framework import serializers
from .models import FacultyFCMToken, StudentFCMToken

class FacultyFCMTokenSerializer(serializers.ModelSerializer):
    class Meta:
        model = FacultyFCMToken
        fields = ['id', 'faculty', 'token', 'created_at']

class StudentFCMTokenSerializer(serializers.ModelSerializer):


    class Meta:
        model = StudentFCMToken
        fields = ['id', 'student_idno', 'token', 'created_at']
