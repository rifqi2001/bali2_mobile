import 'package:bali_2/homePage/notification.dart';
import 'package:bali_2/main.dart';
import 'package:flutter/material.dart';
import 'package:bali_2/models/notification.dart'; // Sesuaikan dengan path model Notification jika diperlukan
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationDetailPage extends StatelessWidget {
  final NotificationModel notification;
  final Function
      onDelete; // Callback untuk menghapus notifikasi dari NotificationPage

  NotificationDetailPage({required this.notification, required this.onDelete});

  Future<void> _deleteNotification(BuildContext context, int id) async {
    final response = await http
        .delete(Uri.parse('${Config.baseUrl}/notifications/$id'));
    if (response.statusCode == 200) {
      onDelete(
          id); // Panggil callback untuk menghapus notifikasi dari NotificationPage
      Navigator.pop(context); // Kembali ke halaman sebelumnya
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Pesan berhasil dihapus.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Failed to delete'),
          content:
              Text('Failed to delete notification. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notification.title),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Konfirmasi'),
                  content: Text('Apakah Anda yakin ingin menghapus pesan ini?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Tidak'),
                      onPressed: () {
                        Navigator.pop(context); // Tutup dialog
                      },
                    ),
                    TextButton(
                      child: Text('Ya'),
                      onPressed: () {
                        _deleteNotification(
                            context, notification.id); // Panggil fungsi hapus
                      },
                    ),
                    Spacer()
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              notification.message,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
