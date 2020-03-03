import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  final formKey = new GlobalKey<FormState>();
  bool isLoading = false;

  String nama, tempatLahir, agama, kebangsaan, statNikah, tanggalLahir;
  String pekerjaan, alamat, jenKel, nik, username, pass, passKonfirm, kontak;

  @override
  Widget build(BuildContext context) {
    return fullBody();
  }

  Widget appBody(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar"),
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
      if(checkPass()){
        setState(() {
          isLoading = true;
        });
        setData();
      }else{
        Fluttertoast.showToast(
          msg: "Password Tidak Sama",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );
      }
    }
  }

  void setData(){
    if(jenKel == null || kebangsaan == null || statNikah == null){
      Fluttertoast.showToast(
        msg: "Kolom pilihan tidak boleh kosong",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
      );
    }else{
      Map<String,Object> data = {
        "password": pass,
        "username": username,
        "nama": nama,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "agama": agama,
        "kebangsaan": kebangsaan,
        "status_pernikahan": statNikah,
        "pekerjaan": pekerjaan,
        "alamat": alamat,
        "jenis_kelamin": jenKel,
        "nik": nik,
        "kontak": kontak,
      };

      submitForm(data);
    }
  }

  bool checkPass(){
    if(passKonfirm == pass){
      return true;
    }else{
      return false;
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
          leading: Icon(Icons.supervised_user_circle),
          title: new TextFormField(
            maxLines: 1,
            decoration: InputDecoration(
              helperText: "Username"
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => username = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: new TextFormField(
            obscureText: true,
            maxLines: 1,
            decoration: InputDecoration(
              helperText: "Password"
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => pass = val.trim(),
          ),
        ),
        ListTile(
          leading: Icon(Icons.lock_outline),
          title: new TextFormField(
            obscureText: true,
            maxLines: 1,
            decoration: InputDecoration(
              helperText: "Konfirmasi Password"
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => passKonfirm = val.trim(),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: new TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Nama"
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => nama = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_city),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Tempat Kelahiran",
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tempatLahir = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.cake),
          title: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              helperText: "Tanggal Lahir"
            ),
            onTap: (){
              showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(Duration(days: 365*18)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now().subtract(Duration(days: 360*18)),
                builder: (BuildContext buildContext, Widget child){
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              ).then((val){
                setState(() {
                  tanggalLahir = DateFormat("yyyy-MM-dd").format(val);
                });
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tanggalLahir = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.stars),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Agama",
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => agama = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Kontak",
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => kontak = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.flag),
          title: DropdownButtonFormField(
            isExpanded: true,
            hint: Text("Kebangsaan"),
            value: kebangsaan,
            items: [
              DropdownMenuItem(
                value: "WNI",
                child: Text("WNI"),
              ),
              DropdownMenuItem(
                value: "WNA",
                child: Text("WNA"),
              ),
            ],
            onChanged: (val){
              setState(() {  
                kebangsaan = val;
              });
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.wc),
          title: DropdownButtonFormField(
            isExpanded: true,
            hint: Text("Status Pernikahan"),
            value: statNikah,
            items: [
              DropdownMenuItem(
                value: "Menikah",
                child: Text("Menikah"),
              ),
              DropdownMenuItem(
                value: "Janda",
                child: Text("Janda"),
              ),
              DropdownMenuItem(
                value: "Duda",
                child: Text("Duda"),
              ),
              DropdownMenuItem(
                value: "Lajang",
                child: Text("Lajang"),
              )
            ],
            onChanged: (val){
              setState(() {  
                statNikah = val;
              });
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.work),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Pekerjaan",
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => pekerjaan = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Alamat",
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => alamat = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: DropdownButtonFormField(
            isExpanded: true,
            hint: Text("Jenis Kelamin"),
            value: jenKel,
            items: [
              DropdownMenuItem(
                value: "L",
                child: Text("L"),
              ),
              DropdownMenuItem(
                value: "P",
                child: Text("P"),
              ),
            ],
            onChanged: (val){
              setState(() {  
                jenKel = val;
              });
            },
          )
        ),
        ListTile(
          leading: Icon(Icons.credit_card),
          title: TextFormField(
            keyboardType: TextInputType.number,
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "NIK",
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => nik = val,
          ),
        ),
      ],
    );
  }

  void submitForm(Map<String, Object> body) async{
    try{
      
      Map<String,String> header = {
        "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
        "Content-Type": "application/x-www-form-urlencoded"};

      String formURI = "https://www.terraciv.me/api/daftar_warga";

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

}
