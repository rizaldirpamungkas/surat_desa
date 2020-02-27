import 'package:flutter/material.dart';
import 'package:surat_desa/detail_letter.dart';
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
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Login(), 
            );
            break;
          case '/home':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Home(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                  child: child,
                );
              },
            );
            break;
          case '/home/new_letter':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => NewLetter(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                  child: child,
                );
              },
            );
            break;
          case '/home/history_letter':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => HistoryLetter(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                  child: child,
                );
              },
            );
            break;
          case '/home/history_letter/detail_letter':
            final Surat args = settings.arguments;
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => DetailLetter(
                surat: args
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                  child: child,
                );
              },
            );
            break;
          default:
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Login(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                  child: child,
                );
              },
            );
            break;
        }
      },
    );
  }
}



