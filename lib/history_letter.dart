import 'package:flutter/material.dart';

class HistoryLetter extends StatefulWidget {
  @override
  _HistoryLetterState createState() => _HistoryLetterState();
}

class _HistoryLetterState extends State<HistoryLetter> {

  bool isLoading = false;

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

  Widget appBody(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Surat"),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 20
          )
        )
      ),
      body: showList()
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

  Widget showList(){
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.book,
              size: 35
            ),
          ),
        ],
      )
    );
  }

}