import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class ContentDetailPage extends StatelessWidget {
  final Map<String, dynamic> news;

  const ContentDetailPage({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (news['created_at'] != null) {
      DateTime date = DateTime.parse(news['created_at']);
      formattedDate = DateFormat.yMMMMd().format(date);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(news['title']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        imageUrl: 'http://beachgo-balongan.my.id${news['image']}',
                        // imageUrl: 'http://192.168.43.9:80${news['image']}',
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'imageHero',
                  child: Image.network('http://beachgo-balongan.my.id${news['image']}'),
                  // child: Image.network('http://192.168.43.9:80${news['image']}'),
                ),
              ),
              SizedBox(height: 10),
              Text(
                news['title'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(news['content']),
              SizedBox(height: 10),
              Text(
                'Dibuat pada: $formattedDate',
                style: TextStyle(color: Colors.grey, fontSize: 12.0), // Opsional: menambahkan gaya teks
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}