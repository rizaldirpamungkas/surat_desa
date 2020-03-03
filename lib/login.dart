import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String userName, passWord, errorMessage;
  final formKey = new GlobalKey<FormState>();
  bool isLoading, signInButtonStat;

  @override
  void initState() {    
    errorMessage = "";
    isLoading = false;
    signInButtonStat = true;
    checkStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (){
          exit(0);
          return Future.value(true);
        },
        child: Scaffold(
        body: fullBody(),
      ),
    );
  }

  Widget fullBody(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Stack(
          children: <Widget>[
            showCircularProgress(),
            showForm()
          ],
        )
      )
    );
  }

  void checkStatus(){
    getDataUser("idWarga").then((val){
      if(val != null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }

  Widget showErrorMessage() {
    if (errorMessage.length > 0 && errorMessage != null) {

      setState(() {
        isLoading = false;
        signInButtonStat = true;
      });

      return new Text(
        errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showForm(){
    return Container(
      child: Form(
        key: formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo(),
              spliter(),
              usernameField(),
              spliter(),
              passwordField(),
              signInButton(),
              spliter(),
              signUpButton(),
              showErrorMessage()
            ],
        ),
      ),
    );
  }

  Widget logo() =>  Logo();

  Widget usernameField(){ 
    return TextFormField(
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
      maxLines: 1,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Username",
        icon: Icon(
          Icons.account_circle,
          color: Colors.grey,
        ),
      ),
      validator: (value) => value.isEmpty ? 'Username tidak boleh kosong' : null,
      onSaved: (value) => userName = value.trim(),
    );
  }

  Widget passwordField(){ 
    return TextFormField(
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
      obscureText: true,
      maxLines: 1,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        icon: Icon(
          Icons.lock,
          color: Colors.grey,
        ),
      ),
      validator: (value) => value.isEmpty ? 'Password tidak boleh kosong' : null,
      onSaved: (value) => passWord = value.trim(),
    );
  }

  Widget spliter() => SizedBox(height: 5);

  Widget signInButton(){ 
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: SizedBox(
        height: 40.0,
            child: RaisedButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Color(0xFF18D191),
              child: Text(
                "Masuk", 
                style: TextStyle(
                  fontFamily: 'Montserrat', 
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3
                )
              ),
              disabledColor: Colors.grey,
              disabledElevation: 0,
              onPressed: signInButtonStat ? validateAndSubmit : null
            ),
      ),
    );
  }

  Widget signUpButton(){
    return FlatButton(
      child: Text(
                  "Belum memiliki akun? Daftar disini", 
                  style: TextStyle(
                    fontFamily: 'Montserrat', 
                    fontSize: 13.0,
                    color: Color(0xFF18D191),
                    fontWeight: FontWeight.w500,
                  )
                ),
      onPressed: (){
        Navigator.of(context).pushNamed("/registration");
      },
    );
  }

  Widget showCircularProgress() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      errorMessage = "";
      isLoading = true;
      signInButtonStat = false;
    });

    // await Future.delayed(Duration(seconds: 10));

    FocusScope.of(context).unfocus();

    if (validateAndSave()) {
      try {

        print("Trying Login");

        String loginURI = "https://www.terraciv.me/api/login_warga";
        Map<String,String> body = {"username": userName,"password": passWord};
        Map<String,String> header = {
          "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
          "Content-Type": "application/x-www-form-urlencoded"};
        http.Response data = await http.post(loginURI, body: body, headers: header);
        Map<String,Object> response = jsonDecode(data.body);
        Map<String,Object> responseLogin = response["Data"];
        
        setState(() {
          isLoading = false;
          signInButtonStat = true;
        });

        if(response["Code"] == 200){
          print("Pass Corect");
          
          String dataWargaURI = "https://www.terraciv.me/api/get_data_warga";
          Map<String,String> body = {"username": userName,"id_warga": responseLogin["id_warga"]};
          http.Response data = await http.post(dataWargaURI, body: body, headers: header);
          Map<String,Object> dataWarga = jsonDecode(data.body);
          Map<String,Object> detailDataWarga = dataWarga["Data"];

          print(detailDataWarga);
          setUserPreferences(detailDataWarga, responseLogin["id_warga"], userName, passWord);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        }else{
          print("Pass Wrong");
          wrongPassDialog();
        }

      } catch (e) {
        print('Error: $e');
        setState(() {
          isLoading = false;
          signInButtonStat = true;
          errorMessage = e.message;
          formKey.currentState.reset();
        });
      }
    }else{
      setState(() {
          isLoading = false;
          signInButtonStat = true;
      });
    }
  }

  Future<void> wrongPassDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Peringatan'),
          content: Container(
            child: Text('Username atau password yang anda masukan salah'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void setUserPreferences(Map<String, Object> dataWarga, String idWarga, 
                          String userName, String pass) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("idWarga", idWarga);
    prefs.setString("userWarga", userName);
    prefs.setString("namaWarga", dataWarga["nama"]);
    prefs.setString("tempatLahir", dataWarga["tempat_lahir"]);
    prefs.setString("tanggalLahir", dataWarga["tanggal_lahir"]);
    prefs.setString("agama", dataWarga["agama"]);
    prefs.setString("kebangsaan", dataWarga["kebangsaan"]);
    prefs.setString("statusPernikahan", dataWarga["status_pernikahan"]);
    prefs.setString("pekerjaan", dataWarga["pekerjaan"]);
    prefs.setString("alamat", dataWarga["alamat"]);
    prefs.setString("jenisKelamin", dataWarga["jenis_kelamin"]);
    prefs.setString("kontak", dataWarga["kontak"]);
    prefs.setString("nik", dataWarga["nik"]);
    prefs.setString("pass", pass);
  }

  

  dynamic getDataUser(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key) ?? null;
  }

}
