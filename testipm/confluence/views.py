from django.shortcuts import render
from InputOutputFiles import Speech_to_Text as listen

def Confluence(request):
    return render(request, 'Confluence/Confluence.html')

def listenConfluenceQuery(request):
    speak.say("Speak your query")
    query = listen.listenInput()
    return render(request, 'Confluence/Confluence.html', {'query' : query, 'output':""})

def searchConfluenceQuery(request):
    query = request.POST.get('query')
    output = base.getAPIOutput(query, "Confluence")
    speak.say(output)
    return render(request, 'Confluence/Confluence.html', {'query':query, 'output':output})