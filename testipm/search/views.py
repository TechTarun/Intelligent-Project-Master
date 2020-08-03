from django.shortcuts import render
from InputOutputFiles import Speech_to_Text as listen
from InputOutputFiles import Text_to_Speech as speak
import base

def index(request):
    return render(request, 'search/search.html', {'query':"", 'output':""})

def listenSearchQuery(request):
    speak.say("Speak your query")
    query = listen.listenInput()
    output = base.getAPIOutput(query, "Search")
    speak.say(output)
    if output == "Project doesnt exist":
        to_do = 0
        in_progress = 0
        done = 0
    else:
        to_do = base.getToDoIssueNum()
        in_progress = base.getInProgressIssueNum()
        done = base.getDoneIssueNum()
    return render(request, 'search/search.html', {'query' : query, 'output':output, 'to_do':to_do, 'in_progress':in_progress, 'done':done})

