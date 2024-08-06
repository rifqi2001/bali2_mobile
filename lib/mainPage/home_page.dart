import 'dart:convert';
import 'package:bali_2/homePage/detail_content.dart';
import 'package:bali_2/homePage/facilities.dart';
import 'package:bali_2/homePage/aboutUs.dart';
import 'package:bali_2/main.dart';
import 'package:bali_2/ticketPage/order_ticket.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bali_2/homePage/notification.dart';
import 'package:bali_2/models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;
  List<Map<String, dynamic>> newsData = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchNewsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> user = json.decode(userJson);
      if (mounted) {
        setState(() {
          username = user['name'];
        });
      }
    }
  }

  Future<void> _fetchNewsData() async {
    try {
      final response = await http.get(Uri.parse('${Config.baseUrl}/contents'));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            newsData = List<Map<String, dynamic>>.from(json.decode(response.body));
          });
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          print("Error fetching contents: $error");
        });
      }
    }
  }

  void _navigateToNewsDetail(Map<String, dynamic> news) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContentDetailPage(news: news)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 128, 187, 197),
        foregroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(
              'assets/images/bali2_logo.png',
              height: 30,
              // Ganti dengan path gambar logo Anda/ Sesuaikan dengan tinggi logo Anda
            ),
            Spacer(),
            Text(
              username != null ? "Halo, $username" : "Halo, Pengguna",
              style: TextStyle(fontSize: 20),
            ),
            Spacer(),
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationPage()),
                    );
                  },
                  icon: Icon(
                    Icons.notifications,
                    size: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Atur padding sesuai kebutuhan
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Konten & Berita",
                        style: TextStyle(
                          fontSize: 20, // Sesuaikan ukuran teks sesuai kebutuhan
                          fontWeight: FontWeight.bold, // Opsional: Atur gaya teks
                        ),
                      ),
                    ),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                      enlargeCenterPage: true,
                    ),
                    items: newsData.map((news) {
                      // final imageUrl = news['image'];
                      final imageUrl = 'http://beachgo-balongan.my.id/${news['image']}';
                      // final imageUrl = 'http://192.168.43.9:80/${news['image']}';
                      print('Image URL: $imageUrl');
                      return InkWell(
                        onTap: () => _navigateToNewsDetail(news),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 300,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    child: Center(
                                      child: Text(
                                        'Failed to load image',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black54,
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    news['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TicketPage(),
                                    ),
                                  );
                                },
                                child: Category(
                                  imagePath: "assets/icons/ticket.png",
                                  title: "Pesan Tiket",
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Facilities(),
                                    ),
                                  );
                                },
                                child: Category(
                                  imagePath: "assets/icons/beach_icons.png",
                                  title: "Fasilitas",
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AboutUsPage(),
                                    ),
                                  );
                                },
                                child: Category(
                                  imagePath: "assets/icons/about_us.png",
                                  title: "Tentang Kami",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // backgroundColor: const Color.fromARGB(255, 189, 234, 255),
    );
  }
}

