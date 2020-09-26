import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:convert';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  File imageFile;
  bool isUploading = false;

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
          headline6: TextStyle(
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
        if(checkImage()){
          setState(() {
            isLoading = true;
          });
          setData();
        }else{
          Fluttertoast.showToast(
            msg: "Harap Pilih Gambar",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM
          );
        }
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

  bool checkImage(){
    if(imageFile != null){
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
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
              child: OutlineButton(
                onPressed: () => openImagePickerModal(context),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.camera_alt),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('Ambil Photo KTP'),
                  ],
                ),
              ),
            ),
            imageFile == null
                ? Text('Silahkan Ambil Gambar')
                : Image.file(
                    imageFile,
                    fit: BoxFit.contain,
                    height: 300.0,
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                  ),
          ],
        ),
      ],
    );
  }

  Widget buildUploadBtn() {
    Widget btnWidget = Container();

    if (isUploading) {
      // File is being uploaded then show a progress indicator
      btnWidget = Container(
          margin: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator());
    } else if (!isUploading && imageFile != null) {
      // If image is picked by the user then show a upload btn
      btnWidget = Container(
        margin: EdgeInsets.only(top: 10.0),
        child: RaisedButton(
          child: Text('Upload'),
          onPressed: () {
            startUploading();
          },
          color: Colors.pinkAccent,
          textColor: Colors.white,
        ),
      );
    }

    return btnWidget;
  }

  Future<Map<String, dynamic>> uploadImage(File image) async {
    setState(() {
      isUploading = true;
    });
    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    // Intilize the multipart request
    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse("baseUrl"));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension
    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      resetState();
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void startUploading() async {
    final Map<String, dynamic> response = await uploadImage(imageFile);
    print(response);
    // Check if any error occured
    if (response == null || response.containsKey("error")) {
      Fluttertoast.showToast(msg: "Image Upload Failed!!!",
          toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
    } else {
      Fluttertoast.showToast(msg: "Image Uploaded Successfully!!!",
          toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
    }
  }

  void resetState() {
    setState(() {
      isUploading = false;
      imageFile = null;
    });
  }

  void getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      imageFile = image;
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }
 
  void submitForm(Map<String, Object> body) async{
    try{
      
      Map<String,String> header = {
        "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
        "Content-Type": "application/x-www-form-urlencoded"};

      String formURI = "https://www.terraciv.me/api/daftar_warga";

      final mimeTypeData = lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');
      final daftarRequest = http.MultipartRequest('POST', Uri.parse(formURI));
      final file = await http.MultipartFile.fromPath('image', imageFile.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

      daftarRequest.headers.addAll(header);
      daftarRequest.fields['ext'] = mimeTypeData[1];
      daftarRequest.fields['password'] = body["password"];
      daftarRequest.fields['username'] = body["username"];
      daftarRequest.fields['nama'] = body["nama"];
      daftarRequest.fields['tempat_lahir'] = body["tempat_lahir"];
      daftarRequest.fields['tanggal_lahir'] = body["tanggal_lahir"];
      daftarRequest.fields['agama'] = body["agama"];
      daftarRequest.fields['kebangsaan'] = body["kebangsaan"];
      daftarRequest.fields['status_pernikahan'] = body["status_pernikahan"];
      daftarRequest.fields['pekerjaan'] = body["pekerjaan"];
      daftarRequest.fields['alamat'] = body["alamat"];
      daftarRequest.fields['jenis_kelamin'] = body["jenis_kelamin"];
      daftarRequest.fields['nik'] = body["nik"];
      daftarRequest.fields['kontak'] = body["kontak"];
      daftarRequest.files.add(file);
      
      try {
        await daftarRequest.send().then((onValue){
          if(onValue.statusCode == 200){
            Fluttertoast.showToast(
              msg: "Data Berhasil Dikirim",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
            );

            Navigator.of(context).pop();
          }
        });
        
      } catch (e) {
        print(e);
      }

      setState(() {
        isLoading = false;
      });

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

  void openImagePickerModal(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext context) {
        return Container(
          height: 150.0,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                'Ambil Gambar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Gunakan Kamera'),
                onPressed: () {
                  getImage(context, ImageSource.camera);
                },
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Gunakan Galeri'),
                onPressed: () {
                  getImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      }
    );
  }
}
