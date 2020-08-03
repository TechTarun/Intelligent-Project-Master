import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:sih/meeting.dart';
import "package:speech_recognition/speech_recognition.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:date_format/date_format.dart';
import 'package:permission/permission.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ShowDataPage extends StatefulWidget {
  @override
  _ShowDataPageState createState() => _ShowDataPageState();
}

class _ShowDataPageState extends State<ShowDataPage> {
  String allData = "";
  String getPermission = '';
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  final FlutterTts flutterTts = FlutterTts();
  String resultText = "";

  processQuery() {
    // speak('How can I help you?');
    _isListening = false;
    print("resultText is => " + resultText);
    RegExp timeasked = new RegExp(
      r'\d{1,2} [a-z]{3,9} \d{4}',
    );
    //new DateFormat("dd mm yyyy", "en_US").parse(resultText).toString();
    // date = datetime.datetime.strptime(timeasked.group(), '%Y-%m-%d').date();
    String date = timeasked.stringMatch(resultText.toLowerCase());
    print(date);
    fetchData(date);
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
      () => setState(processQuery()),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  @override
  void initState() {
    super.initState();
    initSpeechRecognition();
    requestPermission();
  }

  void fetchData(String date) {
    //allData == [];
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.once().then((DataSnapshot snap) {
      var data = snap.value;
      var items = data['items'];
      var keys = items.keys;
      allData = "";
      for (var key in keys) {
        if (items[key]['timetaken'] == date) {
          allData += items[key]['keyphrase'];
        }
        // myData d = new myData(
        //   data[key]['description'],
        //   data[key]['keyphrase'],
        //   data[key]['timestamp'],
        // );
        // print(data[key]['timestamp']);
        // if (data[key]['timestamp'] == date)
        // print(data[key]['keyphrase']);
        //allData.add(d);
      }
      print(allData);
     // speak("Key Phrases of the discussion made on $date are");
      speak("Key Phrases of the discussion made on $date are $allData ");
    });
  }

  //speak
  Future speak(String text) async {
    await flutterTts.setLanguage("en_US");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  List<Text> UI() {
return allData.split(",").map((text) => Text(text, style: TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold),)).toList();

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff42A5F5),
      appBar: AppBar(
        title: Text(
          'Meeting details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 10.0,
        toolbarHeight: 80.0,
        backgroundColor:Color(0xff3F51B5),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  minWidth: 300.0,
                  height: 200.0,
                  onPressed: () {
                    if (_isAvailable && !_isListening)
                      _speechRecognition
                          .listen(locale: 'en_US')
                          .then((result) => print('$result'));
                    _speechRecognition.stop();
                  },
                  elevation: 88,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  color: Color(0xff3F51B5),
                  child: Icon(Icons.question_answer,
                      color: Colors.white, size:100),
                ),
              ]),
          SizedBox(height: 30,),
           
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: UI(),
          ),
          // Container(
          //   /*  child: allData.length == 0
          //       ? new Text('${allData}')
          //       : new ListView.builder(
          //           itemCount: allData.length,
          //           itemBuilder: (_, index) {
          //             // return UI(
          //             //   allData[index],
          //             // );
          //           },
          //         )*/
          //         child: new Text("${allData}"),
          //         ),
        ],
      ),
    );
  }

  requestPermission() async {
    final res =
        await Permission.requestSinglePermission(PermissionName.Microphone);
    print(res);
  }
}
