import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sih/bigbucket.dart';
import 'package:sih/confulence.dart';
import 'package:sih/github.dart';
import 'package:sih/jira.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:sih/meeting1.dart';
import 'package:sih/main.dart';
import 'package:sih/meeting.dart';
import 'package:sih/meetingdata.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//import 'package:url_launcher/url_launcher.dart'; //this is for url
//import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //  Future<void> _launchUniversalLinkIos(String url) async {
  //   if (await canLaunch(url)) {
  //     final bool nativeAppLaunchSucceeded = await launch(
  //       url,
  //       forceSafariVC: false,
  //       universalLinksOnly: true,
  //     );
  //     if (!nativeAppLaunchSucceeded) {
  //       await launch(url, forceSafariVC: true);
  //     }
  //   }
  // }

  Material MyItems(IconData icon, String heading, int color, Function onTap) {
    return Material(
      color: Color(0xff3949AB),
      elevation: 35.0,
      shadowColor: Color(0x802196f3),
      borderRadius: BorderRadius.circular(30.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    heading,
                    style: TextStyle(
                      color: Color(color),
                      fontSize: 20,
                    ),
                  ),
                  Material(
                    color: new Color(color),
                    borderRadius: BorderRadius.circular(24.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(icon, color: Colors.white, size: 30.0),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Do you want to log out..!!'),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  splashColor: Colors.grey,
                  child: Text(
                    'YES',
                    style: TextStyle(color: Colors.blue, fontSize: 20.0),
                  ),
                  onPressed: () {
                    exit(0);
                  }),
              MaterialButton(
                elevation: 5.0,
                splashColor: Colors.grey,
                child: Text(
                  'NO',
                  style: TextStyle(color: Colors.blue, fontSize: 20.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  //  Navigator.push(
                  //   context, new MaterialPageRoute(
                  //   builder: (BuildContext context) => new HomePage())
                  // );
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //(0xff00008b),
      appBar: AppBar(
        title: Text(
          'HOME',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 30.0,
        toolbarHeight: 80.0,
        backgroundColor: Color(0xff3F51B5),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/backimg.jpg'),
                      fit: BoxFit.cover)),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/fis.jpg"),
                        radius: 50.0,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'I P M',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
            CostomListTitle(Icons.home, 'HOME', () {
              Navigator.of(context).pop();
            }),
            CostomListTitle(MdiIcons.githubBox, 'GITHUB', () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new GitHub()));
            }),
            CostomListTitle(MdiIcons.jira, 'JIRA', () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new Jira()));
            }),
            CostomListTitle(MdiIcons.bitbucket, 'BITBUCKET', () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new BigBucket()));
            }),
            CostomListTitle(MdiIcons.atlassian, 'CONFLUENCE', () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new Confulence()));
            }),
            CostomListTitle(MdiIcons.group, 'Auto-note', () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new VoiceHome()));
            }),
            CostomListTitle(MdiIcons.accountQuestion, 'Ask a Query', () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new ShowDataPage()));
            }),
            CostomListTitle(Icons.lock, 'LOG OUT', () {
              createAlertDialog(context);
            }),
          ],
        ),
      ),
      body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 13,
          mainAxisSpacing: 13,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            MyItems(MdiIcons.githubBox, 'GITHUB', 0xffed622b, () {
              // Navigator.pop(context);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new GitHub()));
              // _launchUniversalLinkIos('https://whatismyipaddress.com/');
            }),
            MyItems(MdiIcons.jira, 'JIRA', 0xff26cd3c, () {
              //Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new Jira()));
            }),
            MyItems(MdiIcons.bitbucket, 'BITBUCKET', 0xffff3266, () {
              //Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new BigBucket()));
            }),
            MyItems(MdiIcons.atlassian, 'CONFLUENCE', 0xff3399fe, () {
              //Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new Confulence()));
            }),
            MyItems(MdiIcons.group, 'AUTO-NOTE', 0xfff4c83f, () {
              //Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new VoiceHome()));
            }),
            MyItems(MdiIcons.accountQuestion, 'ASK A QUERY', 0xff7297ff, () {
              //Navigator.of(context).pop();
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new ShowDataPage()));
            }),
            MyItems(Icons.lock, 'LOG OUT', 0xffff0000, () {
              createAlertDialog(context);
            }),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 150),
            StaggeredTile.extent(1, 150),
            StaggeredTile.extent(1, 150),
            StaggeredTile.extent(2, 220),
            StaggeredTile.extent(1, 150),
            StaggeredTile.extent(1, 150),
            StaggeredTile.extent(2, 150),
          ]),
    );
  }
}

class CostomListTitle extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CostomListTitle(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 8, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        child: InkWell(
          splashColor: Colors.grey,
          onTap: onTap,
          child: Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Text(
                      text,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
