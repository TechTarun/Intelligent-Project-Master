from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('index.urls'), name="index"),
    path('profile/',include('profill.urls'),name="profile"),
    path('github/',include('Github.urls'),name="github"),
    path('Github/', include('Github.urls'),name="Github"),
    path('confluence/',include('Confluence.urls'),name="confluence"),
    path('Confluence/',include('Confluence.urls'),name="Confluence"),
    path('Bitbucket/',include('Bitbucket.urls'),name="Bitbucket"),
    path('bitbucket/',include('Bitbucket.urls'),name="bitbucket"),
    path ('Jira/',include('Jira.urls'),name="jira"),
    path('jira/',include('Jira.urls'),name="jira"),
    path('search/',include('search.urls'),name="search"),
    path('Search/',include('search.urls'),name="search"),
    path ('mailsearcher/',include('mailsearcher.urls'),name="mailsearcher"),

]