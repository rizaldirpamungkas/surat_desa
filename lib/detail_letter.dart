import 'package:flutter/material.dart';
import 'history_letter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool isLoading = true;
  Map<String,Object> suratRaw;

  _DetailLetterState(this.surat);

  @override
  void initState() {
    getData();
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
      body: fullBody(),
    );
  }

  Widget fullBody(){
    return Stack( 
      children: <Widget>[
        list(),
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

  void getData() async{
    try{
      
      setState(() {
        isLoading = true;
      });

      Map<String,String> header = {
        "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
        "Content-Type": "application/x-www-form-urlencoded"};

      String formURI = "https://www.terraciv.me/api/get_detail_surat";
      Map<String, Object> body = {"tipe" : surat.tipeSurat, "id_surat": surat.idSurat};
      print("Det/"+surat.idSurat);
      print("Det/"+surat.tipeSurat);

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

          Navigator.pop(context);

          return null;
        }
      );

      setState(() {
        isLoading = false;
      });
      
      if(data != null){
        if(data.statusCode == 200){
          print(data.body);
          setState(() {
            suratRaw = jsonDecode(data.body);
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

  Widget list(){
    return ListView(
      children: <Widget>[
        SizedBox(height: 5),
        point("Tipe Surat", surat.tipeSurat),
        point("Nomor Surat", statNoSurat(surat.noSurat)),
        point("Pemohon", surat.nama),
        detailSubSurat(surat.tipeSurat),
        point("Alamat Pemohon", surat.alamat),
        point("Tempat Tanggal Lahir", surat.tempatLahir+" "+surat.tanggalLahir),
        point("Agama", surat.agama),
        point("Kebangsaan", surat.kebangsaan),
        point("Pekerjaan", surat.pekerjaan),
        point("Status Pernikahan", surat.statusPernikahan),
        point("Jenis Kelamin", surat.jenisKelamin),
        point("NIK", surat.nik),
        statCheckSurat(surat.atasNamaTTD, surat.jabatanTTD, surat.nipTTD, surat.noSurat),
        statCheckTanggal(surat.tanggalSurat, surat.noSurat),
        SizedBox(height: 5),
      ],
    );
  }

  String statNoSurat(String noSurat){
    if(noSurat == "batal"){
      return "-";
    }else{
      return noSurat.toUpperCase();
    }
  }

  Widget detailSubSurat(tipeSurat){
    switch (tipeSurat) {
      case "Keterangan Berpergian":
        return detailBerpergian();
        break;
      case "Keterangan Cerai":
        return detailCerai();
        break;
      case "Keterangan Kepemilikan Sepeda Motor":
        return detailMotor();
        break;
      case "Keterangan Bebas Pajak":
        return detailPajak();
        break;
      case "Keterangan Beda Nama":
        return detailBedaNama();
        break;
      case "Keterangan Kehilangan":
        return detailKehilangan();
        break;
      case "Keterangan Telah Menikah":
        return detailMenikah();
        break;
      case "Pertanggungjawaban Orang Tua":
        return detailTanggungJawabOrtu();
        break;
      default: return SizedBox.shrink();
    }
  }

  Widget detailBerpergian(){
    if(suratRaw != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          point("Daerah Keberadaan", suratRaw["daerah_keberadaan"]),
          point("Tahun Kepergian", suratRaw["tahun_kepergian"]),
        ],
      );
    }else{
      return SizedBox.shrink();
    }
  }
  
  Widget detailPajak(){
    if(suratRaw != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          point("Objek Pajak", suratRaw["objek_pajak"]),
        ],
      );
    }else{
      return SizedBox.shrink();
    }
  }
  
  Widget detailCerai(){
    if(suratRaw != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          point("Status Cerai", suratRaw["status_cerai"]),
          point("Nama Pasangan", suratRaw["nama_pasangan"]),
          point("Tahun Cerai", suratRaw["tahun_cerai"]),
          point("Tempat Cerai", suratRaw["tempat_cerai"]),
        ],
      );
    }else{
      return SizedBox.shrink();
    }
  }
  
  Widget detailKehilangan(){
    if(suratRaw != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          point("Objek Hilang", suratRaw["objek_hilang"]),
          point("Tempat Hilang", suratRaw["tempat_hilang"]),
          point("Tanggal Hilang", suratRaw["tanggal_hilang"]),
        ],
      );
    }else{
      return SizedBox.shrink();
    }
  }
  
  Widget detailBedaNama(){
    if(suratRaw != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          point("Objek Salah Nama", suratRaw["objek_salah_nama"]),
          point("Nama di Objek Salah Nama", suratRaw["nama_objek_salah_nama"]),
          point("Tanggal Lahir di Objek Salah Nama", suratRaw["tanggal_lahir_objek_salah_nama"]),
          point("Tempat Lahir di Objek Salah Nama", suratRaw["tempat_lahir_objek_salah_nama"]),
          point("Jenis Kelamin di Objek Salah Nama", suratRaw["jenis_kelamin_objek_salah_nama"]),
          point("Alamat di Objek Salah Nama", suratRaw["alamat_objek_salah_nama"]),
        ],
      );
    }else{
      return SizedBox.shrink();
    }
  }
  
  Widget detailMotor(){
    if(suratRaw != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          point("Nomor Polisi", suratRaw["nomor_polisi"]),
          point("Merk", suratRaw["merk"]),
          point("Tipe", suratRaw["tipe"]),
          point("Jenis", suratRaw["jenis"]),
          point("Tahun Pembuatan", suratRaw["tahun_pembuatan"]),
          point("Tahun Perakitan", suratRaw["tahun_perakitan"]),
          point("Isi Silinder", suratRaw["isi_silinder"]),
          point("Warna", suratRaw["warna"]),
          point("Nomor Rangka", suratRaw["nomor_rangka"]),
          point("Nomor Mesin", suratRaw["nomor_mesin"]),
          point("Nomor BPKB", suratRaw["nomor_bpkb"]),
          point("Atas Nama BPKB", suratRaw["atas_nama_bpkb"]),
        ],
      );
    }else{
      return SizedBox.shrink();
    }
  }
  
  Widget detailMenikah(){
    if(suratRaw != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          point("Nama Pasangan", suratRaw["nama_pasangan"]),
          point("Tanggal Lahir Pasangan", suratRaw["tanggal_lahir_pasangan"]),
          point("Tempat Lahir Pasangan", suratRaw["tempat_lahir_pasangan"]),
          point("Jenis Kelamin Pasangan", suratRaw["jenis_kelamin_pasangan"]),
          point("Agama Pasangan", suratRaw["agama_pasangan"]),
          point("Kebangsaan Pasangan", suratRaw["kebangsaan_pasangan"]),
          point("Pekerjaan Pasangan", suratRaw["pekerjaan_pasangan"]),
          point("Alamat Pasangan", suratRaw["alamat_pasangan"]),
          point("Tanggal Nikah", suratRaw["tanggal_nikah"]),
          point("Tempat Nikah", suratRaw["tempat_nikah"]),
        ],
      );
    }else{
      return SizedBox.shrink();
    }
  }
  
  Widget detailTanggungJawabOrtu(){
    if(suratRaw != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          point("Nama Anak", suratRaw["nama_anak"]),
          point("Tanggal Lahir Anak", suratRaw["tanggal_lahir_anak"]),
          point("Tempat Lahir Anak", suratRaw["tempat_lahir_anak"]),
          point("Jenis Kelamin Anak", suratRaw["jenis_kelamin_anak"]),
          point("Agama Anak", suratRaw["agama_anak"]),
          point("Kebangsaan Anak", suratRaw["kebangsaan_anak"]),
          point("Pekerjaan Anak", suratRaw["pekerjaan_anak"]),
          point("Alamat Anak", suratRaw["alamat_anak"]),
          point("Hubungan Ortu Dengan Anak", suratRaw["hubungan_ortu_dengan_anak"]),
          point("Jenis Kegiatan", suratRaw["jenis_kegiatan"]),
          point("Nama Instansi Kegiatan", suratRaw["nama_instansi_kegiatan"]),
          point("Alamat Instansi", suratRaw["alamat_instansi"]),
          point("Nama Kades", suratRaw["nama_kades"]),
          point("Nama Desa", suratRaw["nama_desa"]),
          point("Nama Kadus", suratRaw["nama_kadus"]),
          point("Nama Dusun", suratRaw["nama_dusun"]),
        ],
      );
    }else{
      return SizedBox.shrink();
    }
  }

  Widget statPencetak(String pencetak, String noSurat){
    if((noSurat != "-" || noSurat != 'batal') && pencetak != null){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Dicetak Oleh",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w200
              ),
            ),
            Text(
              pencetak,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
      );
    }else{
      return SizedBox.shrink();
    }
  }

  Widget statCheckTanggal(String tglSurat, String noSurat){
    if(noSurat != "-" || noSurat != "batal"){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Tanggal Cetak",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w200
              ),
            ),
            Text(
              tglSurat,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
      );
    }else{
      return SizedBox.shrink();
    }
  }

  Widget statCheckSurat(String atasNama, String jabatan, String nip, String noSurat){
    if(noSurat != "-" || noSurat != "batal"){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Yang Bertanda Tangan",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w200
              ),
            ),
            Text(
              atasNama+" "+jabatan,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400
              ),
            ),
            Text(
              nip,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
      );
    }else{
      return SizedBox.shrink();
    }
  }

  Widget point(String title, String content){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w200
            ),
          ),
          Text(
            content,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }

}