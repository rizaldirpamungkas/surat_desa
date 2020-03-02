import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return appBody(context);
  }

  Widget appBody(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan"),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 20
          )
        )
      ),
      body: fullBody(context),
    );
  }

  Widget fullBody(BuildContext context){
    return ListView(
      children: <Widget>[
        InkWell(
          child: ListTile(
            leading: Icon(
              Icons.person  
            ),
            title: Text(
              "Pengaturan Profil",
              style: TextStyle(
                fontFamily: 'Montserrat', 
                fontSize: 20.0,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5
              ),
            ),
          ),
          onTap: (){
            Navigator.pushNamed(context, "/home/settings/profile");
          },
        ),
        Divider(
          thickness: 1, 
          indent: 70,
        ),
        InkWell(
          child: ListTile(
            leading: Icon(
              Icons.lock  
            ),
            title: Text(
              "Ubah Password",
              style: TextStyle(
                fontFamily: 'Montserrat', 
                fontSize: 20.0,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5
              ),
            ),
          ),
          onTap: (){
            Navigator.pushNamed(context, "/home/settings/change_pass");
          },
        ),
        Divider(
          thickness: 1, 
          indent: 70,
        ),
        InkWell(
          child: ListTile(
            leading: Icon(
              Icons.exit_to_app  
            ),
            title: Text(
              "Log Out",
              style: TextStyle(
                fontFamily: 'Montserrat', 
                fontSize: 20.0,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5
              ),
            ),
          ),
          onTap: (){
            deleteUserPreferences();
            Navigator.of(context).pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
          },
        ),
        Divider(
          thickness: 1, 
          indent: 70,
        ),
      ],
    );
  }

  void deleteUserPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("idWarga");
    prefs.remove("userWarga");
    prefs.remove("namaWarga");
    prefs.remove("tempatLahir");
    prefs.remove("tanggalLahir");
    prefs.remove("agama");
    prefs.remove("kebangsaan");
    prefs.remove("statusPernikahan");
    prefs.remove("pekerjaan");
    prefs.remove("alamat");
    prefs.remove("jenisKelamin");
    prefs.remove("kontak");
    prefs.remove("nik");
    prefs.remove("pass");
  }
}