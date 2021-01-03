import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return newLogo();
  }

  Widget newLogo(){
    return Column(
      children: <Widget>[
        Container(
          height: 178,
          width: 178,
          child: Image.asset('res/images/logo.jpg'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "PAON Desa Jenggala",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black45,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.3
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget oldLogo(){
    return Column(      
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 60.0,    
              width: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Color(0xFF18D191)
              ),
              child: Icon(Icons.mail, color: Colors.white)
            ),
            Container(
              margin: EdgeInsets.only(right: 50, top: 60),
              height: 60.0,    
              width: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Color(0xFFFA6C7F)
              ),
              child: Icon(Icons.edit, color: Colors.white)
            ),
            Container(
              margin: EdgeInsets.only(left: 30, top: 60),
              height: 60.0,    
              width: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Color(0xFFFFCE56)
              ),
              child: Icon(Icons.work, color: Colors.white)
            ),
            Container(
              margin: EdgeInsets.only(left: 100, top: 40),
              height: 60.0,    
              width: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Color(0xFF45E0EC)
              ),
              child: Icon(Icons.archive, color: Colors.white)
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "Surat Desa",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black45,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.3
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}