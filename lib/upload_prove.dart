import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class UploadProve extends StatefulWidget {
  final String idSurat;

  UploadProve({Key key, @required this.idSurat});

  @override
  _UploadProveState createState() => _UploadProveState(idSurat);
}

class _UploadProveState extends State<UploadProve> {
  File imageKTP, imageKK, imageLain;
  bool isUploading = false;

  final formKey = new GlobalKey<FormState>();
  bool isLoading = false;

  final String idSurat;

  _UploadProveState(this.idSurat);

  @override
  Widget build(BuildContext context) {
    return fullBody();
  }

  Widget appBody() {
    return WillPopScope(
      onWillPop: () {
        Fluttertoast.showToast(
            msg: "Harap Lengkapi Lampiran yang diperlukan terlebih dahulu",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Unggah Lampiran"),
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(headline6: TextStyle(fontSize: 20)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                submitForm();
              },
            )
          ],
        ),
        body: showFormBukti(),
      ),
    );
  }

  Widget fullBody() {
    return Stack(
      children: <Widget>[appBody(), loadingScreen()],
    );
  }

  Widget loadingScreen() {
    if (isLoading) {
      return SizedBox.expand(
          child: Container(
        color: Color.fromARGB(70, 255, 255, 255),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget showFormBukti() {
    return ListView(
      children: [
        Column(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: OutlineButton(
                    onPressed: () => openImagePickerModal(context, "KTP"),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Ambil Photo KTP'),
                      ],
                    ),
                  ),
                ),
                imageKTP == null
                    ? Text('Silahkan Ambil Gambar')
                    : Image.file(
                        imageKTP,
                        fit: BoxFit.contain,
                        height: 100.0,
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width,
                      ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: OutlineButton(
                    onPressed: () => openImagePickerModal(context, "KK"),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Ambil Photo KK'),
                      ],
                    ),
                  ),
                ),
                imageKK == null
                    ? Text('Silahkan Ambil Gambar')
                    : Image.file(
                        imageKK,
                        fit: BoxFit.contain,
                        height: 100.0,
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width,
                      ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: OutlineButton(
                    onPressed: () => openImagePickerModal(context, "Lain"),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Ambil Photo Lampiran Lainnya'),
                      ],
                    ),
                  ),
                ),
                imageLain == null
                    ? Text('Silahkan Ambil Gambar')
                    : Image.file(
                        imageLain,
                        fit: BoxFit.contain,
                        height: 100.0,
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width,
                      ),
              ],
            ),
          ],
        )
      ],
    );
  }

  void openImagePickerModal(BuildContext context, String type) {
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
                    getImage(context, ImageSource.camera, type);
                  },
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text('Gunakan Galeri'),
                  onPressed: () {
                    getImage(context, ImageSource.gallery, type);
                  },
                ),
              ],
            ),
          );
        });
  }

  void getImage(BuildContext context, ImageSource source, String type) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      if (type == "KTP") {
        imageKTP = image;
      } else if (type == "KK") {
        imageKK = image;
      } else {
        imageLain = image;
      }
    });
    // Closes the bottom sheet
    Navigator.pop(context);
  }

  void submitForm() async {
    try {
      if (imageKK != null && imageKTP != null) {
        setState(() {
          isLoading = true;
        });

        Map<String, String> header = {
          "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
          "Content-Type": "application/x-www-form-urlencoded"
        };

        String formURI = "https://paondesajenggala.com/api/upload_bukti";

        final buktiRequest = http.MultipartRequest('POST', Uri.parse(formURI));

        final mimeTypeDataKTP =
            lookupMimeType(imageKTP.path, headerBytes: [0xFF, 0xD8]).split('/');
        final fileKTP = await http.MultipartFile.fromPath(
            'lam_ktp', imageKTP.path,
            contentType: MediaType(mimeTypeDataKTP[0], mimeTypeDataKTP[1]));

        final mimeTypeDataKK =
            lookupMimeType(imageKK.path, headerBytes: [0xFF, 0xD8]).split('/');
        final fileKK = await http.MultipartFile.fromPath('lam_kk', imageKK.path,
            contentType: MediaType(mimeTypeDataKK[0], mimeTypeDataKK[1]));

        if (imageLain != null) {
          final mimeTypeDataLain =
              lookupMimeType(imageLain.path, headerBytes: [0xFF, 0xD8])
                  .split('/');
          final fileLain = await http.MultipartFile.fromPath(
              'lam_lain', imageLain.path,
              contentType: MediaType(mimeTypeDataLain[0], mimeTypeDataLain[1]));
          buktiRequest.files.add(fileLain);
        }

        print("OK");

        buktiRequest.headers.addAll(header);
        buktiRequest.fields['id_surat'] = idSurat;
        buktiRequest.fields['ext'] = mimeTypeDataKTP[1];
        buktiRequest.files.add(fileKTP);
        buktiRequest.files.add(fileKK);

        try {
          await buktiRequest.send().then((onValue) {
            if (onValue.statusCode == 200) {
              Fluttertoast.showToast(
                  msg: "Data Berhasil Dikirim",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/home", (Route<dynamic> route) => false);
            }
          });
        } catch (e) {
          print(e);
        }

        setState(() {
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Lampiran KTP dan KK dibutuhkan",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }
}
