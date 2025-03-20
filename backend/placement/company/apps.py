from django.apps import AppConfig
from django.core.signals import request_started
from django.dispatch import receiver
import threading

# class CompanyConfig(AppConfig):
#     default_auto_field = 'django.db.models.BigAutoField'
#     name = 'company'

#     def ready(self):
#         # Import here to avoid circular imports
#         from .scheduled_tasks import start_deadline_checker
        
#         # Start the deadline checker immediately
#         print("Starting deadline checker...")
#         start_deadline_checker()
        
#         # Also keep the request_started signal for redundancy
#         @receiver(request_started)
#         def start_checker(sender, **kwargs):
#             start_deadline_checker()
#             request_started.disconnect(start_checker)


class CompanyConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'company'

    def ready(self):
        # Import here to avoid circular imports
        from .scheduled_tasks import start_deadline_checker
        
        # Start the deadline checker only after the first request
        @receiver(request_started)
        def start_checker(sender, **kwargs):
            # Start the checker in a separate thread
            thread = threading.Thread(target=start_deadline_checker, daemon=True)
            thread.start()
            # Disconnect the signal after first request to avoid multiple threads
            request_started.disconnect(start_checker)
