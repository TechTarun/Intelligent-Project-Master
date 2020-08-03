import 'package:flutter/material.dart';
import "package:speech_recognition/speech_recognition.dart";
import 'package:permission/permission.dart';
import 'package:http/http.dart' as http;

class Jira extends StatefulWidget {
  @override
  _JiraState createState() => _JiraState();
}

class _JiraState extends State<Jira> {
String getPermission = '';
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  var txt = new TextEditingController();

  @override
initState() {
    super.initState();
    initSpeechRecognition();
    requestPermission();
}
void initSpeechRecognition() {
  _speechRecognition =SpeechRecognition();

  _speechRecognition.setAvailabilityHandler(
   (bool result) =>setState(() => _isAvailable =result),
  );

  _speechRecognition.setRecognitionStartedHandler(
    () => setState(() => _isListening = true),
  );

  _speechRecognition.setRecognitionResultHandler(
    (String speech) =>setState(() => resultText = speech),
  );

  _speechRecognition.setRecognitionCompleteHandler(
    () =>setState(() => _isListening =false),
  );

  _speechRecognition.activate().then(
    (result) =>setState(() => _isAvailable = result),
  );
}
  String url = 'https://api.github.com/users/TechTarun/repos';

  // Future<Post> 
   void getPost() async{
   http.Response response = await http.get('$url');
  print(response.body);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
         title: Text('IPM',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),),
        elevation: 10.0,
        toolbarHeight: 80.0,
        backgroundColor: Color(0xff3F51B5),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
             begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            colors: [ Color(0xff0066ff),Color(0xff000000)],
          )
        ),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 0.0),
                child: Image.asset(
                  'assets/jira.jpg',
                  height: 300, width: 300,
                  colorBlendMode: BlendMode.darken,
                   fit: BoxFit.fitWidth
                )
              ),
          Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0),
            child: Column( children: <Widget>[
             TextField( 
                controller: txt,
                  decoration: InputDecoration(
                 prefixIcon: Icon(Icons.search),
                 hintText: 'Enter your problem',
                 suffixIcon: IconButton(
                  onPressed: (){
                if(_isAvailable && !_isListening)
              _speechRecognition
              .listen(locale: 'en_US')
              .then((result) => print('$result'));
                  },
                    icon: Icon(
                   Icons.mic,
                   color: Colors.blue,
                      ),
                      ),
                      filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(30.0)
                    ),
                focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
                ],),
          ),),
          SizedBox(height: 50,),
           Container(
                 height: 50.0,
                child: Material(
                  borderRadius: BorderRadius.circular(50.0),
                  shadowColor: Colors.blueAccent.shade200,
                  elevation: 10.0,
              child: MaterialButton(
                minWidth: 200.0, height: 42.0,
                onPressed: () {
                  txt.text= '$resultText';
                  getPost();
                },
                shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
                ),
                color: Colors.lightBlue,
                child: Text('Continue', style: TextStyle(color: Colors.white, fontSize: 20,),),
              ),
                ),  
              ),
          ],
        ),
      ) 
    );
  }
  requestPermission() async {
    final res = await Permission.requestSinglePermission(PermissionName.Microphone);
    print(res);
  }
}