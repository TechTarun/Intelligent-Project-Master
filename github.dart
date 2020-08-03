import 'package:flutter/material.dart';
import "package:speech_recognition/speech_recognition.dart";
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission/permission.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//import 'dart:async';
// class GitHub extends StatelessWidget {
//   String url;
//   String title;
//   GitHub({@required this.url, @required this.title});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:Center(
//        child: WebviewScaffold(
//          url: url,
//          appBar: AppBar(title: Text(title),),
//          withZoom: true,
//          withLocalStorage: false,
//          ),)

//     );
//   }
// }

class GitHub extends StatefulWidget {
  @override
  _GitHubState createState() => _GitHubState();
}

class _GitHubState extends State<GitHub> {
  final FlutterTts flutterTts = FlutterTts();
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
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }
  // String url = 'https://api.github.com/users/TechTarun/repos';

  // // Future<Post>
  //  void getPost() async{
  //  http.Response response = await http.get('$url');
  // print(response.body);
  //  }

  //for print the json response
  var isLoading = -1;
  var parsedJson;
  fetchData() async {
    setState(() {
      isLoading = 1;
    });
    final response = await http.get(
        "https://jsonplaceholder.typicode.com/photos"); // this will be changed according to API
    if (response.statusCode == 200) {
      parsedJson = json.decode(response.body);
      print(parsedJson);
      setState(() {
        isLoading = 0;
      });
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future speak(String text) async {
    await flutterTts.setLanguage("en_US");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

// haan jii toh ab dekho tumhare pass jsonData ek dictionary hai data["response"] = "nfdjfdjfdfdjf"
  //var jData = '{"response" : "this is output"}'; // haan jii toh ab yeh kyunki json hai toh ab naa use decode krenge phle
  //var parsedJson = json.decode(jData); //jaisa hum yha kiya hai
  // and ab yeh ban gyi simple dart hash toh ab kya hi krna hai
  //allData = parsedJson["response"] ise print krwana hai screen pr butto okji

//response = '{"response":"fddfdfdfdfd"}'
  
  Widget getColumn(int isLoading) {
    if (isLoading == -1) {
      return Center();
    } else if (isLoading == 1) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (isLoading == 0) {
      speak(parsedJson[1]["title"]);
      isLoading = -1;
      return Text(
        parsedJson[1]["title"],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          fontSize: 15.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            'IPM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 10.0,
          toolbarHeight: 80.0,
          backgroundColor: Color(0xff3F51B5),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            //stops: [0.4, 0.1],
            colors: [Colors.grey, Colors.blue],
            // colors: [ Color(0xffCCCCCC), Color(0xff666666), Color(0xff000000)],
          )),
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(60.0, 30.0, 60.0, 0.0),
                  child: Image.asset('assets/github.jpg',
                      height: 230,
                      width: 300,
                      colorBlendMode: BlendMode.clear,
                      fit: BoxFit.fitWidth)),
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: txt,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Enter your problem',
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (_isAvailable && !_isListening)
                                _speechRecognition
                                    .listen(locale: 'en_US')
                                    .then((result) => print('$result'));
                              //fetchData();
                            },
                            icon: Icon(
                              Icons.mic,
                              color: Colors.blue,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 50.0,
                child: Material(
                  borderRadius: BorderRadius.circular(50.0),
                  shadowColor: Colors.blueAccent.shade200,
                  elevation: 10.0,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    onPressed: () {
                      print(resultText);
                      txt.text = '$resultText';
                      // getPost();
                      fetchData();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    color: Colors.lightBlue,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getColumn(isLoading),
                    // isLoading
                    // ? Center( child: CircularProgressIndicator(),)
                    // : UI(),
                  ]),
            ],
          ),
        ));
  }

  requestPermission() async {
    final res =
        await Permission.requestSinglePermission(PermissionName.Microphone);
    print(res);
  }
}

//String l = [getData()]
