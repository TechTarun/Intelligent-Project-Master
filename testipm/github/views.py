from django.shortcuts import render

# Create your views here.
def github(request):
    return render(request, 'github/github.html')