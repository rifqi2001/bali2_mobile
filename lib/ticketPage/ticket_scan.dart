import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TicketScan extends StatefulWidget {
  final Map<String, dynamic> orderData;
  const TicketScan({Key? key, required this.orderData}) : super(key: key);

  @override
  State<TicketScan> createState() => _TicketScanState();
}

class _TicketScanState extends State<TicketScan> {
  late String date;
  late String price;
  late String idNumber;
  late String qrData;
  late String status;
  late String ticket_adult;
  late String ticket_child;
  late String ticketNumber;
  String? username;
  // bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTicketData();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> user = json.decode(userJson);
      setState(() {
        username = user['name'];
      });
    }
  }

  Future<void> fetchTicketData() async {
    final orderData = widget.orderData;

    setState(() {
      // username = widget.username;
      idNumber = orderData['id']?.toString() ?? 'N/A';
      date = orderData['visit_date'] ?? 'N/A';
      price = orderData['total_price'].toString();
      qrData = orderData['ticket_number'].toString();
      ticketNumber = orderData['ticket_number'].toString();
      status = orderData['status'];
      ticket_adult = orderData['adult_ticket_count'].toString();
      ticket_child = orderData['child_ticket_count'].toString();
    });
  }

  Future<void> _refreshData() async {
    await fetchTicketData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Text("Tiket Masuk"),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Scan Kode QR tiket di loket"),
                  SizedBox(height: 5.0),
                  status == 'nonaktif'
                    ? Column(
                        children: [
                          Text(
                            "Tiket ini nonaktif dan tidak dapat discan",
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 20.0),
                          Icon(Icons.block, size: 100.0, color: Colors.red),
                        ],
                      )
                    : QrImageView(
                        data: 'http://beachgo-balongan.my.id/tickets/${widget.orderData['id']}',
                        embeddedImage: AssetImage('assets/images/bali2_logo.png'),
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                  SizedBox(height: 50.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Nama:"),
                      ),
                      Expanded(
                        child: Text("Nomor Tiket"),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text("$username"),
                      ),
                      Expanded(
                        child: Text(ticketNumber),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Tanggal"),
                      ),
                      Expanded(
                        child: Text("Harga"),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(date),
                      ),
                      Expanded(
                        child: Text(price),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Jumlah"),
                      ),
                      Expanded(
                        child: Text("Status Tiket"),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Dewasa: $ticket_adult\nAnak-anak: $ticket_child"),
                      ),
                      Expanded(
                        child: Text(status),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
