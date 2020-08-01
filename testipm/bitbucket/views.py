from django.shortcuts import render

def bitbucket(request):
    return render(request, 'bitbucket/bitbucket.html')
