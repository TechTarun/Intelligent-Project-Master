from django.shortcuts import render
from InputOutputFiles import Speech_to_Text as listen
from InputOutputFiles import Text_to_Speech as speak
import base

def Github(request):
    return render(request, 'Github/githubNew.html', {'query':"", 'output':""})

def listenGithubQuery(request):
    speak.say("Speak your query")
    query = listen.listenInput()
    return render(request, 'Github/githubNew.html', {'query' : query, 'output':""})

def searchGithubQuery(request):
    query = request.POST.get('query')
    output = base.getAPIOutput(query, "Github")
    speak.say(output)
    return render(request, 'Github/githubNew.html', {'query':query, 'output':output})