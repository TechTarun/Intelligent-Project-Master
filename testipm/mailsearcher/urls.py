from django.urls import path
from . import views

urlpatterns = [

    path('', views.Mailsearcher, name="mailsearcher"),
    path('listen', views.listenMailQuery, name='listen_mail'),
    path('search', views.searchMailQuery, name='search_mail')
]