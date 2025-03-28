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
    


# from rest_framework import serializers
# from user.models import FCMToken

# class FacultyFCMTokenSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = FCMToken
#         fields = ['id', 'id_no', 'token', 'created_at']

# class StudentFCMTokenSerializer(serializers.ModelSerializer):


#     class Meta:
#         model = FCMToken
#         fields = ['id', 'id_no', 'token', 'created_at']
