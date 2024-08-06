import 'dart:convert';
import 'package:bali_2/main.dart';
import 'package:bali_2/ticketPage/detail_ticket.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyTicketPage extends StatefulWidget {
  @override
  _MyTicketPageState createState() => _MyTicketPageState();
}

class _MyTicketPageState extends State<MyTicketPage> {
  bool _isLoading = true;
  List<dynamic> _tickets = [];

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchTickets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final String apiUrl = '${Config.baseUrl}/ticket';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _tickets = json.decode(response.body);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print("Failed to load tickets");
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Error fetching tickets: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiket Saya"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 181, 244, 255)))
          : ListView.builder(
              itemCount: _tickets.length,
              itemBuilder: (context, index) {
                final ticket = _tickets[index];
                final status = ticket['status'];
                Color bgColor;

                switch (status) {
                  case 'Belum Bayar':
                    bgColor = Color.fromARGB(255, 181, 244, 255);
                    break;
                  case 'aktif':
                    bgColor = Colors.green;
                    break;
                  case 'nonaktif':
                    bgColor = Colors.grey;
                    break;
                  default:
                    bgColor = Colors.transparent;
                }

                return Card(
                  color: bgColor,
                  child: ListTile(
                    title: Text("Tiket #${ticket['ticket_number']}"),
                    subtitle: Text(
                        "Tanggal Kunjungan: ${ticket['visit_date']}\nStatus: $status"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailsPage(
                            orderData: ticket,
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
