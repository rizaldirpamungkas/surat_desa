import 'package:flutter/material.dart';
import 'history_letter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class EditLetter extends StatefulWidget {

  final Surat surat;

  EditLetter({
    Key key,
    @required this.surat
  }) : super(key: key);

  @override
  _EditLetterState createState() => _EditLetterState(surat);
}

class _EditLetterState extends State<EditLetter> {

  final formKey = new GlobalKey<FormState>();

  final Surat surat;
  bool isLoading = true;
  Map<String,Object> suratRaw;

  String nama, tempatLahir, agama, kebangsaan, statNikah, tanggalLahir, idWarga;
  String pekerjaan, alamat, jenKel, nik;
  String daerahKeberadaan, tahunKepergian;
  String namaPasangan, tahunCerai, tempatCerai, statCerai;
  String nomorPolisi, merk, tipe, jenis, tahunBuat, tahunRakit;
  String isiSilinder, warnaKendaraan, nomorRangka, nomorMesin;
  String nomorBPKB, atasNamaBPKB;
  String objekPajak;
  String objekSalahNama, namaObjekSalahNama, tempatLahirSalah, alamatSalah;
  String tanggalLahirSalah, jenKelSalah;
  String objekHilang, tempatHilang, tanggalHilang;
  String tanggalLahirPasangan, tanggalNikah, kebangsaanPasangan, tempatMenikah;
  String tempatLahirPasangan, agamaPasangan, pekerjaanPasangan, alamatPasangan;
  String jenKelAnak, kebangsaanAnak, hubunganOrtu, tanggalLahirAnak;
  String namaAnak, tempatLahirAnak, agamaAnak, pekerjaanAnak, alamatAnak;
  String jenisKegiatan, namaInstansiKegiatan, alamatInstansi, namaKades;
  String namaDesa, namaDusun, namaKadus;

