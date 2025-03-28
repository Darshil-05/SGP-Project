from .models import FCMToken
from student.models import Student_details
from faculty.models import Faculty_details

def store_or_update_fcm_token(email, token, user_type):
    try:
        # Get id_no based on user type and email
        if user_type == 'student':
            student = Student_details.objects.get(student_email_id=email)
            id_no = student.id_no
        elif user_type == 'faculty':
            faculty = Faculty_details.objects.get(faculty_email_id=email)
            id_no = faculty.faculty_id
        else:
            return False, "Invalid user type"

        # Update or create FCM token
        FCMToken.objects.update_or_create(
            fcm_id_no=id_no,
            defaults={
                'token': token,
                'user_type': user_type
            }
        )
        return True, "FCM token stored successfully"
    except (Student_details.DoesNotExist, Faculty_details.DoesNotExist):
        return False, f"{user_type.capitalize()} details not found"
    except Exception as e:
        return False, str(e)

def delete_fcm_token(email, user_type):
    try:
        # Get id_no based on user type and email
        if user_type == 'student':
            student = Student_details.objects.get(student_email_id=email)
            id_no = student.id_no
        elif user_type == 'faculty':
            faculty = Faculty_details.objects.get(faculty_email_id=email)
            id_no = faculty.faculty_id
        else:
            return False, "Invalid user type"

        # Delete FCM token
        FCMToken.objects.filter(fcm_id_no=id_no).delete()
        return True, "FCM token deleted successfully"
    except (Student_details.DoesNotExist, Faculty_details.DoesNotExist):
        return False, f"{user_type.capitalize()} details not found"
    except Exception as e:
        return False, str(e) 