from django.shortcuts import render
from InputOutputFiles import Speech_to_Text as listen
from InputOutputFiles import Text_to_Speech as speak
import base
from rest_framework.decorators import api_view

def Jira(request):
    return render(request, 'Jira/jiraNew.html', {'query':"", 'output':""})

# def getArgsJiraQuery(request):
#     query = request.POST.get('query');
#     args = ["project name", "lead name"]
#     return render(request, 'Jira/jira3.html', {'query':query, 'args':args, 'output':""})

def listenJiraQuery(request):
    speak.say("Speak your query")
    query = listen.listenInput()
    return render(request, 'Jira/jiraNew.html', {'query':query, 'output':""})

def searchJiraQuery(request):
    query = request.POST.get('query')
    # params = request.POST.get('params')
    # query = params['query']
    output = base.getAPIOutput(query, "Jira")
    speak.say(output)
    return render(request, 'Jira/jiraNew.html', {'query':query, 'output':output})

# @api_view(['POST'])
# def api_searchJiraQuery(request):
#     data = {}
#     if request.method == 'POST':
#         query = request.data['query']
#         output = base.getAPIOutput(query, "Jira")
#         speak.say(output)
#         data["Response"] = output
#     else:
#         data["Response"] = "POST method is needed"
#     return Response(data)




