from django.shortcuts import render

# Create your views here.
def Mailsearcher(request):
    return render(request, 'mailsearcher/mailsearcher.html')