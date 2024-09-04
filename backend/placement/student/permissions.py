from rest_framework.permissions import BasePermission

class IsStudent(BasePermission):
    def has_permission(self, request, view):
        return request.user and hasattr(request.user, 'is_student') and request.user.is_student