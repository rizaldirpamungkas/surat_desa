import 'package:flutter/material.dart';
import 'history_letter.dart';

class DetailLetter extends StatefulWidget {

  final Surat surat;

  DetailLetter({
    Key key,
    @required this.surat
  }) : super(key: key);

  @override
  _DetailLetterState createState() => _DetailLetterState(surat);
}

class _DetailLetterState extends State<DetailLetter> {

  final Surat surat;

  _DetailLetterState(this.surat);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return appBody();
  }

  Widget appBody(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Surat"),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 20
          )
        )
      ),
      body: mainBody(),
    );
  }

  Widget mainBody(){
    return Column(
      children: <Widget>[
        ListTile(
          leading: Text("Tipe Surat"),
          title: Text(surat.tipeSurat),
        ),
        ListTile(
          leading: Text("No Surat"),
          title: Text(surat.noSurat),
        ),
      ],
    );
  }

}