from django.shortcuts import render

# Create your views here.
def confluence(request):
    return render(request, 'confluence/confluence.html')