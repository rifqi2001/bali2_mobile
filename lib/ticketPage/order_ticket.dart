import 'dart:convert';

import 'package:bali_2/ticketPage/detail_ticket.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  DateTime? _selectedDate;
  int _adultTicketCount = 1;
  int _childTicketCount = 0;
  // int _ticketCount = 1;
  String _promoCode = '';
  double _totalPrice = 0.0;
  bool _isLoading = false;
  double _adultPrice = 0.0;
  double _childPrice = 0.0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _fetchTicketPrices();
      });
  }

  Future<void> _fetchTicketPrices() async {
    if (_selectedDate == null) return;

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          '${Config.baseUrl}/ticket/prices?date=${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _adultPrice = (data['adult_price'] as num).toDouble();
      _childPrice = (data['child_price'] as num).toDouble();
        _calculateTotalPrice();
      });
    } else {
      _showError('Gagal mengambil harga tiket.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _calculateTotalPrice() {
    _totalPrice =
        (_adultPrice * _adultTicketCount) + (_childPrice * _childTicketCount);
  }

  Future<void> _orderTicket() async {
    if (_selectedDate == null) {
      setState(() {
        _showError("Silahkan pilih tanggal kunjungan anda!");
      });
      return;
    }

    bool confirm = await _showConfirmationDialog();
    if (!confirm) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('token'); // Assuming the token is saved under 'token'

    final String apiUrl =
        '${Config.baseUrl}/ticket/create'; // Update with your API URL

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'visit_date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'adult_ticket_count': _adultTicketCount,
        'child_ticket_count': _childTicketCount,
        'promo_code': _promoCode,
        'total_price': _totalPrice,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

    if (responseData['id'] != null) {
      final orderData = {
        'id': responseData['id'],
        'visit_date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'adult_ticket_count': _adultTicketCount,
        'child_ticket_count': _childTicketCount,
        'promo_code': _promoCode,
        'total_price': _totalPrice,
        'ticket_number': responseData['ticket_number'],
        'status': responseData['status'],
      };
      _showSuccessMessage(orderData);
    } else {
      _showError('ID tidak ditemukan dalam respons API.');
    }
  } else {
    final errorData = json.decode(response.body);
    _showError(errorData['message'] ?? 'Booking failed. Please try again.');
  }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pesanan Gagal"),
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

  Future<bool> _showConfirmationDialog() async {
    _calculateTotalPrice();
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Pesanan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "Tanggal Kunjungan: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}"),
              Text("Jumlah Tiket Dewasa: $_adultTicketCount"),
              Text("Jumlah Tiket Anak-anak: $_childTicketCount"),
              Text("Total Harga: \Rp.${_totalPrice.toStringAsFixed(2)}"),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Batal"),
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
  }

  void _showSuccessMessage(Map<String, dynamic> ticket) {
    print("Ticket Data: $ticket"); // Tambahkan ini untuk memeriksa data tiket
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Berhasil!"),
          content: Text("Tiket Berhasil Dipesan!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketDetailsPage(orderData: ticket),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
        title: Text("Pemesanan Tiket"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Tanggal Kunjungan:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Pilih Tanggal'
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Jumlah Tiket Dewasa",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _adultTicketCount > 1
                            ? () {
                                setState(() {
                                  _adultTicketCount--;
                                });
                              }
                            : null,
                      ),
                      Text(
                        '$_adultTicketCount',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _adultTicketCount < 10
                            ? () {
                                setState(() {
                                  _adultTicketCount++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Jumlah Tiket Anak-anak:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _childTicketCount > 0
                            ? () {
                                setState(() {
                                  _childTicketCount--;
                                });
                              }
                            : null,
                      ),
                      Text(
                        '$_childTicketCount',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _childTicketCount < 10
                            ? () {
                                setState(() {
                                  _childTicketCount++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _promoCode = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan kode promo (opsional)',
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _orderTicket,
                      child:
                          Text("Cek Pesanan", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 128, 187, 197)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
