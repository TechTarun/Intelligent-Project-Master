from django.shortcuts import render
from InputOutputFiles import Speech_to_Text as listen

def Bitbucket(request):
    return render(request, 'Bitbucket/Bitbucket.html')

def listenBitbucketQuery(request):
    query = listen.listenInput()
    return render(request, 'Bitbucket/Bitbucket.html', {'query':query})
