import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import "package:speech_recognition/speech_recognition.dart";
import 'package:firebase_database/firebase_database.dart';
//import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:permission/permission.dart';
// import 'package:sih/mydata.dart';

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;

  String getPermission = '';
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";
  @override
  initState() {
    super.initState();
    initSpeechRecognition();
    requestPermission();

    item = Item("", "", "");
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('items');
    itemRef.onChildAdded.listen(_onEntryAdded);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
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

  void createRecord(String resultText) {
    List<String> StopWords = [
      'i',
      'me',
      'my',
      'myself',
      'we',
      'our',
      'ours',
      'ourselves',
      'you',
      "you're",
      "you've",
      "you'll",
      "you'd",
      'your',
      'yours',
      'yourself',
      'yourselves',
      'he',
      'him',
      'his',
      'himself',
      'she',
      "she's",
      'her',
      'hers',
      'herself',
      'it',
      "it's",
      'its',
      'itself',
      'they',
      'them',
      'their',
      'theirs',
      'themselves',
      'what',
      'which',
      'who',
      'whom',
      'this',
      'that',
      "that'll",
      'these',
      'those',
      'am',
      'is',
      'are',
      'was',
      'were',
      'be',
      'been',
      'being',
      'have',
      'has',
      'had',
      'having',
      'do',
      'does',
      'did',
      'doing',
      'a',
      'an',
      'the',
      'and',
      'but',
      'if',
      'or',
      'because',
      'as',
      'until',
      'while',
      'of',
      'at',
      'by',
      'for',
      'with',
      'about',
      'against',
      'between',
      'into',
      'through',
      'during',
      'before',
      'after',
      'above',
      'below',
      'to',
      'from',
      'up',
      'down',
      'in',
      'out',
      'on',
      'off',
      'over',
      'under',
      'again',
      'further',
      'then',
      'once',
      'here',
      'there',
      'when',
      'where',
      'why',
      'how',
      'all',
      'any',
      'both',
      'each',
      'few',
      'more',
      'most',
      'other',
      'some',
      'such',
      'no',
      'nor',
      'not',
      'only',
      'own',
      'same',
      'so',
      'than',
      'too',
      'very',
      's',
      't',
      'can',
      'will',
      'just',
      'don',
      "don't",
      'should',
      "should've",
      'now',
      'd',
      'll',
      'm',
      'o',
      're',
      've',
      'y',
      'ain',
      'aren',
      "aren't",
      'couldn',
      "couldn't",
      'didn',
      "didn't",
      'doesn',
      "doesn't",
      'hadn',
      "hadn't",
      'hasn',
      "hasn't",
      'haven',
      "haven't",
      'isn',
      "isn't",
      'ma',
      'mightn',
      "mightn't",
      'mustn',
      "mustn't",
      'needn',
      "needn't",
      'shan',
      "shan't",
      'shouldn',
      "shouldn't",
      'wasn',
      "wasn't",
      'weren',
      "weren't",
      'won',
      "won't",
      'wouldn',
      "wouldn't"
    ];
    RegExp stopWords = RegExp(
        StopWords.map((w) => r'\b' + w + r'(?![\w-])').join('|'),
        caseSensitive: false);
    int minChars = 0;
    minChars = minChars ?? 0;
    List<String> keyphrase = [];
    keyphrase.addAll(resultText
        .trim()
        .split(stopWords)
        .map((p) => p.trim().toLowerCase().replaceAll('\n', ''))
        .where((p) => p != '' && p.length >= minChars));
    var now = new DateTime.now();
    String Keyphrase = "";
    for (final phrase in keyphrase) {
      Keyphrase += phrase;
      Keyphrase += ' , ';
    }
    List<String> monthName = [
      "january",
      "february",
      "march",
      "april",
      "may",
      "june",
      "july",
      "august",
      "september",
      "october",
      "november",
      "december"
    ];
    String month = monthName[now.month - 1];
    var timetaken = formatDate(now, [dd, ' ', month, ' ', yyyy]);
    // var timetaken=formatDate(now, [dd, '-', mm, '-', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    itemRef.push().set(item.toJson(resultText, Keyphrase, timetaken));
  }
//  final FlutterTts flutterTts =FlutterTts();
//   //speak
//  Future speak() async{
//    await flutterTts.setLanguage("en_US");
//    await flutterTts.setPitch(1);
//    await flutterTts.speak('Hello how can i help you?');
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MEETING',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff30cfd0), Color(0xff330867)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      //shape: BoxShape.circle,
                      image: DecorationImage(
                          image: new AssetImage("assets/mom.gif"),
                          fit: BoxFit.fill),
                    ),
                  ),
              SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  onPressed: () {
                    if (_isAvailable && !_isListening)
                      _speechRecognition
                          .listen(locale: 'en_US')
                          .then((result) => print('$result'));
                  },
                  backgroundColor: Colors.pink,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
                child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '$resultText',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            )),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              child: Text('Create Record', style: TextStyle(fontSize: 20)),
              textColor: Colors.white,
              color: Colors.pink,
              splashColor: Colors.pinkAccent,
              elevation: 15,
              onPressed: () {
                createRecord('$resultText');
              },
            ),
          ],
        ),
      ),
    );
  }

  requestPermission() async {
    final res =
        await Permission.requestSinglePermission(PermissionName.Microphone);
    print(res);
  }
}

class Item {
  String key;
  String description;
  String keyphrase;
  String timetaken;

  Item(
    this.description,
    this.keyphrase,
    this.timetaken,
  );

  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        description = snapshot.value["description"],
        keyphrase = snapshot.value["keyphrase"],
        timetaken = snapshot.value["timetaken"];

  toJson(String resultText, String keyphrase, String timetaken) {
    return {
      "description": resultText,
      "keyphrase": keyphrase,
      "timetaken": timetaken,
    };
  }
}
