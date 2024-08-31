import 'dart:convert';

import 'package:bali_2/mainPage/bottom_bar.dart';
import 'package:bali_2/ticketPage/payment_confirm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'ticket_scan.dart';
import 'package:clipboard/clipboard.dart';

class TicketDetailsPage extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const TicketDetailsPage({Key? key, required this.orderData})
      : super(key: key);

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  // String paymentDeadline = "N/A";
  String accountNumber = "1234567890";
  bool isPaid = false;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkPaymentStatus();
    
    if (widget.orderData['id'] == null ||
        widget.orderData['visit_date'] == null ||
        widget.orderData['adult_ticket_count'] == null ||
        widget.orderData['child_ticket_count'] == null ||
        widget.orderData['total_price'] == null ||
        widget.orderData['status'] == null) {
      print("Order Data is missing required fields!");
    } else {
      print("Order Data in TicketDetailsPage: ${widget.orderData}");
    }
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

  void _checkPaymentStatus() {
    print("Order Data Status: ${widget.orderData['status']}");
    setState(() {
      isPaid = widget.orderData['status'] == 'aktif' ||
          widget.orderData['status'] == 'nonaktif';
    });
  }

  void _openWhatsApp() async {
    // Nomor WhatsApp yang akan dihubungi
    String phoneNumber = "+62895334647071";
    var uri = Uri.parse('https://wa.me/$phoneNumber?text=HelloWorld');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Error');
      throw 'Error occured';
    }
  }

  Future<void> _confirmDelete() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Penghapusan"),
          content: Text("Apakah anda yakin ingin menghapus tiket ini?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed) {
      _deleteTicket();
    }
  }

  Future<void> _deleteTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('token'); // Assuming the token is saved under 'token'

    final String apiUrl =
        '${Config.baseUrl}/ticket/${widget.orderData['id']}'; // Update with your API URL

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomBar()),
        (Route<dynamic> route) => false,
      );
    } else {
      final errorData = json.decode(response.body);
      _showError(
          errorData['message'] ?? 'Failed to delete ticket. Please try again.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPaymentAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Informasi"),
          content: Text("Harap konfirmasi pembayaran terlebih dahulu."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _copyAccountNumber() {
    FlutterClipboard.copy(accountNumber).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nomor rekening disalin ke clipboard')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = widget.orderData;
    final status = orderData['status'];
    final visit_date = orderData['visit_date'];
    // final ticket_count = orderData['ticket_count'].toString();
    final adult_ticket_count = orderData['adult_ticket_count'].toString();
    final child_ticket_count = orderData['child_ticket_count'].toString();
    final total_price = orderData['total_price'].toString();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 240, 240),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 128, 187, 197),
        title: Row(
          children: [
            Text("Detail Pembayaran"),
          ],
        ),
        actions: [
          if (widget.orderData['status'] == 'belum bayar')
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _confirmDelete();
              },
            ),
          ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Pengguna:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text('Nama Pengguna: $username'),
            // SizedBox(height: 20.0),
            // Text(
            //   'Batas Waktu Pembayaran:',
            //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 5.0),
            // Text(paymentDeadline),
            Spacer(),
            Text(
              'Nomor Rekening Tujuan Pembayaran:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Text(accountNumber),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: _copyAccountNumber,
                ),
              ],
            ),
            Spacer(),
            Text(
              'Tanggal Kunjungan:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text(visit_date),
            Spacer(),
            Text(
              'Jumlah Tiket:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text("Dewasa = $adult_ticket_count"),
            Text("Anak-anak = $child_ticket_count"),
            Spacer(),
            Text(
              'Total Harga:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text("Rp.$total_price"),
            Spacer(),
            Text(
              'Status Pembayaran:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text(
              status == 'aktif' || status == 'nonaktif'
                  ? 'Sudah Bayar'
                  : 'Belum Bayar',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  backgroundColor: status == 'aktif' || status == 'nonaktif'
                      ? Colors.green
                      : Colors.red,
                  color: Colors.white),
            ),
            Spacer(),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "*Jika terjadi masalah hubungi:",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Card(
                elevation: 5.0,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                    icon: Icon(FontAwesomeIcons.whatsapp,
                        size: 35, color: Colors.white), // Icon untuk WhatsApp
                    onPressed: () {
                      _openWhatsApp();
                    }),
              ),
            ),
            Spacer(),
            Center(
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, 'payment_confirmation');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentConfirmationPage(orderId: orderData['id']),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Color.fromARGB(255, 128, 187, 197),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                    ),
                    child: const Text(
                      "Konfirmasi Pembayaran",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: isPaid
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TicketScan(orderData: orderData),
                              ),
                            );
                          }
                        : _showPaymentAlert,
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      // backgroundColor: Color.fromARGB(255, 128, 187, 197),
                      backgroundColor: isPaid
                          ? Color.fromARGB(255, 128, 187, 197)
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                    ),
                    child: const Text(
                      "Lihat Tiket",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
