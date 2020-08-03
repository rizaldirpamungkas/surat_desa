import 'package:flutter/material.dart';
import 'package:surat_desa/logo.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return appBody();
  }

  Widget appBody(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Bantuan"),
        iconTheme: IconThemeData(
          color: Color(0xFF18D191)
        ),
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 20,
            color: Color(0xFF18D191)
          ),
        )
      ),
      body: Center(
        child: helpContent()
      )
    );
  }

  Widget helpContent(){
    return 
    Padding(
      padding: EdgeInsets.all(30),
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Logo(),
              SizedBox(height: 10),
              Text("E Desa Jenggala adalah aplikasi layanan surat menyurat yang disediakan oleh Desa Jenggala untuk memudahkan warga desa dalam urusan surat menyurat resmi di desa Jenggala", 
              textAlign: TextAlign.justify, 
              style: TextStyle(
                fontSize: 17,
              )),
              Text("Untuk memulai mengguanakan aplikasi warga desa harus mendaftarkan diri terlebih dahulu mlalui aplikasi dengan mengisi form yang disediakan dan juga menyediakan foto depan KTP untuk diverivikasi oleh admin, jika form pendaftaran telah dikirimkan oleh warga maka hal selanjutnya adalah menunggu verivikasi dari pihak desa jika akun sudah terverivikasi maka warga dapat mulai mengakses semua fitur aplikasi.",
              textAlign: TextAlign.justify, 
              style: TextStyle(
                fontSize: 17
              )),
              Text("Fitur pertama yang disediakan oleh aplikasi adalah surat baru disana warga dapat mengirim permintaan pembuatan surat berdasar jenis surat yang warga pilih, didalamnya warga hanya perlu mengisi data yang dibutuhkan lalu mengirimkan permintaan surat tersebut.",
              textAlign: TextAlign.justify, 
              style: TextStyle(
                fontSize: 17
              )),
              Text("Progress pembuatan surat dapat dilihat pada fitur riwayat surat saat warga baru mengirim surat maka status surat ada pada tahap belum dicetak pada tahap ini warga dapat mengubah/mengedit data perrmintaannya atau mebatalkan suratnya tapi jika status surat sudah ada pada status sudah dicetak yang akan dibarengi dengan notifikasi setiap surat selesai dicetak maka fungsi edit dan batal tidak dapat diakses, status terakhir sebuah surat adalah jika warga membatalkan permintaan surat maka status permintaan surat akan berubah menjadi dibatalkan.",
              textAlign: TextAlign.justify, 
              style: TextStyle(
                fontSize: 17
              )),
              Text("Tombol lonceng di sudut kanan atas layar beranda adalah tombol untuk menampilkan notifikasi atau riwayat notifikasi, terdapat pula fitur pengaturan yang meliputi perubahan data profil dari warga dan perubahan kata sandi.",
              textAlign: TextAlign.justify, 
              style: TextStyle(
                fontSize: 17
              )),
            ],
          ),
        ],
      )    
    );
  }
}


