import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  
  final formKey = new GlobalKey<FormState>();
  bool isLoading = false;
  String username, pass, passNew, passNewConfirm, passOld, idWarga;

  @override
  void initState() {
    setPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return fullBody();
  }

  Widget appBody(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Password"),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 20
          )
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              validateAndSubmit();
            },
          )
        ],
      ),
      body: showFormContainer(),
    );
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

  Widget showFormContainer(){
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListView(
          children: <Widget>[
            showForm(),
          ],
        ),
      )
    );
  }

  Widget showForm(){
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.lock_open),
          title: new TextFormField(
            obscureText: true,
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Password Lama"
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => passOld = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: new TextFormField(
            obscureText: true,
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Password Baru"
            ),
            validator: (val) => val.isEmpty  ? "Kolom harus diisi" : null,
            onSaved: (val) => passNew = val.trim(),
          ),
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: new TextFormField(
            obscureText: true,
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Konformasi Password Baru"
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => passNewConfirm = val,
          ),
        ),
      ],
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

  void validateAndSubmit() {
    FocusScope.of(context).unfocus();

    if (validateAndSave()) {
      if(checkPass() && confirmPass()){
        setState(() {
          isLoading = true;
        });
        setData();
      }else{
        Fluttertoast.showToast(
          msg: "Password Salah",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );
      }
    }
  }

  bool checkPass(){
    if(passOld == pass){
      return true;
    }else{
      return false;
    }
  }

  bool confirmPass(){
    if(passNew == passNewConfirm){
      return true;
    }else{
      return false;
    }
  }

  void setPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      username = prefs.getString("userWarga");
      pass = prefs.getString("pass");
      idWarga = prefs.getString("idWarga");
    });
  }

  void setData(){
    Map<String,Object> data = {
        "id_warga": idWarga, 
        "password_baru": passNew,
        "password_lama": passOld,
        "username": username
    };

    submitForm(data);
  }

  void submitForm(Map<String, Object> body) async{
    try{
      
      Map<String,String> header = {
        "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
        "Content-Type": "application/x-www-form-urlencoded"};

      String formURI = "https://www.terraciv.me/api/update_pass_warga";

      http.Response data = await http.post(formURI, body: body, headers: header).timeout(
        Duration(seconds: 300),
        onTimeout: (){
          isLoading = false;

          Fluttertoast.showToast(
            msg: "Timeout Koneksi",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM
          );

          return null;
        }
      );

      setState(() {
        isLoading = false;
      });

      if(data.statusCode == 200){
        setUserPreferences();
        Fluttertoast.showToast(
          msg: "Data Berhasil Dikirim",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );
        Navigator.of(context).pop();
      }else{
        
      }
    }catch(e){
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
      );
    }
  }

  void setUserPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("pass", passNew);
  }

}