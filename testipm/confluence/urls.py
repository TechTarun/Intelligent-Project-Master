from django.urls import path
from . import views

urlpatterns = [
    path('', views.Confluence, name="Confluence"),
    path('listen', views.listenConfluenceQuery, name="confluence_listen"),
    path('search', views.searchConfluenceQuery, name='search_confluence')
]