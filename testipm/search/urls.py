from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='homepageindex'),
    path('listen', views.listenSearchQuery, name='listen'),
    # path('search', views.searchSearchQuery, name='search')
]