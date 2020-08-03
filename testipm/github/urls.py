from django.urls import path
from . import views

urlpatterns = [
    path('', views.Github, name="Github"),
    path('listen', views.listenGithubQuery, name='listen_github'),
    path('search', views.searchGithubQuery, name='search_github')
]