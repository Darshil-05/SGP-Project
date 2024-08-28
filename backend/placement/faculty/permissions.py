from rest_framework.permissions import BasePermission

class IsFaculty(BasePermission):
    def has_permission(self, request, view):
        return request.user and hasattr(request.user, 'is_faculty') and request.user.is_faculty