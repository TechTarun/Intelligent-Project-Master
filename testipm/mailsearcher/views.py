from django.shortcuts import render
from InputOutputFiles import Speech_to_Text as listen
from InputOutputFiles import Text_to_Speech as speak
import base

def Mailsearcher(request):
    query=""
    output = ""
    return render(request, 'mailsearcher/mailsearcher.html', {'query':query, 'output':output})

def listenMailQuery(request):
    speak.say("Speak your query")
    query = listen.listenInput()
    return render(request, 'mailsearcher/mailsearcher.html', {'query':query, 'output':""})

def searchMailQuery(request):
    speak.say("searching the query")
    query = request.POST.get('query')
    output, attach_list = base.getMailOutput(query)
    print(output)
    if output == "No mails!!":
        speak.say(output)
    else:
        speak.say("Mail found!!")
    return render(request, 'mailsearcher/mailsearcher.html', {'query':query, 'output':output})



