import 'package:bali_2/homePage/detail_facilities.dart';
import 'package:bali_2/models/facility_card.dart';
import 'package:flutter/material.dart';

class Facilities extends StatefulWidget {
  const Facilities({super.key});

  @override
  _FacilitiesState createState() => _FacilitiesState();
}

class _FacilitiesState extends State<Facilities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fasilitas"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FacilityCard(
              imagePath: 'assets/images/taman_bermain1.png',
              facilityName: 'Taman Bermain Anak',
              description: 'Baca Selengkapnya ...',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacilityDetailPage(
                      facilityName: 'Taman Bermain Anak',
                      imagePaths: ['assets/images/taman_bermain1.png', 'assets/images/taman_bermain2.png', 'assets/images/taman_bermain3.png'],
                      description: 'Tempat bermain yang aman dan menyenangkan bagi anak-anak dengan permainan yang beragam.',
                      openHours: 'Malam Minggu',
                    ),
                  ),
                );
              },
            ),
            FacilityCard(
              imagePath: 'assets/images/aula1.png',
              facilityName: 'Aula',
              description: 'Baca Selengkapnya ...',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacilityDetailPage(
                      facilityName: 'Aula',
                      imagePaths: ['assets/images/aula1.png', 'assets/images/aula2.png'],
                      description: 'Tempat untuk melaksanakan kegiatan yang ada di Pantai Bali 2.\nDapat disewakan untuk acara tertentu ',
                      openHours: '-',
                    ),
                  ),
                );
              },
            ),
            FacilityCard(
              imagePath: 'assets/images/kamar_mandi2.png',
              facilityName: 'Kamar Mandi Bilas & Toilet',
              description: 'Baca Selengkapnya ...',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacilityDetailPage(
                      facilityName: 'Kamar Mandi Bilas & Toilet',
                      imagePaths: ['assets/images/kamar_mandi2.png', 'assets/images/kamar_mandi1.png', 'assets/images/toilet1.png'],
                      description: 'Tersedia kamar mandi bilas dan toilet di sekitaran pantai\nTidak dipungut biaya saat menggunakan fasilitas ini',
                      openHours: '-',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      )
    );
  }
}