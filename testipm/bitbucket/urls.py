from django.urls import path
from . import views

urlpatterns = [
    path('', views.Bitbucket, name="Bitbucket"),
    path('listen', views.listenBitbucketQuery, name='bitbucket_listen'),
    ]