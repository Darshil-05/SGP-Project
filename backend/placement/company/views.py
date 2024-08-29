
# Create your views here.
from rest_framework import viewsets
from .models import CompanyDetails
from .serializers import CompanyDetailsSerializer

# views.py
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializers import CompanyDetailsSerializer
from .models import CompanyDetails


class CompanyDetailsView(APIView):
    def get(self, request):
        company_details = CompanyDetails.objects.all()
        serializer = CompanyDetailsSerializer(company_details, many=True, context={'request': request})
        return Response(serializer.data)

class CompanyDetailsPost(APIView):   
      def post(self, request):
        serializer = CompanyDetailsSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CompanyDetailsedit(APIView):

    def get_object(self, pk):
        try:
            return CompanyDetails.objects.get(pk=pk)
        except CompanyDetails.DoesNotExist:
            return None
        
    def patch(self, request, pk):
        company_details = self.get_object(pk)
        if company_details is None:
            return Response({"error": "Company details not found"}, status=status.HTTP_404_NOT_FOUND)
        serializer = CompanyDetailsSerializer(company_details, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        try:
            company_details = CompanyDetails.objects.get(pk=pk)
        except CompanyDetails.DoesNotExist:
            return Response({"error": "Company details not found"}, status=status.HTTP_404_NOT_FOUND)
        serializer = CompanyDetailsSerializer(company_details, context={'request': request},partial=True)
        serializer.delete(company_details)
        return Response({"message": "Company details deleted successfully"})
    

# class CompanyPlacementDriveViewSet(viewsets.ModelViewSet):
#     queryset = CompanyPlacementDrive.objects.all()
#     serializer_class = CompanyPlacementDriveSerializer

