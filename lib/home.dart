import 'dart:io';

import 'package:flutter/material.dart';
import 'logo.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:surat_desa/notification_list.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username, pass, idWarga, numUnread;

  @override
  void initState() {
    setPref();
    super.initState();

    numUnread = '0';

    FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
      print("Token Sent " + token);
      try {
        Map<String, Object> body = {
          "id_warga": idWarga,
          "token": token,
        };

        String formURI = "https://paondesajenggala.com/api/set_token";

        Map<String, String> header = {
          "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
          "Content-Type": "application/x-www-form-urlencoded"
        };

        http.post(formURI, body: body, headers: header);
      } catch (e) {}
    });
  }

  void setPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString("userWarga");
      pass = prefs.getString("pass");
      idWarga = prefs.getString("idWarga");
    });

    String token = await FirebaseMessaging.instance.getToken();

    Map<String, Object> body = {
      "id_warga": idWarga,
      "token": token,
    };

    String formURI = "https://paondesajenggala.com/api/set_token";

    Map<String, String> header = {
      "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    http.post(formURI, body: body, headers: header);
    print("Token Sent " + body.toString());

    getNotificationNumber();
  }

  void getNotificationNumber() async {
    try {
      Map<String, String> header = {
        "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
        "Content-Type": "application/x-www-form-urlencoded"
      };

      String uri = "https://paondesajenggala.com/api/get_count_unread_notif";
      Map<String, Object> body = {"id_warga": idWarga};

      http.Response data = await http
          .post(uri, body: body, headers: header)
          .timeout(Duration(seconds: 300), onTimeout: () {
        Fluttertoast.showToast(
            msg: "Timeout Koneksi",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);

        return null;
      });

      if (data != null) {
        if (data.statusCode == 200) {
          var numNotif = jsonDecode(data.body);
          setState(() {
            numUnread = numNotif["Count"].toString();
          });
        }
      }
    } catch (e) {
      print(e);

      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[actionButtonNotif()],
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

  Widget actionButtonNotif() {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 30),
      child: statRead(),
    );
  }

  _getRequests() async {
    setPref();
  }

  Widget statRead() {
    if (numUnread == '0') {
      return IconButton(
        icon: Icon(
          Icons.notifications,
          color: Color(0xFF18D191),
          size: 25,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/home/notification")
              .then((value) => _getRequests());
        },
      );
    } else {
      return Badge(
        shape: BadgeShape.circle,
        badgeContent: Text(
          numUnread,
          style: TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        child: IconButton(
          icon: Icon(
            Icons.notifications,
            color: Color(0xFF18D191),
            size: 25,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/home/notification")
                .then((value) => _getRequests());
          },
        ),
      );
    }
  }

  Widget buttonLetterHistory() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.8,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(85))),
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
                    letterSpacing: 3),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/home/history_letter");
        },
      ),
    );
  }

  Widget buttonSetting() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.7,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(105))),
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
                    letterSpacing: 3),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/home/settings");
        },
      ),
    );
  }

  Widget buttonNewLetter() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.9,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(65))),
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
                    letterSpacing: 3),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/home/new_letter");
        },
      ),
    );
  }
}
