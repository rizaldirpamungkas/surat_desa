import 'dart:io';

import 'package:flutter/material.dart';
import 'logo.dart';

class Home extends StatefulWidget {  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        exit(0);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            actionButtonNotif()    
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Logo(),
            SizedBox(height: 50),
            buttonNewLetter(),
            SizedBox(height: 10),
            buttonLetterHistory(),
            SizedBox(height: 10),
            buttonSetting()
          ],
        ),
      ),
    );
  }

  Widget actionButtonNotif(){
    return Container(
      margin: EdgeInsets.only(top: 10, right: 30),
      child: IconButton(
        icon: Icon(
            Icons.notifications,
            color: Color(0xFF18D191),
            size: 25,
        ),
        onPressed: (){},
      ),
    );
  }

  Widget buttonLetterHistory(){
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.08,
      width: MediaQuery.of(context).size.width*0.8,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(85))
        ),
        color: Color(0xFF18D191),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Icon(
                Icons.history,
                color: Colors.white,
                size: 40,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Riwayat Surat", 
                style: TextStyle(
                  fontFamily: 'Montserrat', 
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3
                ),
              ),
            ),
          ],
        ),
        onPressed: (){
          Navigator.pushNamed(context, "/home/history_letter");
        },
      ),
    );
  }

  Widget buttonSetting(){
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.08,
      width: MediaQuery.of(context).size.width*0.7,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(105))
        ),
        color: Color(0xFF18D191),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Icon(
                Icons.build,
                color: Colors.white,
                size: 40,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Pengaturan", 
                style: TextStyle(
                  fontFamily: 'Montserrat', 
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3
                ),
              ),
            ),
          ],
        ),
        onPressed: (){
          Navigator.pushNamed(context, "/home/settings");
        },
      ),
    );
  }

  Widget buttonNewLetter(){
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.08,
      width: MediaQuery.of(context).size.width*0.9,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(65))
        ),
        color: Color(0xFF18D191),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 40,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Surat Baru", 
                style: TextStyle(
                  fontFamily: 'Montserrat', 
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3
                ),
              ),
            ),
          ],
        ),
        onPressed: (){
          Navigator.pushNamed(context, "/home/new_letter");
        },
      ),
    );
  }

}