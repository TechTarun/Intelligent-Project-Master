from django.shortcuts import render

# Create your views here.
def index(request):
    message = ""
    return render(request, 'index/index.html', {'message' : message})