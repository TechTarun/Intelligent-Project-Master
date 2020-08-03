import 'package:flutter/material.dart';
import 'package:sih/splashscreen.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_database/firebase_database.dart';

//pages
import './home.dart';

void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/LoginPage': (BuildContext context) => LoginPage()
      },
    ));

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String authlist = "";
  String _user;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  final _formKey = new GlobalKey<FormState>();
  final FlutterTts flutterTts = FlutterTts();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print("true");
      return true;
    }
    print("false");
    return false;
  }

  void validateAndSubmit() {
    if (validateAndSave()) {
      authorize();
    }
  }

  void authorize() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.once().then((DataSnapshot snap) {
      var data = snap.value;
      var items = data['auth'];
      var keys = items.keys;
      print(_user);
      print(_password);

      for (var key in keys) {
        if (items[key]['username'] == _user &&
            items[key]['password'].toString() == _password) {
          authlist = _user;
        }
      }

      if (authlist.length > 0) {
        speak("Hello user, I am IPM. Your jarvis from Team Intelleneur");
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new HomePage()));
      } else {
        speak("Authorization failed!! Wrong usernamme or password");
      }
    });
  }

  void speak(String text) async {
    await flutterTts.setLanguage("en_US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white70,
          body: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xff283593),
                        borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(70),
                            bottomRight: const Radius.circular(70)))),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: new Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        buildlogo(),
                        buildContainer(),
                      ],
                    ),
                  ))
                ],
              )
            ],
          )),
    );
    // return Scaffold(
    //     resizeToAvoidBottomPadding: false,
    //     //  backgroundColor: Colors.pinkAccent,
    //     body: Container(
    //         decoration: BoxDecoration(
    //             image: DecorationImage(
    //                 image: AssetImage('assets/ig.jpg'),
    //                 fit: BoxFit.cover)),
    //         child: Column(
    //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //            //crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             Container(
    //                padding: EdgeInsets.fromLTRB(50.0, 150.0, 50.0, 0),
    //                 child: new Form(
    //                   key: _formKey,
    //                   child: new ListView(
    //                     shrinkWrap: true,
    //                     children: <Widget>[
    //                       logo(),
    //                       showUserInput(),
    //                       showUserPassword(),
    //                       loginButton(),
    //                     ],
    //                   ),
    //                 ))
    //           ],
    //           //       ),
    //           //     ),
    //           //   ),
    //         ))
    //         );
  }

  Widget buildlogo() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text("IPM",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pacifico',
            color: Colors.white,
          ))
    ]);
  }

  Widget buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico'),
                    )
                  ],
                ),
                showUserInput(),
                showUserPassword(),
                loginButton(),
              ],
            ),
          ),
        )
      ],
    );
  }
  // Widget logo() {
  //   return Padding(
  //       padding: const EdgeInsets.fromLTRB(60.0, 30.0, 50.0, 0.0),
  //       child: Text(
  //         'IPM',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 88.0,
  //           fontWeight: FontWeight.bold,
  //           fontFamily: 'Pacifico',
  //         ),
  //       ));
  // }

  Widget showUserInput() {
    return Padding(
      padding: const EdgeInsets.all(20),
      //fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new TextFormField(
          decoration: InputDecoration(
            hintText: 'Username or TeamId',
            hoverColor: Colors.white,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              Icons.email,
              color: Color(0xff3F51B5),
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(60.0)),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _user = value.trim()),
    );
  }

  Widget showUserPassword() {
    return Container(
      padding: EdgeInsets.all(20),
      //fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Password',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xff3F51B5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(60.0),
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            obscureText: true,
            autofocus: false,
            validator: (value) =>
                value.isEmpty ? 'Password can\'t be empty' : null,
            onSaved: (value) => _password = value.trim(),
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return Padding(
      padding: EdgeInsets.all(10),
      //fromLTRB(50.0, 40.0, 50.0, 0),
      child: Material(
        borderRadius: BorderRadius.circular(60.0),
        shadowColor: Colors.blueAccent.shade200,
        elevation: 5.0,
        child: MaterialButton(
          splashColor: Color(0xff3F51B5),
          minWidth: 200.0, height: 60.0,
          onPressed: () => validateAndSubmit(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          color: Color(0xff3F51B5),
          child: Text(
            'Continue',
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 30,
                fontFamily: 'Pacifico'),
          ),
          // Icon(MdiIcons.arrowExpandRight,),
          // iconSize:
        ),
      ),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}
