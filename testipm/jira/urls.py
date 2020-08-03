from django.urls import path
from . import views

urlpatterns = [

    ### API URLs ###
    # path('api/search_jira', views.api_searchJiraQuery, name='api_jira_search'),
    ### API URLs end ####

    path('', views.Jira, name="jira"),
    # path('args', views.getArgsJiraQuery, name='jira_args'),
    path('listen', views.listenJiraQuery, name='jira_listen'),
    path('search', views.searchJiraQuery, name='jira_search')
]