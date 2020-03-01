import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryLetter extends StatefulWidget {
  @override
  _HistoryLetterState createState() => _HistoryLetterState();
}

class _HistoryLetterState extends State<HistoryLetter> {

  bool isLoading = true;
  String idWarga;
  List<Surat> surats = [];

  @override
  void initState() {
    setPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return fullBody();
  }

  Widget fullBody(){
    return Stack( 
      children: <Widget>[
        appBody(),
        loadingScreen()
      ],
    );
  }

  Widget appBody(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Surat"),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 20
          )
        )
      ),
      body: showList()
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

  String statSurat(String noSurat){
    if(noSurat == "-"){
      return "Belum Dicetak";
    }else if(noSurat == "batal"){
      return "Dibatalkan";
    }else{
      return "Sudah Dicetak";
    }
  }
  
  String statTglCetak(String noSurat, String tgl){
    if(noSurat == "-"){
      return "-";
    }else{
      return tgl;
    }
  }

  Widget statOptionCard(String noSurat, BuildContext context, int index){
    if(noSurat == "-"){
      return PopupMenuButton(
        itemBuilder: (context){
          return [
            PopupMenuItem(
              value: "Edit",
              child: Text(
                "Edit"
              )
            ),
            PopupMenuItem(
              value: "Batalkan",
              child: Text(
                "Batalkan"
              )
            ),
          ];
        },
        elevation: 4,
        onSelected: (val){
          if(val == "Edit"){
            editLetter(index, context);
          }else{
            cancelLetter(index);
          }
        },
      );
    }else{
      return SizedBox.shrink();
    }
  }

  String statNoSurat(String noSurat){
    if(noSurat == "batal"){
      return "-";
    }else{
      return noSurat.toUpperCase();
    }
  }

  void setPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {  
      idWarga = prefs.getString("idWarga");
    });
    getData();
  }

  Widget showList(){
    return ListView.builder(
      itemCount: surats.length,
      itemBuilder: (context, index){
        return detail(context, index);
      }
    );
  }

  void getData() async{
    try{
      
      setState(() {
        isLoading = true;
      });

      Map<String,String> header = {
        "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
        "Content-Type": "application/x-www-form-urlencoded"};

      String formURI = "https://www.terraciv.me/api/get_warga_surat";
      Map<String, Object> body = {"id_warga" : idWarga };

      http.Response data = await http.post(formURI, body: body, headers: header).timeout(
        Duration(seconds: 300),
        onTimeout: (){
          setState(() {
            isLoading = false;
          });

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
      
      if(data != null){
        if(data.statusCode == 200){
          var suratRaw = jsonDecode(data.body) as List;
          setState(() {
            surats = suratRaw.map((suratJson) => Surat.fromJson(suratJson)).toList();
          });
        }
      }

    }catch(e){
      print(e);
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

  void detailLetter(int i, BuildContext context){
    Surat sur = surats[i];
    print(sur.idSurat);
    Navigator.pushNamed(
      context, 
      "/home/history_letter/detail_letter",
      arguments: Surat(sur.noSurat, sur.idSurat, sur.idPemohon, sur.idPencetak, sur.pencetak, sur.tipeSurat, sur.nama, sur.pemohon, sur.tempatLahir, sur.tanggalLahir, sur.agama, sur.kebangsaan, sur.statusPernikahan, sur.pekerjaan, sur.alamat, sur.jenisKelamin, sur.nik, sur.tanggalSurat, sur.atasNamaTTD, sur.jabatanTTD, sur.nipTTD)
    );
  }
  
  void editLetter(int i, BuildContext context) async{
    Surat sur = surats[i];
    
    var stat = await Navigator.pushNamed(
      context, 
      "/home/history_letter/edit_letter",
      arguments: Surat(sur.noSurat, sur.idSurat, sur.idPemohon, sur.idPencetak, sur.pencetak, sur.tipeSurat, sur.nama, sur.pemohon, sur.tempatLahir, sur.tanggalLahir, sur.agama, sur.kebangsaan, sur.statusPernikahan, sur.pekerjaan, sur.alamat, sur.jenisKelamin, sur.nik, sur.tanggalSurat, sur.atasNamaTTD, sur.jabatanTTD, sur.nipTTD)
    );

    if(stat){
      setPref();
    }
  }

  void cancelLetter(int i) async{
    try{
      
      setState(() {
        isLoading = true;
      });

      Map<String,String> header = {
        "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
        "Content-Type": "application/x-www-form-urlencoded"};

      String formURI = "https://www.terraciv.me/api/cancel_surat";
      Map<String, Object> body = {"id_surat" : surats[i].idSurat};

      http.Response data = await http.post(formURI, body: body, headers: header).timeout(
        Duration(seconds: 300),
        onTimeout: (){
          setState(() {
            isLoading = false;
          });

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
      
      if(data != null){
        if(data.statusCode == 200){
          getData();
        }
      }

    }catch(e){
      print(e);
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

  Widget detail(BuildContext context, int index){
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          detailLetter(index, context);
        },
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        statNoSurat(surats[index].noSurat),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        surats[index].tipeSurat,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      statOptionCard(surats[index].noSurat, context, index)
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        statTglCetak(surats[index].noSurat, surats[index].tanggalSurat),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w100
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        statSurat(surats[index].noSurat),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w100
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}

class Surat{
  String noSurat, idSurat, idPemohon, idPencetak, pencetak, tipeSurat, nama;
  String pemohon, tempatLahir, tanggalLahir, agama, kebangsaan, statusPernikahan;
  String pekerjaan, alamat, jenisKelamin, nik, tanggalSurat, atasNamaTTD;
  String jabatanTTD, nipTTD;

  Surat(this.noSurat, this.idSurat, this.idPemohon, this.idPencetak, this.pencetak, 
        this.tipeSurat,this.nama, this.pemohon, this.tempatLahir, this.tanggalLahir, 
        this.agama, this.kebangsaan, this.statusPernikahan, this.pekerjaan, this.alamat,
        this.jenisKelamin, this.nik, this.tanggalSurat, this.atasNamaTTD, this.jabatanTTD, 
        this.nipTTD);

  factory Surat.fromJson(dynamic json){
    return Surat(json["nomor_surat"] as String, json["id_surat"] as String, 
                json["id_pemohon"] as String, json["id_pencetak"] as String, 
                json["pencetak"] as String, json["tipe_surat"] as String,
                json["nama"] as String, json["pemohon"] as String, 
                json["tempat_lahir"] as String, json["tanggal_lahir"] as String, 
                json["agama"] as String, json["kebangsaan"] as String, 
                json["status_pernikahan"] as String, json["pekerjaan"] as String, 
                json["alamat"] as String, json["jenis_kelamin"] as String, 
                json["nik"] as String, json["tanggal_surat"] as String, 
                json["atas_nama_ttd"] as String, json["jabatan_ttd"] as String, 
                json["nip_ttd"] as String);
  }

  @override
  String toString() {
    return '{ ${this.noSurat}, ${this.idSurat}, ${this.idPemohon}, ${this.idPencetak}, ${this.pencetak}, ${this.tipeSurat}, ${this.nama}, ${this.pemohon}, ${this.tempatLahir}, ${this.tanggalLahir}, ${this.agama}, ${this.kebangsaan}, ${this.statusPernikahan}, ${this.pekerjaan}, ${this.alamat}, ${this.jenisKelamin}, ${this.nik}, ${this.tanggalSurat}, ${this.atasNamaTTD}, ${this.jabatanTTD}, ${this.nipTTD} }';
  }

}
