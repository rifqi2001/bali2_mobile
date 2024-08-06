import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Kami'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/about1.jpg',
              width: MediaQuery.of(context).size.width * 0.9,
            ),
            SizedBox(height: 20.0),
            Text(
              'Sejarah',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Pantai Balongan Indah 2 terletak di Jalan Raya Balongan, kecamatan Balongan, kabupaten Indramayu. Nama "Bali 2" sendiri berasal dari singkatan Balongan Indah, dimana angka 2 melambangkan blok ke 2 yang berada di daerah kecamatan Balongan, selain itu Bali 2 juga mengisyaratkan bahwa destinasi wisata Pantai Balongan Indah ini keindahannya serta kepopulerannya diharapkan bisa seperti Pantai-pantai yang ada di Bali.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            // Text(
            //   'Visi dan Misi',
            //   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 10.0),
            // Text(
            //   'Visi kami adalah...',
            //   textAlign: TextAlign.center,
            // ),
            // Text(
            //   'Misi kami adalah...',
            //   textAlign: TextAlign.center,
            // ),
            Text(
              'Informasi Harga Tiket',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Tiket Masuk : Rp.15.000,00',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Text(
              'Tiket Parkir Motor : Rp.2.000,00',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Text(
              'Tiket Parkir Mobil :  Rp.5.000,00',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              'Tim Pengembang',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Nama 1 - Mobile Developer',
              textAlign: TextAlign.center,
            ),
            Text(
              'Nama 2 - Web Developer',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              'Kontak',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: balongan@gmail.com',
              textAlign: TextAlign.center,
            ),
            Text(
              'Website: beachgo-balongan.my.id',
              textAlign: TextAlign.center,
            ),
            Text(
              'Telepon: +6287708513738',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
