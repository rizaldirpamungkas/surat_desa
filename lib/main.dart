import 'package:flutter/material.dart';
import 'package:surat_desa/login.dart';
import 'new_letter.dart';
import 'history_letter.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surat Desa',
      theme: ThemeData(
        primaryColor: Color(0xFF18D191),
      ),
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings){
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => Login());
            break;
          case '/home':
            return MaterialPageRoute(
              builder: (context) => Home(),
            );
            break;
          case '/home/new_letter':
            return MaterialPageRoute(
              builder: (context) => NewLetter(),
            );
            break;
          case '/home/history_letter':
            return MaterialPageRoute(
              builder: (context) => HistoryLetter(),
            );
            break;
          default:
            return MaterialPageRoute(builder: (context) => Login());
            break;
        }
      },
    );
  }
}



