from django.contrib import admin
from django.urls import path,include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('index.urls'), name="index"),
    path('profile/',include('profill.urls'),name="profile"),
    path('github/',include('github.urls'),name="github"),
    path('Github/', include('github.urls'),name="Github"),
    path('confluence/',include('confluence.urls'),name="confluence"),
    path('Confluence/',include('confluence.urls'),name="Confluence"),
    path('Bitbucket/',include('bitbucket.urls'),name="Bitbucket"),
    path('bitbucket/',include('bitbucket.urls'),name="bitbucket"),
    path ('Jira/',include('jira.urls'),name="jira"),
    path('jira/',include('jira.urls'),name="jira"),
    path ('mailsearcher/',include('mailsearcher.urls'),name="mailsearcher"),

]
