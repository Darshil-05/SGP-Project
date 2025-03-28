
# Create your views here.
# Create your views here.
from rest_framework import viewsets
from rest_framework import generics
from rest_framework.permissions import IsAuthenticated
from .models import Faculty_details
from .serializers import FacultyDetailsSerializer
from user.utils import store_or_update_fcm_token
from rest_framework import generics, status
from rest_framework.response import Response

class FacultyDetailsListCreateView(generics.ListCreateAPIView):
    queryset = Faculty_details.objects.all()
    serializer_class = FacultyDetailsSerializer
  

    def create(self, request, *args, **kwargs):
        try:
            # First save faculty details using the existing serializer
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)

            # After successfully storing faculty details, handle FCM token
            fcm_token = request.data.get('fcm_token')
            if fcm_token:
                success, message = store_or_update_fcm_token(
                    email=serializer.data['faculty_email_id'],
                    token=fcm_token,
                    user_type='faculty'
                )
                if not success:
                    return Response({
                        'status': 'warning',
                        'data': serializer.data,
                        'message': 'Faculty details saved but FCM token storage failed',
                        'fcm_error': message
                    }, status=status.HTTP_200_OK)

            return Response({
                'status': 'success',
                'data': serializer.data,
                'message': 'Faculty details saved successfully'
            }, status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)

    
class FacultyDetailsRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Faculty_details.objects.all()
    serializer_class = FacultyDetailsSerializer
    permission_classes = [IsAuthenticated]
    lookup_field = 'faculty_id'





