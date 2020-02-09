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
      body: listCard()
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

  Widget listCard(){
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: (){
          print("Detail Pressed");
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.book,
                    size: 50,
                    color: Colors.black38,
                  ),
                ],
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "SRT001", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.black54,
                      fontSize: 20
                    )
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.black45), 
                    onPressed: (){
                      print("More Pressed");
                    }
                  )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Surat Pertanggungjawaban Orangtua"),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Sudah di Cetak",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                            color: Colors.black45
                          )
                        ),
                        Text(
                          "13 Maret 2020",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                            color: Colors.black45
                          )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

}