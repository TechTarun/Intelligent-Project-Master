import 'package:flutter/material.dart';
//import './main.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTime() async{
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

void navigationPage(){
  Navigator.of(context).pushReplacementNamed('/LoginPage');
}

  @override
  void initState() {
    super.initState();
    startTime();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                backgroundImage: AssetImage('assets/ipm.jpg',),
                radius: 75,),
              //  SizedBox(height: 20,),
              //  Text('GLOBAL', style: TextStyle(
              //    color: Colors.white,
              //    fontSize: MediaQuery.of(context).size.height/30,
              //    fontWeight: FontWeight.bold,
              //    fontFamily: 'Pacifico',
              //  ),),
              SizedBox(height: 40),
               CircularProgressIndicator(),
              ],
            ),
            Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Text('Intelligent Product Master',
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: MediaQuery.of(context).size.width/25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontFamily: 'Pacifico',
                  )),)
                  )
          ],
        ),
      ),
    );
    
  }
}