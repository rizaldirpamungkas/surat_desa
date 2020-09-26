import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'upload_prove.dart';

class NewLetter extends StatefulWidget {
  @override
  _NewLetterState createState() => _NewLetterState();
}

class _NewLetterState extends State<NewLetter> {
  final formKey = new GlobalKey<FormState>();

  String letterType = "Surat Baru";
  String letterCode = "ket_pergi";
  String idSurat = "";
  Widget form;

  bool isLoading = false;

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
  String hewan,
      umurHewan,
      warnaBulu,
      warnaEkor,
      tipeTanduk,
      warnaKaki,
      tandaLain;
  String alasanPemotongan;
  String pemberiWaris, keteranganPemberiWaris;

  @override
  void initState() {
    setPref();
    setForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return fullBody();
  }

  Widget fullBody() {
    return Stack(
      children: <Widget>[appBody(), loadingScreen()],
    );
  }

  Widget appBody() {
    return Scaffold(
      appBar: AppBar(
        title: Text(letterType),
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(headline6: TextStyle(fontSize: 20)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              validateAndSubmit();
            },
          )
        ],
      ),
      body: showForm(),
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

  Widget showForm() {
    return Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListView(
            children: [showFormChooseLet(), showFormGeneral(), form],
          ),
        ));
  }

  void setForm() {
    switch (letterCode) {
      case "ket_pergi":
        setState(() {
          letterType = "Keterangan Berpergian";
          form = formBerpergian();
        });
        break;

      case "ket_kelakuan":
        setState(() {
          letterType = "Keterangan Berkelakuan Baik";
          form = SizedBox.shrink();
        });
        break;

      case "ket_cerai":
        setState(() {
          letterType = "Keterangan Cerai";
          form = formKeteranganCerai();
        });
        break;

      case "kep_motor":
        setState(() {
          letterType = "Keterangan Kepemilikan Sepeda Motor";
          form = formKepMotor();
        });
        break;

      case "ket_pajak":
        setState(() {
          letterType = "Keterangan Bebas Pajak";
          form = formBebasPajak();
        });
        break;

      case "ket_bed_nama":
        setState(() {
          letterType = "Keterangan Beda Nama";
          form = formSalahNama();
        });
        break;

      case "ket_hilang":
        setState(() {
          letterType = "Keterangan Kehilangan";
          form = formKeteranganHilang();
        });
        break;

      case "ket_nikah":
        setState(() {
          letterType = "Keterangan Telah Menikah";
          form = formKeteranganNikah();
        });
        break;

      case "tang_ortu":
        setState(() {
          letterType = "Pertanggungjawaban Orang Tua";
          form = formTanggungJawabOrtu();
        });
        break;

      case "pot_hewan":
        setState(() {
          letterType = "Keterangan Pemotongan Hewan";
          form = formKeteranganPemotonganHewan();
        });
        break;

      case "li_waris":
        setState(() {
          letterType = "Keterangan Ahli Waris";
          form = formKeteranganAhliWaris();
        });
        break;

      default:
    }
  }

  Widget showFormChooseLet() {
    List<DropdownMenuItem> items;

    items = [
      DropdownMenuItem(
        value: "ket_pergi",
        child: Text("Keterangan Berpergian"),
      ),
      DropdownMenuItem(
        value: "ket_kelakuan",
        child: Text("Keterangan Berkelakuan Baik"),
      ),
      DropdownMenuItem(
        value: "ket_cerai",
        child: Text("Keterangan Cerai"),
      ),
      DropdownMenuItem(
        value: "kep_motor",
        child: Text("Keterangan Kepemilikan Sepeda Motor"),
      ),
      DropdownMenuItem(
        value: "ket_pajak",
        child: Text("Keterangan Bebas Pajak"),
      ),
      DropdownMenuItem(
        value: "ket_bed_nama",
        child: Text("Keterangan Beda Nama"),
      ),
      DropdownMenuItem(
        value: "ket_hilang",
        child: Text("Keterangan Kehilangan"),
      ),
      DropdownMenuItem(
        value: "ket_nikah",
        child: Text("Keterangan Telah Menikah"),
      ),
      DropdownMenuItem(
        value: "tang_ortu",
        child: Text("Pertanggungjawaban Orang Tua"),
      ),
      DropdownMenuItem(
        value: "pot_hewan",
        child: Text("Keterangan Pemotongan Hewan"),
      ),
      DropdownMenuItem(
        value: "li_waris",
        child: Text("Keterangan Ahli Waris"),
      ),
    ];

    return ListTile(
        leading: Icon(Icons.pageview),
        title: DropdownButton(
          isExpanded: true,
          hint: Text("Jenis Surat"),
          value: letterCode,
          items: items,
          onChanged: (val) {
            setState(() {
              letterCode = val;
              setForm();
            });
          },
        ));
  }

  void setPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString("namaWarga");
      tempatLahir = prefs.getString("tempatLahir");
      tanggalLahir = prefs.getString("tanggalLahir");
      agama = prefs.getString("agama");
      kebangsaan = prefs.getString("kebangsaan");
      statNikah = prefs.getString("statusPernikahan");
      pekerjaan = prefs.getString("pekerjaan");
      alamat = prefs.getString("alamat");
      jenKel = prefs.getString("jenisKelamin");
      nik = prefs.getString("nik");
      idWarga = prefs.getString("idWarga");
    });
  }

  Widget showFormGeneral() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: new TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(text: nama),
            decoration: InputDecoration(helperText: "Nama"),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => nama = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_city),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(text: tempatLahir),
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
            controller: TextEditingController(text: tanggalLahir),
            decoration: InputDecoration(helperText: "Tanggal Lahir"),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now().subtract(Duration(days: 360 * 18)),
                builder: (BuildContext buildContext, Widget child) {
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              ).then((val) {
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
            controller: TextEditingController(text: agama),
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
            onChanged: (val) {
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
            onChanged: (val) {
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
            controller: TextEditingController(text: pekerjaan),
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
            controller: TextEditingController(text: alamat),
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
              onChanged: (val) {
                setState(() {
                  jenKel = val;
                });
              },
            )),
        ListTile(
          leading: Icon(Icons.credit_card),
          title: TextFormField(
            keyboardType: TextInputType.number,
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            controller: TextEditingController(text: nik),
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

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() {
    setForm();

    FocusScope.of(context).unfocus();

    if (validateAndSave()) {
      setState(() {
        // errorMessage = "";
        isLoading = true;
      });
      print("OK");
      setGeneralData();
    }
  }

  Widget formKeteranganNikah() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: new TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(helperText: "Nama Pasangan"),
            controller: TextEditingController(text: namaPasangan),
            onChanged: (val) {
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
            onChanged: (val) {
              setState(() {
                tempatLahirPasangan = val;
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
            controller: TextEditingController(text: tanggalLahirPasangan),
            decoration: InputDecoration(helperText: "Tanggal Lahir Pasangan"),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now().subtract(Duration(days: 360 * 18)),
                builder: (BuildContext buildContext, Widget child) {
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              ).then((val) {
                setState(() {
                  tanggalLahirPasangan = DateFormat("yyyy-MM-dd").format(val);
                  setForm();
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
            onChanged: (val) {
              setState(() {
                agamaPasangan = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => agamaPasangan = val,
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
            onChanged: (val) {
              setState(() {
                kebangsaanPasangan = val;
                setForm();
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
            onChanged: (val) {
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
            onChanged: (val) {
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
            controller: TextEditingController(text: tanggalNikah),
            decoration: InputDecoration(helperText: "Tanggal Nikah"),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (BuildContext buildContext, Widget child) {
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              ).then((val) {
                setState(() {
                  tanggalNikah = DateFormat("yyyy-MM-dd").format(val);
                  setForm();
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
            onChanged: (val) {
              setState(() {
                tempatMenikah = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tempatMenikah = val,
          ),
        ),
      ],
    );
  }

  Widget formTanggungJawabOrtu() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: new TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(helperText: "Nama Anak"),
            controller: TextEditingController(text: namaAnak),
            onChanged: (val) {
              setState(() {
                namaAnak = val;
              });
            },
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
            onChanged: (val) {
              setState(() {
                tempatLahirAnak = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tempatLahirAnak = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.cake),
          title: TextFormField(
            readOnly: true,
            controller: TextEditingController(text: tanggalLahirAnak),
            decoration: InputDecoration(helperText: "Tanggal Lahir Anak"),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (BuildContext buildContext, Widget child) {
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              ).then((val) {
                setState(() {
                  tanggalLahirAnak = DateFormat("yyyy-MM-dd").format(val);
                  setForm();
                });
              });
            },
            onChanged: (val) {
              setState(() {
                tanggalLahirAnak = val;
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
              onChanged: (val) {
                setState(() {
                  jenKelAnak = val;
                  setForm();
                });
              },
            )),
        ListTile(
          leading: Icon(Icons.stars),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Agama Anak",
            ),
            controller: TextEditingController(text: agamaAnak),
            onChanged: (val) {
              setState(() {
                agamaAnak = val;
              });
            },
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
            onChanged: (val) {
              setState(() {
                kebangsaanAnak = val;
                setForm();
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
            onChanged: (val) {
              setState(() {
                pekerjaanAnak = val;
              });
            },
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
            onChanged: (val) {
              setState(() {
                alamatAnak = val;
              });
            },
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
            onChanged: (val) {
              setState(() {
                jenisKegiatan = val;
              });
            },
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
            onChanged: (val) {
              setState(() {
                namaInstansiKegiatan = val;
              });
            },
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
            onChanged: (val) {
              setState(() {
                alamatInstansi = val;
              });
            },
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
            onChanged: (val) {
              setState(() {
                hubunganOrtu = val;
                setForm();
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
            onChanged: (val) {
              setState(() {
                namaKades = val;
              });
            },
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
            onChanged: (val) {
              setState(() {
                namaDesa = val;
              });
            },
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
            onChanged: (val) {
              setState(() {
                namaDusun = val;
              });
            },
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
            onChanged: (val) {
              setState(() {
                namaKadus = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => namaKadus = val,
          ),
        ),
      ],
    );
  }

  Widget formBerpergian() {
    return Column(
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.map),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              controller: TextEditingController(text: daerahKeberadaan),
              onChanged: (val) {
                setState(() {
                  daerahKeberadaan = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => daerahKeberadaan = val,
              decoration: InputDecoration(
                helperText: "Daerah Keberadaan",
              ),
            )),
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
              onChanged: (val) {
                setState(() {
                  tahunKepergian = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => tahunKepergian = val,
            )),
      ],
    );
  }

  Widget formBebasPajak() {
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
              onChanged: (val) {
                setState(() {
                  objekPajak = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => objekPajak = val,
            )),
      ],
    );
  }

  Widget formKeteranganCerai() {
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
            onChanged: (val) {
              setState(() {
                statCerai = val;
                setForm();
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
              onChanged: (val) {
                setState(() {
                  namaPasangan = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => namaPasangan = val,
            )),
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
              onChanged: (val) {
                setState(() {
                  tahunCerai = val;
                });
              },
              validator: (val) =>
                  val.toString().isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => tahunCerai = val,
            )),
        ListTile(
            leading: Icon(Icons.map),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              controller: TextEditingController(text: tempatCerai),
              decoration: InputDecoration(
                helperText: "Tempat Cerai",
              ),
              onChanged: (val) {
                setState(() {
                  tempatCerai = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => tempatCerai = val,
            )),
      ],
    );
  }

  Widget formKeteranganHilang() {
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
              onChanged: (val) {
                setState(() {
                  objekHilang = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => objekHilang = val,
            )),
        ListTile(
            leading: Icon(Icons.map),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                helperText: "Tempat Hilang",
              ),
              controller: TextEditingController(text: tempatHilang),
              onChanged: (val) {
                setState(() {
                  tempatHilang = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => tempatHilang = val,
            )),
        ListTile(
          leading: Icon(Icons.calendar_today),
          title: TextFormField(
            readOnly: true,
            controller: TextEditingController(text: tanggalHilang),
            decoration: InputDecoration(helperText: "Tanggal Hilang"),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (BuildContext buildContext, Widget child) {
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              ).then((val) {
                setState(() {
                  tanggalHilang = DateFormat("yyyy-MM-dd").format(val);
                  setForm();
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

  Widget formSalahNama() {
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
              onChanged: (val) {
                setState(() {
                  objekSalahNama = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => objekSalahNama = val,
            )),
        ListTile(
            leading: Icon(Icons.account_circle),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                helperText: "Nama di Objek Salah Nama",
              ),
              controller: TextEditingController(text: namaObjekSalahNama),
              onChanged: (val) {
                setState(() {
                  namaObjekSalahNama = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => namaObjekSalahNama = val,
            )),
        ListTile(
          leading: Icon(Icons.cake),
          title: TextFormField(
            readOnly: true,
            controller: TextEditingController(text: tanggalLahirSalah),
            decoration: InputDecoration(
                helperText: "Tanggal Lahir di Objek Salah Nama"),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now().subtract(Duration(days: 360 * 18)),
                builder: (BuildContext buildContext, Widget child) {
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              ).then((val) {
                setState(() {
                  tanggalLahirSalah = DateFormat("yyyy-MM-dd").format(val);
                  setForm();
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
              onChanged: (val) {
                setState(() {
                  tempatLahirSalah = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => tempatLahirSalah = val,
            )),
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
              onChanged: (val) {
                setState(() {
                  jenKelSalah = val;
                  setForm();
                });
              },
            )),
        ListTile(
          leading: Icon(Icons.location_on),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Alamat di Objek Salah Nama",
            ),
            controller: TextEditingController(text: alamatSalah),
            onChanged: (val) {
              setState(() {
                alamatSalah = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => alamatSalah = val,
          ),
        ),
      ],
    );
  }

  Widget formKepMotor() {
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
              onChanged: (val) {
                setState(() {
                  nomorPolisi = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              // onSaved: (val) => nomorPolisi = val,
            )),
        ListTile(
            leading: Icon(Icons.local_offer),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                helperText: "Merk",
              ),
              controller: TextEditingController(text: merk),
              onChanged: (val) {
                setState(() {
                  merk = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => merk = val,
            )),
        ListTile(
            leading: Icon(Icons.category),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                helperText: "Tipe",
              ),
              controller: TextEditingController(text: tipe),
              onChanged: (val) {
                setState(() {
                  tipe = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => tipe = val,
            )),
        ListTile(
            leading: Icon(Icons.category),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                helperText: "Jenis",
              ),
              controller: TextEditingController(text: jenis),
              onChanged: (val) {
                setState(() {
                  jenis = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => jenis = val,
            )),
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
              onChanged: (val) {
                setState(() {
                  tahunBuat = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => tahunBuat = val,
            )),
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
              onChanged: (val) {
                setState(() {
                  tahunRakit = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => tahunRakit = val,
            )),
        ListTile(
            leading: Icon(Icons.invert_colors),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                helperText: "Isi Silinder",
              ),
              controller: TextEditingController(text: isiSilinder),
              onChanged: (val) {
                setState(() {
                  isiSilinder = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => isiSilinder = val,
            )),
        ListTile(
            leading: Icon(Icons.color_lens),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                helperText: "Warna",
              ),
              controller: TextEditingController(text: warnaKendaraan),
              onChanged: (val) {
                setState(() {
                  warnaKendaraan = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => warnaKendaraan = val,
            )),
        ListTile(
            leading: Icon(Icons.looks_3),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                helperText: "Nomor Rangka",
              ),
              controller: TextEditingController(text: nomorRangka),
              onChanged: (val) {
                setState(() {
                  nomorRangka = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => nomorRangka = val,
            )),
        ListTile(
            leading: Icon(Icons.looks_4),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                helperText: "Nomor Mesin",
              ),
              controller: TextEditingController(text: nomorMesin),
              onChanged: (val) {
                setState(() {
                  nomorMesin = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => nomorMesin = val,
            )),
        ListTile(
            leading: Icon(Icons.looks_5),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                helperText: "Nomor BPKB",
              ),
              controller: TextEditingController(text: nomorBPKB),
              onChanged: (val) {
                setState(() {
                  nomorBPKB = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => nomorBPKB = val,
            )),
        ListTile(
            leading: Icon(Icons.account_circle),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                helperText: "Atas Nama BPKB",
              ),
              controller: TextEditingController(text: atasNamaBPKB),
              onChanged: (val) {
                setState(() {
                  atasNamaBPKB = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => atasNamaBPKB = val,
            )),
      ],
    );
  }

  Widget formKeteranganPemotonganHewan() {
    return Column(
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.pets),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                helperText: "Hewan",
              ),
              controller: TextEditingController(text: hewan),
              onChanged: (val) {
                setState(() {
                  hewan = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => hewan = val,
            )),
        ListTile(
            leading: Icon(Icons.cake),
            title: TextFormField(
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                helperText: "Umur Hewan",
              ),
              controller: TextEditingController(text: umurHewan),
              onChanged: (val) {
                setState(() {
                  umurHewan = val;
                });
              },
              validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
              onSaved: (val) => umurHewan = val,
            )),
        ListTile(
          leading: Icon(Icons.color_lens),
          title: TextFormField(
            controller: TextEditingController(text: warnaBulu),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(helperText: "Warna Bulu"),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => warnaBulu = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.color_lens),
          title: TextFormField(
            controller: TextEditingController(text: warnaEkor),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(helperText: "Warna Ekor"),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => warnaEkor = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.color_lens),
          title: TextFormField(
            controller: TextEditingController(text: warnaKaki),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(helperText: "Warna Kaki"),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => warnaKaki = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.arrow_drop_up),
          title: TextFormField(
            controller: TextEditingController(text: tipeTanduk),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(helperText: "Tipe Tanduk"),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => tipeTanduk = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.album),
          title: TextFormField(
            controller: TextEditingController(text: tandaLain),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(helperText: "Tanda Lain"),
            onSaved: (val) => tandaLain = val,
          ),
        ),
        ListTile(
          leading: Icon(Icons.chat),
          title: TextFormField(
            controller: TextEditingController(text: alasanPemotongan),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(helperText: "Alasan Pemotongan"),
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => alasanPemotongan = val,
          ),
        ),
      ],
    );
  }

  Widget formKeteranganAhliWaris() {
    return Column(children: <Widget>[
      ListTile(
          leading: Icon(Icons.person),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Pemberi Waris",
            ),
            controller: TextEditingController(text: pemberiWaris),
            onChanged: (val) {
              setState(() {
                pemberiWaris = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => pemberiWaris = val,
          )),
      ListTile(
          leading: Icon(Icons.chat),
          title: TextFormField(
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              helperText: "Keterangan Pemberi Waris",
            ),
            controller: TextEditingController(text: keteranganPemberiWaris),
            onChanged: (val) {
              setState(() {
                keteranganPemberiWaris = val;
              });
            },
            validator: (val) => val.isEmpty ? "Kolom harus diisi" : null,
            onSaved: (val) => keteranganPemberiWaris = val,
          ))
    ]);
  }

  void setGeneralData() {
    if (jenKel == null || kebangsaan == null || statNikah == null) {
      Fluttertoast.showToast(
          msg: "Kolom pilihan tidak boleh kosong",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } else {
      Map<String, Object> data = {
        "id_pemohon": idWarga,
        "nomor_surat": "-",
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

      switch (letterCode) {
        case "ket_pergi":
          setFormBerpergian(data);
          break;
        case "ket_kelakuan":
          setFormKelakuanBaik(data);
          break;
        case "ket_cerai":
          setFormKetCerai(data);
          break;
        case "kep_motor":
          setFormKepMotor(data);
          break;
        case "ket_pajak":
          setFormBebasPajak(data);
          break;
        case "ket_bed_nama":
          setFormBedaNama(data);
          break;
        case "ket_hilang":
          setFormKehilangan(data);
          break;
        case "ket_nikah":
          setFormKetNikah(data);
          break;
        case "tang_ortu":
          setFormTangjabOrtu(data);
          break;
        case "pot_hewan":
          setFormPemotonganHewan(data);
          break;
        case "li_waris":
          setFormAhliWaris(data);
          break;
        default:
      }
    }
  }

  void setFormBerpergian(Map<String, Object> generalData) {
    Map<String, Object> subData = {
      "tipe_surat": "Keterangan Berpergian",
      "daerah_keberadaan": daerahKeberadaan,
      "tahun_kepergian": tahunKepergian
    };

    generalData.addAll(subData);
    // print(generalData);
    // setState(() {
    //   isLoading = false;
    // });
    String formURI = "https://www.terraciv.me/api/set_surat_keterangan_pergi";
    submitForm(generalData, formURI);
  }

  void setFormKelakuanBaik(Map<String, Object> generalData) {
    Map<String, Object> subData = {
      "tipe_surat": "Keterangan Kelakuan Baik",
    };

    generalData.addAll(subData);
    // print(generalData);
    // setState(() {
    //   isLoading = false;
    // });
    String formURI = "https://www.terraciv.me/api/set_surat_kelakuan_baik";
    submitForm(generalData, formURI);
  }

  void setFormKetCerai(Map<String, Object> generalData) {
    if (statCerai != null) {
      Map<String, Object> subData = {
        "tipe_surat": "Keterangan Cerai",
        "status_cerai": statCerai,
        "nama_pasangan": namaPasangan,
        "tahun_cerai": tahunCerai,
        "tempat_cerai": tempatCerai
      };

      generalData.addAll(subData);
      // print(generalData);
      // setState(() {
      //   isLoading = false;
      // });
      String formURI = "https://www.terraciv.me/api/set_surat_keterangan_cerai";
      submitForm(generalData, formURI);
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Harap pilih status cerai",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  void setFormKepMotor(Map<String, Object> generalData) {
    Map<String, Object> subData = {
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

    generalData.addAll(subData);
    // print(generalData);
    // setState(() {
    //   isLoading = false;
    // });
    String formURI = "https://www.terraciv.me/api/set_surat_keterangan_ksm";
    submitForm(generalData, formURI);
  }

  void setFormBebasPajak(Map<String, Object> generalData) {
    Map<String, Object> subData = {
      "tipe_surat": "Keterangan Bebas Pajak",
      "objek_pajak": objekPajak
    };

    generalData.addAll(subData);
    // print(generalData);
    // setState(() {
    //   isLoading = false;
    // });
    String formURI =
        "https://www.terraciv.me/api/set_surat_keterangan_bebas_pajak";
    submitForm(generalData, formURI);
  }

  void setFormBedaNama(Map<String, Object> generalData) {
    if (jenKelSalah != null) {
      Map<String, Object> subData = {
        "tipe_surat": "Keterangan Beda Nama",
        "objek_salah_nama": objekSalahNama,
        "nama_objek_salah_nama": namaObjekSalahNama,
        "tanggal_lahir_objek_salah_nama": tanggalLahirSalah,
        "tempat_lahir_objek_salah_nama": tempatLahirSalah,
        "jenis_kelamin_objek_salah_nama": jenKelSalah,
        "alamat_objek_salah_nama": alamatSalah
      };

      generalData.addAll(subData);
      // print(generalData);
      // setState(() {
      //   isLoading = false;
      // });
      String formURI =
          "https://www.terraciv.me/api/set_surat_keterangan_beda_nama";
      submitForm(generalData, formURI);
    } else {
      Fluttertoast.showToast(
          msg: "Harap pilih jenis kelamin di objek salah nama",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  void setFormKehilangan(Map<String, Object> generalData) {
    Map<String, Object> subData = {
      "tipe_surat": "Keterangan Kehilangan",
      "objek_hilang": objekHilang,
      "tempat_hilang": tempatHilang,
      "tanggal_hilang": tanggalHilang
    };

    generalData.addAll(subData);
    // print(generalData);
    // setState(() {
    //   isLoading = false;
    // });
    String formURI =
        "https://www.terraciv.me/api/set_surat_keterangan_kehilangan";
    submitForm(generalData, formURI);
  }

  void setFormKetNikah(Map<String, Object> generalData) {
    String jenKelPas = "";

    if (jenKel == "L") {
      jenKelPas = "P";
    } else {
      jenKelPas = "L";
    }

    if (kebangsaanPasangan != null) {
      Map<String, Object> subData = {
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

      generalData.addAll(subData);
      // print(generalData);
      // setState(() {
      //   isLoading = false;
      // });
      String formURI =
          "https://www.terraciv.me/api/set_surat_keterangan_telah_menikah";
      submitForm(generalData, formURI);
    } else {
      Fluttertoast.showToast(
          msg: "Harap pilih kebangsaan pasangan",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  void setFormTangjabOrtu(Map<String, Object> generalData) {
    if (jenKelAnak != null && kebangsaanAnak != null && hubunganOrtu != null) {
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

      generalData.addAll(subData);
      // print(generalData);
      // setState(() {
      //   isLoading = false;
      // });
      String formURI =
          "https://www.terraciv.me/api/set_surat_pertanggung_jawaban_ortu";
      submitForm(generalData, formURI);
    } else {
      Fluttertoast.showToast(
          msg: "Kolom pilihan tidak boleh kosong",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  void setFormPemotonganHewan(Map<String, Object> generalData) {
    Map<String, Object> subData = {
      "tipe_surat": "Keterangan Pemotongan Hewan",
      "hewan": hewan,
      "umur_hewan": umurHewan,
      "warna_bulu": warnaBulu,
      "warna_ekor": warnaEkor,
      "tipe_tanduk": tipeTanduk,
      "warna_kaki": warnaKaki,
      "tanda_lain": tandaLain,
      "alasan_pemotongan": alasanPemotongan
    };

    generalData.addAll(subData);
    // print(generalData);

    String formURI = "https://www.terraciv.me/api/set_surat_pemotongan_hewan";
    submitForm(generalData, formURI);
  }

  void setFormAhliWaris(Map<String, Object> generalData) {
    Map<String, Object> subData = {
      "tipe_surat": "Keterangan Ahli Waris",
      "pemberi_waris": pemberiWaris,
      "keterangan_pemberi_waris": keteranganPemberiWaris,
    };

    generalData.addAll(subData);
    // print(generalData);

    String formURI = "https://www.terraciv.me/api/set_surat_ahli_waris";
    submitForm(generalData, formURI);
  }

  void submitForm(Map<String, Object> body, String formURI) async {
    try {
      Map<String, String> header = {
        "x-api-key": "5baa441c93eaa4d6fb824dfc561a96d6",
        "Content-Type": "application/x-www-form-urlencoded"
      };
      http.Response data = await http
          .post(formURI, body: body, headers: header)
          .timeout(Duration(seconds: 300), onTimeout: () {
        isLoading = false;

        Fluttertoast.showToast(
            msg: "Timeout Koneksi",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);

        return null;
      });

      setState(() {
        isLoading = false;
      });

      if (data.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Data Berhasil Dikirim",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);

        Map<String, Object> response = jsonDecode(data.body);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UploadProve(idSurat: response["Ekstra"])));
      } else {}
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
