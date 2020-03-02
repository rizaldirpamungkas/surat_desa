import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  bool isLoading = false;

  @override
  void initState() {
    // Set data untuk list notif
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return fullBody();
  }

  Widget fullBody(){
    return Stack( 
      children: <Widget>[
        appBody(),
        loadingScreen()
      ],
    );
  }

  Widget loadingScreen(){
    if(isLoading){
      return SizedBox.expand(
        child: Container(
          color: Color.fromARGB(70, 255, 255, 255),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      );
    }else{
      return SizedBox.shrink();
    }
  }

  Widget appBody(){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Notifikasi"),
          iconTheme: IconThemeData(
            color: Color(0xFF18D191)
          ),
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 20,
              color: Color(0xFF18D191)
            ),
          )
        ),
        body: Center(
          child: Text("Belum ada data"),
        )
      );
  }
}