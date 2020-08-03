from gtts import gTTS
import os
from playsound import playsound
# import pyttsx3

def say(text):
    myobj = gTTS(text, lang='en', slow=False)
    myobj.save('voice.mp3')
    playsound('voice.mp3')
    os.remove('voice.mp3')

    # engine = pyttsx3.init('sapi5') 
    # engine.say(text) 
    # engine.runAndWait()

# say("Create a new project tarunipm in jira")