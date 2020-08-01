from django.urls import path
from . import views

urlpatterns = [
    path('', views.profill, name="profill"),
]