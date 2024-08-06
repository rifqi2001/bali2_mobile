
import 'package:bali_2/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bali_2/models/notification.dart'; // Sesuaikan dengan path model Notification jika diperlukan
import 'package:bali_2/homePage/detail_notification.dart'; // Sesuaikan dengan path halaman detail notifikasi

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> _notifications = [];
  String _baseUrl = '${Config.baseUrl}';
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchNotifications();
  }

  Future<void> _loadUserIdAndFetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      Map<String, dynamic> user = json.decode(userString);
      setState(() {
        _userId = user['id'];
      });
      _fetchNotifications();
    }
  }

  Future<void> _fetchNotifications() async {
    if (_userId == null) return;
    final response = await http.get(Uri.parse('$_baseUrl/notifications/$_userId'));
    if (response.statusCode == 200) {
      List<dynamic> notificationsJson = json.decode(response.body);
      List<NotificationModel> notifications = notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();
      setState(() {
        _notifications = notifications;
      });
    } else {
      // Handle error
      print('Failed to load notifications');
    }
  }

  Future<void> _deleteNotification(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/notifications/$id'));
    if (response.statusCode == 200) {
      setState(() {
        _notifications.removeWhere((notification) => notification.id == id);
      });
    } else {
      // Handle error
      print('Failed to delete notification');
    }
  }

  void deleteNotificationFromList(int id) {
    setState(() {
      _notifications.removeWhere((notification) => notification.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan Notifikasi'),
      ),
      body: _notifications.isEmpty
          ? Center(child: Text('Belum ada notifikasi'))
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                      notification.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5),
                        Text(
                          notification.message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationDetailPage(
                            notification: notification,
                            onDelete: deleteNotificationFromList, // Callback untuk menghapus dari list
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
