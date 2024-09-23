

# views.py
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializers import AnnouncementSerializer
from .models import public_announcement


class AnnouncementView(APIView):
    def get(self, request):
        company_details = public_announcement.objects.all()
        serializer = AnnouncementSerializer(company_details, many=True, context={'request': request})
        return Response(serializer.data)

class AnnouncementPost(APIView):   
    def post(self, request):
        serializer = AnnouncementSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class Announcementedit(APIView):

    def get_object(self, pk):
        try:
            return public_announcement.objects.get(pk=pk)
        except public_announcement.DoesNotExist:
            return None
        
    def patch(self, request, pk):
        company_details = self.get_object(pk)
        if company_details is None:
            return Response({"error": "Annonucement not found"}, status=status.HTTP_404_NOT_FOUND)
        serializer = AnnouncementSerializer(company_details, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        try:
            company_details = public_announcement.objects.get(pk=pk)
        except public_announcement.DoesNotExist:
            return Response({"error": "Annonucement not found"}, status=status.HTTP_404_NOT_FOUND)
        serializer = AnnouncementSerializer(company_details, context={'request': request},partial=True)
        serializer.delete(company_details)
        return Response({"message": "Announcement delete successfully"})
    
