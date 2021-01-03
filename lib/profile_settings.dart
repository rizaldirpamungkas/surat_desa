import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {

  final formKey = new GlobalKey<FormState>();
  bool isLoading = false;

  String nama, tempatLahir, agama, kebangsaan, statNikah, tanggalLahir, idWarga;
  String pekerjaan, alamat, jenKel, nik, username, pass, passIn, kontak;

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
        title: Text("Pengaturan Profil"),
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
          msg: "Password Salah",
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
        "id_warga": idWarga, 
        "password": passIn,
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
    if(passIn == pass){
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
      nama = prefs.getString("namaWarga");
      tempatLahir = prefs.getString("tempatLahir");
      tanggalLahir = prefs.getString("tanggalLahir");
      agama = prefs.getString("agama");
      kebangsaan = prefs.getString("kebangsaan");
      statNikah = prefs.getString("statusPernikahan");
      kontak = prefs.getString("kontak");
      pekerjaan = prefs.getString("pekerjaan");
      alamat = prefs.getString("alamat");
      jenKel = prefs.getString("jenisKelamin");
      nik = prefs.getString("nik");
      idWarga = prefs.getString("idWarga");
    });
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
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(
              text: username
            ),
            decoration: InputDecoration(
              helperText: "Username"
            ),
            onChanged: (val){
              username = val;
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => username = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: new TextFormField(
            obscureText: true,
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Password"
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => passIn = val.trim(),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: new TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(
              text: nama
            ),
            decoration: InputDecoration(
              helperText: "Nama"
            ),
            onChanged: (val){
              nama = val;
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => nama = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_city),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(
              text: tempatLahir
            ),
            decoration: InputDecoration(
              helperText: "Tempat Kelahiran",
            ),
            onChanged: (val){
              tempatLahir = val;
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tempatLahir = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.cake),
          title: TextFormField(
            readOnly: true,
            controller: TextEditingController(
              text: tanggalLahir
            ),
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
            controller: TextEditingController(
              text: agama
            ),
            decoration: InputDecoration(
              helperText: "Agama",
            ),
            onChanged: (val){
              agama = val;
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => agama = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(
              text: kontak
            ),
            onChanged: (val){
              kontak = val;
            },
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
            controller: TextEditingController(
              text: pekerjaan
            ),
            decoration: InputDecoration(
              helperText: "Pekerjaan",
            ),
            onChanged: (val){
              pekerjaan = val;
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => pekerjaan = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(
              text: alamat
            ),
            decoration: InputDecoration(
              helperText: "Alamat",
            ),
            onChanged: (val){
              alamat = val;
            },
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
            controller: TextEditingController(
              text: nik
            ),
            onChanged: (val){
              nik = val;
            },
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

      String formURI = "https://paondesajenggala.com/api/update_data_warga";

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
    prefs.setString("idWarga", idWarga);
    prefs.setString("userWarga", username);
    prefs.setString("namaWarga", nama);
    prefs.setString("tempatLahir", tempatLahir);
    prefs.setString("tanggalLahir", tanggalLahir);
    prefs.setString("agama", agama);
    prefs.setString("kebangsaan", kebangsaan);
    prefs.setString("statusPernikahan", statNikah);
    prefs.setString("pekerjaan", pekerjaan);
    prefs.setString("alamat", alamat);
    prefs.setString("jenisKelamin", jenKel);
    prefs.setString("kontak", kontak);
    prefs.setString("nik", nik);
    prefs.setString("pass", passIn);
  }

}