import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:expandable/expandable.dart';
import 'package:badges/badges.dart';
import 'package:surat_desa/home.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  String idWarga;
  bool isLoading = true;
  List<Notification> notifs = [];

  @override
  void initState() {
    setPref();
    super.initState();
  }

  void setPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      idWarga = prefs.getString("idWarga");
    });

    getData();
  }

  void setReadStat(String idNotif) {
    String loginURI = "https://paondesajenggala.com/api/set_notification_stat";
    Map<String, String> body = {"id_notifikasi": idNotif};
    Map<String, String> header = {
      "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    http.post(loginURI, body: body, headers: header);
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });

      Map<String, String> header = {
        "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
        "Content-Type": "application/x-www-form-urlencoded"
      };

      String formURI = "https://paondesajenggala.com/api/get_notif";
      Map<String, Object> body = {"id_warga": idWarga};

      http.Response data = await http
          .post(formURI, body: body, headers: header)
          .timeout(Duration(seconds: 300), onTimeout: () {
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(
            msg: "Timeout Koneksi",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);

        return null;
      });

      setState(() {
        isLoading = false;
      });

      if (data != null) {
        if (data.statusCode == 200) {
          var notifRaw = jsonDecode(data.body) as List;
          setState(() {
            notifs = notifRaw
                .map((notifJson) => Notification.fromJson(notifJson))
                .toList();
            print(notifs.toString());
          });
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Navigator.pop(context, true);
    return fullBody();
  }

  Widget showList() {
    return ListView.builder(
        itemCount: notifs.length,
        itemBuilder: (context, index) {
          return detail(context, index);
        });
  }

  Widget fullBody() {
    return Stack(
      children: <Widget>[appBody(), loadingScreen()],
    );
  }

  Widget appBody() {
    return Scaffold(
        appBar: AppBar(
            title: Text("Notifikasi"),
            iconTheme: IconThemeData(color: Colors.white),
            textTheme: TextTheme(headline6: TextStyle(fontSize: 20))),
        body: showList());
  }

  Widget detail(BuildContext context, int index) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                  tapBodyToExpand: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(5),
                    child: Builder(builder: (context) {
                      var controller = ExpandableController.of(context);

                      return InkWell(
                        onTap: () {
                          if (notifs[index].readStat == '0') {
                            setState(() {
                              notifs[index].readStat = '1';
                            });

                            setReadStat(notifs[index].idNotfikasi);
                          }

                          controller.toggle();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  notifs[index].jenisNotifikasi,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.left,
                                ),
                                Spacer(),
                                statRead(index)
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.all(2),
                            ),
                            Text(
                              notifs[index].createdAt,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      );
                    })),
                expanded: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    notifs[index].isi,
                    softWrap: true,
                    maxLines: 1000,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400),
                  ),
                ),
                hasIcon: false,
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    ));
  }

  Widget onExpand(int index) {
    return Text(
      notifs[index].isi,
      softWrap: true,
      maxLines: 1000,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 13, fontFamily: "Montserrat", fontWeight: FontWeight.w400),
    );
  }

  Widget statRead(int index) {
    if (notifs[index].readStat == "0") {
      return Badge(
        elevation: 0,
        shape: BadgeShape.square,
        padding: EdgeInsets.all(2),
        badgeContent: Text(
          "Baru",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return Spacer();
    }
  }

  Widget detailList(BuildContext context, int index) {
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          //detailLetter(index, context);
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        notifs[index].jenisNotifikasi.toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 5),
                      Text(
                        notifs[index].isi,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                  Column(
                      //children: <Widget>[Text(notifs[index].readStat)],
                      ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        notifs[index].createdAt,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingScreen() {
    if (isLoading) {
      return SizedBox.expand(
          child: Container(
        color: Color.fromARGB(70, 255, 255, 255),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    } else {
      return SizedBox.shrink();
    }
  }
}

class Notification {
  String idSurat,
      idWarga,
      idNotfikasi,
      isi,
      jenisNotifikasi,
      createdAt,
      readStat;

  Notification(this.idNotfikasi, this.idSurat, this.idWarga, this.isi,
      this.jenisNotifikasi, this.readStat, this.createdAt);

  factory Notification.fromJson(dynamic json) {
    return Notification(
        json["id_notifikasi"] as String,
        json["id_surat"] as String,
        json["id_warga"] as String,
        json["isi"] as String,
        json["jenis_notifikasi"] as String,
        json["read_stat"] as String,
        json["created_at"] as String);
  }

  @override
  String toString() {
    return '{ ${this.idNotfikasi}, ${this.idSurat}, ${this.idWarga}, ${this.isi}, ${this.jenisNotifikasi}, ${this.readStat}, ${this.createdAt}}';
  }
}

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