  _EditLetterState(this.surat);

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return appBody();
  }

  void setDataGeneral(){
    setState(() {
      nama = suratRaw["nama"];
      tempatLahir = suratRaw["tempat_lahir"]; 
      agama = suratRaw["agama"];
      alamat = suratRaw["alamat"];
      kebangsaan = suratRaw["kebangsaan"];
      statNikah = suratRaw["status_pernikahan"]; 
      tanggalLahir = suratRaw["tanggal_lahir"];
      pekerjaan = suratRaw["pekerjaan"]; 
      jenKel = suratRaw["jenis_kelamin"];
      nik = suratRaw["nik"];
    });
  }

  void setDataSub(String tipeSurat){
    switch (tipeSurat) {
      case "Keterangan Berpergian":
        setState(() {
          daerahKeberadaan = suratRaw["daerah_keberadaan"]; 
          tahunKepergian = suratRaw["tahun_kepergian"]; 
        });
        break;
      case "Keterangan Cerai":
        setState(() {
          namaPasangan = suratRaw["nama_pasangan"]; 
          tahunCerai = suratRaw["tahun_cerai"];
          tempatCerai = suratRaw["tempat_cerai"];
          statCerai = suratRaw["status_cerai"];
        });
        break;
      case "Keterangan Kepemilikan Sepeda Motor":
        setState(() {
          nomorPolisi = suratRaw["nomor_polisi"];
          merk = suratRaw["merk"];
          tipe = suratRaw["tipe"];
          jenis = suratRaw["jenis"];
          tahunBuat = suratRaw["tahun_pembuatan"];
          tahunRakit = suratRaw["tahun_perakitan"];
          isiSilinder = suratRaw["isi_silinder"];
          warnaKendaraan = suratRaw["warna"];
          nomorRangka = suratRaw["nomor_rangka"];
          nomorMesin = suratRaw["nomor_mesin"];
          nomorBPKB = suratRaw["nomor_bpkb"];
          atasNamaBPKB = suratRaw["atas_nama_bpkb"];
        });
        break;
      case "Keterangan Bebas Pajak":
        setState(() {
          objekPajak = suratRaw["objek_pajak"];
        });
        break;
      case "Keterangan Beda Nama":
        setState(() {
          objekSalahNama = suratRaw["objek_salah_nama"];
          namaObjekSalahNama = suratRaw["nama_objek_salah_nama"];
          tanggalLahirSalah = suratRaw["tanggal_lahir_objek_salah_nama"];
          tempatLahirSalah = suratRaw["tempat_lahir_objek_salah_nama"];
          jenKelSalah = suratRaw["jenis_kelamin_objek_salah_nama"];
          alamatSalah = suratRaw["alamat_objek_salah_nama"];
        });
        break;
      case "Keterangan Kehilangan":
        setState(() {
          objekHilang = suratRaw["objek_hilang"];
          tempatHilang = suratRaw["tempat_hilang"];
          tanggalHilang = suratRaw["tanggal_hilang"];
        });
        break;
      case "Keterangan Telah Menikah":
        setState(() {
          namaPasangan = suratRaw["nama_pasangan"];
          tanggalLahirPasangan = suratRaw["tanggal_lahir_pasangan"];
          tanggalNikah = suratRaw["tanggal_nikah"];
          kebangsaanPasangan = suratRaw["kebangsaan_pasangan"];
          tempatMenikah = suratRaw["tempat_nikah"];
          tempatLahirPasangan = suratRaw["tempat_lahir_pasangan"];
          agamaPasangan = suratRaw["agama_pasangan"];
          pekerjaanPasangan = suratRaw["pekerjaan_pasangan"];
          alamatPasangan = suratRaw["alamat_pasangan"];
        });
        break;
      case "Pertanggungjawaban Orang Tua":
        setState(() {
          jenKelAnak = suratRaw["jenis_kelamin_anak"];
          kebangsaanAnak =  suratRaw["kebangsaan_anak"];
          hubunganOrtu = suratRaw["hubungan_ortu_dengan_anak"];
          tanggalLahirAnak = suratRaw["tanggal_lahir_anak"];
          namaAnak =  suratRaw["nama_anak"];
          tempatLahirAnak = suratRaw["tempat_lahir_anak"];
          agamaAnak = suratRaw["agama_anak"];
          pekerjaanAnak = suratRaw["pekerjaan_anak"];
          alamatAnak = suratRaw["alamat_anak"];
          jenisKegiatan = suratRaw["jenis_kegiatan"];
          namaInstansiKegiatan = suratRaw["nama_instansi_kegiatan"];
          alamatInstansi = suratRaw["alamat_instansi"];
          namaKades = suratRaw["nama_kades"];
          namaDesa = suratRaw["nama_desa"];
          namaDusun = suratRaw["nama_dusun"];
          namaKadus = suratRaw["nama_kadus"];
        });
        break;
    }
  }

  Widget appBody(){
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,false);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Surat"),
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
        body: fullBody(),
      ),
    );
  }

  Widget fullBody(){
    return Stack( 
      children: <Widget>[
        showForm(),
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
            setDataGeneral();
            setDataSub(surat.tipeSurat);
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
      setState(() {
        // errorMessage = "";
        isLoading = true;
      });
      print("OK");
      setData();
    }
  }

  Widget showForm(){
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListView(
          children: <Widget>[
            showFormGeneral(),
            formSubSurat(surat.tipeSurat)
          ],
        ),
      )
    );
  }

  Widget formSubSurat(tipeSurat){
    switch (tipeSurat) {
      case "Keterangan Berpergian":
        return formBerpergian();
        break;
      case "Keterangan Cerai":
        return formKeteranganCerai();
        break;
      case "Keterangan Kepemilikan Sepeda Motor":
        return formKepMotor();
        break;
      case "Keterangan Bebas Pajak":
        return formBebasPajak();
        break;
      case "Keterangan Beda Nama":
        return formSalahNama();
        break;
      case "Keterangan Kehilangan":
        return formKeteranganHilang();
        break;
      case "Keterangan Telah Menikah":
        return formKeteranganNikah();
        break;
      case "Pertanggungjawaban Orang Tua":
        return formTanggungJawabOrtu();
        break;
      default: return SizedBox.shrink();
    }
  }

  Widget showFormGeneral(){
    return Column(
      children: <Widget>[
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
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => agama = val,
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

  Widget formKeteranganNikah(){
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: new TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Nama Pasangan"
            ),
            controller: TextEditingController(text: namaPasangan),
            onChanged: (val){ 
              setState(() {
                namaPasangan = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => namaPasangan = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_city),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Tempat Kelahiran Pasangan",
            ),
            controller: TextEditingController(text: tempatLahirPasangan),
            onChanged: (val){ 
              setState(() {
                tempatLahirPasangan= val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tempatLahirPasangan = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.cake),
          title: TextFormField(
            readOnly: true,
            controller: TextEditingController(
              text: tanggalLahirPasangan
            ),
            decoration: InputDecoration(
              helperText: "Tanggal Lahir Pasangan"
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
                  tanggalLahirPasangan = DateFormat("yyyy-MM-dd").format(val);
                });
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tanggalLahirPasangan = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.stars),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Agama Pasangan",
            ),
            controller: TextEditingController(text: agamaPasangan),
            onChanged: (val){ 
              setState(() {
                agamaPasangan = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => agamaPasangan= val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.flag),
          title: DropdownButton(
            isExpanded: true,
            hint: Text("Kebangsaan Pasangan"),
            value: kebangsaanPasangan,
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
                kebangsaanPasangan = val;
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
              helperText: "Pekerjaan Pasangan",
            ),
            controller: TextEditingController(text: pekerjaanPasangan),
            onChanged: (val){ 
              setState(() {
                pekerjaanPasangan = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => pekerjaanPasangan = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Alamat Pasangan",
            ),
            controller: TextEditingController(text: alamatPasangan),
            onChanged: (val){ 
              setState(() {
                alamatPasangan = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => alamatPasangan = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.cake),
          title: TextFormField(
            readOnly: true,
            controller: TextEditingController(
              text: tanggalNikah
            ),
            decoration: InputDecoration(
              helperText: "Tanggal Nikah"
            ),
            onTap: (){
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (BuildContext buildContext, Widget child){
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              ).then((val){
                setState(() {
                  tanggalNikah = DateFormat("yyyy-MM-dd").format(val);
                });
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tanggalNikah = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Tempat Manikah",
            ),
            controller: TextEditingController(text: tempatMenikah),
            onChanged: (val){ 
              setState(() {
                tempatMenikah= val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tempatMenikah = val,
          ),
        ),
      ],
    );
  }

  Widget formTanggungJawabOrtu(){
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: new TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Nama Anak"
            ),
            controller: TextEditingController(text: namaAnak),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => namaAnak = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_city),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Tempat Kelahiran Anak",
            ),
            controller: TextEditingController(text: tempatLahirAnak),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tempatLahirAnak = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.cake),
          title: TextFormField(
            readOnly: true,
            controller: TextEditingController(
              text: tanggalLahirAnak
            ),
            decoration: InputDecoration(
              helperText: "Tanggal Lahir Anak"
            ),
            onTap: (){
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (BuildContext buildContext, Widget child){
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              ).then((val){
                setState(() {
                  tanggalLahirAnak = DateFormat("yyyy-MM-dd").format(val);
                });
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tanggalLahirAnak = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: DropdownButton(
            isExpanded: true,
            hint: Text("Jenis Kelamin Anak"),
            value: jenKelAnak,
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
                jenKelAnak = val;
              });
            },
          )
        ),
        ListTile(
          leading: Icon(Icons.stars),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Agama Anak",
            ),
            controller: TextEditingController(text: agamaAnak),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => agamaAnak = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.flag),
          title: DropdownButton(
            isExpanded: true,
            hint: Text("Kebangsaan Anak"),
            value: kebangsaanAnak,
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
                kebangsaanAnak = val;
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
              helperText: "Pekerjaan Anak",
            ),
            controller: TextEditingController(text: pekerjaanAnak),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => pekerjaanAnak = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Alamat Anak",
            ),
            controller: TextEditingController(text: alamatAnak),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => alamatAnak = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.directions_run),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Jenis Kegiatan",
            ),
            controller: TextEditingController(text: jenisKegiatan),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => jenisKegiatan = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_balance),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Nama Instansi Kegiatan",
            ),
            controller: TextEditingController(text: namaInstansiKegiatan),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => namaInstansiKegiatan = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Alamat Instansi",
            ),
            controller: TextEditingController(text: alamatInstansi),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => alamatInstansi = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.supervisor_account),
          title: DropdownButton(
            isExpanded: true,
            hint: Text("Hubungan Orangtua Dengan Anak"),
            value: hubunganOrtu,
            items: [
              DropdownMenuItem(
                value: "Kandung",
                child: Text("Kandung"),
              ),
              DropdownMenuItem(
                value: "Angkat",
                child: Text("Angkat"),
              ),
              DropdownMenuItem(
                value: "Tiri",
                child: Text("Tiri"),
              ),
            ],
            onChanged: (val){
              setState(() {
                hubunganOrtu = val;
              });
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.adjust),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Nama Kepala Desa",
            ),
            controller: TextEditingController(text: namaKades),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => namaKades = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.adjust),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Nama Desa",
            ),
            controller: TextEditingController(text: namaDesa),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => namaDesa = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.adjust),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Nama Dusun",
            ),
            controller: TextEditingController(text: namaDusun),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => namaDusun = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.adjust),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Nama Kepala Dusun",
            ),
            controller: TextEditingController(text: namaKadus),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => namaKadus = val,
          ),
        ),
      ],
    );
  }

  Widget formBerpergian(){
    return Column(
      children: <Widget>[
        ListTile(
         leading: Icon(Icons.map), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(text: daerahKeberadaan),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => daerahKeberadaan = val,
            decoration: InputDecoration(
              helperText: "Daerah Keberadaan",
            ),
          )
        ),
        ListTile(
         leading: Icon(Icons.timelapse), 
         title: TextFormField(
            maxLines: 1,
            maxLength: 4,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              helperText: "Tahun Kepergian",
            ),
            controller: TextEditingController(text: tahunKepergian),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tahunKepergian = val,
          )
        ),
      ],
    );
  }
  
  Widget formBebasPajak(){
    return Column(
      children: <Widget>[
        ListTile(
         leading: Icon(Icons.category), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Objek Bebas Pajak",
            ),
            controller: TextEditingController(text: objekPajak),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => objekPajak = val,
          )
        ),
      ],
    );
  }
  
  Widget formKeteranganCerai(){
    return Column(
      children: <Widget>[
        ListTile(
         leading: Icon(Icons.broken_image), 
         title: DropdownButtonFormField(
            autovalidate: true,
            isExpanded: true,
            hint: Text("Status Cerai"),
            value: statCerai,
            items: [
              DropdownMenuItem(
                value: "Cerai Mati",
                child: Text("Cerai Mati"),
              ),
              DropdownMenuItem(
                value: "Cerai Hidup",
                child: Text("Cerai Hidup"),
              ),
            ],
            onChanged: (val){
              setState(() {
                statCerai = val;
              });
            },
            onSaved: (val) => statCerai = val,
            validator: (val) => val.toString().isEmpty ? "Error" : null,
          ),
        ),
        ListTile(
         leading: Icon(Icons.account_circle), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(
              text: namaPasangan,
            ),
            decoration: InputDecoration(
              helperText: "Nama Pasangan",
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => namaPasangan = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.access_time), 
         title: TextFormField(
            maxLines: 1,
            maxLength: 4,
            controller: TextEditingController(
              text: tahunCerai,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              helperText: "Tahun Cerai",
            ),
            validator: (val) => val.toString().isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tahunCerai = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.map), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(
              text: tempatCerai
            ),
            decoration: InputDecoration(
              helperText: "Tempat Cerai",
            ),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tempatCerai = val,
          )
        ),
      ],
    );
  }
  
  Widget formKeteranganHilang(){
    return Column(
      children: <Widget>[
        ListTile(
         leading: Icon(Icons.search), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Objek Hilang",
            ),
            controller: TextEditingController(text: objekHilang),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => objekHilang = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.map), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Tempat Hilang",
            ),
            controller: TextEditingController(text: tempatHilang),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tempatHilang = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.calendar_today), 
         title: TextFormField(
            readOnly: true,
            controller: TextEditingController(
              text: tanggalHilang
            ),
            decoration: InputDecoration(
              helperText: "Tanggal Hilang"
            ),
            onTap: (){
              showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(Duration(days: 365*18)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (BuildContext buildContext, Widget child){
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              ).then((val){
                setState(() {
                  tanggalHilang = DateFormat("yyyy-MM-dd").format(val);
                });
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tanggalHilang = val,
          ),
        ),
      ],
    );
  }
  
  Widget formSalahNama(){
    return Column(
      children: <Widget>[
        ListTile(
         leading: Icon(Icons.broken_image), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Objek Salah Nama",
            ),
            controller: TextEditingController(text: objekSalahNama),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => objekSalahNama = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.account_circle), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Nama di Objek Salah Nama",
            ),
            controller: TextEditingController(text: namaObjekSalahNama),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => namaObjekSalahNama = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.cake), 
         title: TextFormField(
            readOnly: true,
            controller: TextEditingController(
              text: tanggalLahirSalah
            ),
            decoration: InputDecoration(
              helperText: "Tanggal Lahir di Objek Salah Nama"
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
                  tanggalLahirSalah = DateFormat("yyyy-MM-dd").format(val);
                });
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tanggalLahirSalah = val,
          ),
        ),
        ListTile(
         leading: Icon(Icons.location_city), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Tempat Lahir di Objek Salah Nama",
            ),
            controller: TextEditingController(text: tempatLahirSalah),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tempatLahirSalah = val,
          )
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: DropdownButton(
            isExpanded: true,
            hint: Text("Jenis Kelamin di Objek Salah Nama"),
            value: jenKelSalah,
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
                jenKelSalah = val;
              });
            },
          )
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Alamat di Objek Salah Nama",
            ),
            controller: TextEditingController(text: alamatSalah),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => alamatSalah = val,
          ),
        ),
      ],
    );
  }
  
  Widget formKepMotor(){
    return Column(
      children: <Widget>[
        ListTile(
         leading: Icon(Icons.branding_watermark), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              helperText: "Nomor Polisi",
            ),
            controller: TextEditingController(text: nomorPolisi),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            // onSaved: (val) => nomorPolisi = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.local_offer), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Merk",
            ),
            controller: TextEditingController(text: merk),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => merk = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.category), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Tipe",
            ),
            controller: TextEditingController(text: tipe),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tipe = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.category), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Jenis",
            ),
            controller: TextEditingController(text: jenis),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => jenis = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.access_time), 
         title: TextFormField(
            maxLines: 1,
            maxLength: 4,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              helperText: "Tahun Pembuatan",
            ),
            controller: TextEditingController(text: tahunBuat),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tahunBuat = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.access_time), 
         title: TextFormField(
            maxLines: 1,
            maxLength: 4,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              helperText: "Tahun Perakitan",
            ),
            controller: TextEditingController(text: tahunRakit),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tahunRakit = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.invert_colors), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              helperText: "Isi Silinder",
            ),
            controller: TextEditingController(text: isiSilinder),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => isiSilinder = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.color_lens), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Warna",
            ),
            controller: TextEditingController(text: warnaKendaraan),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => warnaKendaraan = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.looks_3), 
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              helperText: "Nomor Rangka",
            ),
            controller: TextEditingController(text: nomorRangka),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => nomorRangka = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.looks_4),
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              helperText: "Nomor Mesin",
            ),
            controller: TextEditingController(text: nomorMesin),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => nomorMesin = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.looks_5),
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              helperText: "Nomor BPKB",
            ),
            controller: TextEditingController(text: nomorBPKB),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => nomorBPKB = val,
          )
        ),
        ListTile(
         leading: Icon(Icons.account_circle),
         title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Atas Nama BPKB",
            ),
            controller: TextEditingController(text: atasNamaBPKB),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => atasNamaBPKB = val,
          )
        ),
      ],
    );
  }

  void setData(){
    if(jenKel == null || kebangsaan == null || statNikah == null){
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: "Kolom pilihan tidak boleh kosong",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
      );
    }else{
      Map<String, Object> subData = {};

      Map<String,Object> data = {
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
        "tanggal_surat": "-",
        "atas_nama_ttd": "-",
        "jabatan_ttd": "-",
        "nip_ttd": "-"
      };

      switch (surat.tipeSurat) {
        case "Keterangan Berpergian":
          subData = {
            "daerah_keberadaan": daerahKeberadaan,
            "tahun_kepergian": tahunKepergian
          };

          data.addAll(subData);
          print(data);
          submitForm(data);
          break;
        case "Keterangan Kelakuan Baik" :
          submitForm(data);
        break;
        case "Keterangan Cerai":
          if(statCerai != null){
            subData = {
              "status_cerai": statCerai,
              "nama_pasangan": namaPasangan,
              "tahun_cerai": tahunCerai,
              "tempat_cerai": tempatCerai
            };

            data.addAll(subData);
            print(data);
            submitForm(data);
          }else{
            setState(() {
              isLoading = false;
            });

            Fluttertoast.showToast(
              msg: "Harap pilih status cerai",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
            );
          }

          break;
        case "Keterangan Kepemilikan Sepeda Motor":
          subData = {
            "tipe_surat": "Keterangan Kepemilikan Sepeda Motor",
            "nomor_polisi": nomorPolisi,
            "merk": merk,
            "tipe": tipe,
            "jenis": jenis,
            "tahun_pembuatan": tahunBuat,
            "tahun_perakitan": tahunRakit,
            "isi_silinder": isiSilinder,
            "warna": warnaKendaraan,
            "nomor_rangka": nomorRangka,
            "nomor_mesin": nomorMesin,
            "nomor_bpkb": nomorBPKB,
            "atas_nama_bpkb": atasNamaBPKB
          };

          data.addAll(subData);
          print(data);
          submitForm(data);

          break;
        case "Keterangan Bebas Pajak":
          subData = {
            "tipe_surat": "Keterangan Bebas Pajak",
            "objek_pajak": objekPajak
          };

          data.addAll(subData);
          print(data);
          submitForm(data);

          break;
        case "Keterangan Beda Nama":
          subData = {
            "tipe_surat": "Keterangan Beda Nama",
            "objek_salah_nama": objekSalahNama,
            "nama_objek_salah_nama": namaObjekSalahNama,
            "tanggal_lahir_objek_salah_nama": tanggalLahirSalah,
            "tempat_lahir_objek_salah_nama": tempatLahirSalah,
            "jenis_kelamin_objek_salah_nama": jenKelSalah,
            "alamat_objek_salah_nama": alamatSalah
          };

          data.addAll(subData);
          print(data);
          submitForm(data);

          break;
        case "Keterangan Kehilangan":
          subData = {
            "tipe_surat": "Keterangan Kehilangan",
            "objek_hilang": objekHilang,
            "tempat_hilang": tempatHilang,
            "tanggal_hilang": tanggalHilang
          };
          break;
        case "Keterangan Telah Menikah":
          String jenKelPas = "";

          if(jenKel == "L"){
            jenKelPas = "P";
          }else{
            jenKelPas = "L";
          }

          if(kebangsaanPasangan != null){
            subData = {
              "tipe_surat": "Keterangan Telah Menikah",
              "nama_pasangan": namaPasangan,
              "tanggal_lahir_pasangan": tanggalLahirPasangan,
              "tempat_lahir_pasangan": tempatLahirPasangan,
              "jenis_kelamin_pasangan": jenKelPas,
              "agama_pasangan": agamaPasangan,
              "kebangsaan_pasangan": kebangsaanPasangan,
              "pekerjaan_pasangan": pekerjaanPasangan,
              "alamat_pasangan": alamatPasangan,
              "tanggal_nikah": tanggalNikah,
              "tempat_nikah": tempatMenikah
            };

            data.addAll(subData);
            print(data);
            submitForm(data);

          }else{
            setState(() {
              isLoading = false;
            });

            Fluttertoast.showToast(
              msg: "Harap pilih kebangsaan pasangan",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
            );
          }
          break;
        case "Pertanggungjawaban Orang Tua":
          if(jenKelAnak != null && kebangsaanAnak != null && hubunganOrtu != null){
            Map<String, Object> subData = {
              "tipe_surat": "Pertanggungjawaban Orang Tua",
              "nama_anak": namaAnak,
              "tanggal_lahir_anak": tanggalLahirAnak,
              "tempat_lahir_anak": tempatLahirAnak,
              "jenis_kelamin_anak": jenKelAnak,
              "agama_anak": agamaAnak,
              "kebangsaan_anak": kebangsaanAnak,
              "pekerjaan_anak": pekerjaanAnak,
              "alamat_anak": alamatAnak,
              "jenis_kegiatan": jenisKegiatan,
              "nama_instansi_kegiatan": namaInstansiKegiatan,
              "alamat_instansi": alamatInstansi,
              "hubungan_ortu_dengan_anak": hubunganOrtu,
              "nama_kades": namaKades,
              "nama_desa": namaDesa,
              "nama_kadus": namaKadus,
              "nama_dusun": namaDusun
            };

            data.addAll(subData);
            print(data);
            submitForm(data);

          }else{
            setState(() {
              isLoading = false;
            });

            Fluttertoast.showToast(
              msg: "Kolom pilihan tidak boleh kosong",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
            );
          }
          break;
        default:
      }
    }
  }

  void submitForm(Map<String, Object> body) async{
    try{
      Map<String, Object> meta = {
        "id_surat" : surat.idSurat,
        "id_sub_surat" : suratRaw["id_sub_surat"],
        "tipe" : surat.tipeSurat
      };

      meta.addAll(body);

      String formURI = "https://www.terraciv.me/api/update_surat";

      Map<String,String> header = {
        "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
        "Content-Type": "application/x-www-form-urlencoded"};

      http.Response data = await http.post(formURI, body: meta, headers: header).timeout(
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

      print(data.body);

      if(data.statusCode == 200){
        Fluttertoast.showToast(
          msg: "Data Berhasil Disimpan",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );
        
        Navigator.pop(context, true);
      }else{
        Fluttertoast.showToast(
          msg: "Terjadi Kesalahan silahkan coba lagi",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );
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