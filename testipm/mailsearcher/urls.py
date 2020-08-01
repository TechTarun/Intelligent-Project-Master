from django.urls import path
from . import views

urlpatterns = [

    path('', views.Mailsearcher, name="mailsearcher"),
]