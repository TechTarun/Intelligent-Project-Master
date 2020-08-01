from django.shortcuts import render

# Create your views here.
def jira(request):
    return render(request, 'jira/jira.html')
