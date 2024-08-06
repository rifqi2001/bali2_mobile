import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class PaymentConfirmationPage extends StatefulWidget {
  final int orderId;
  const PaymentConfirmationPage({Key? key, required this.orderId})
      : super(key: key);
  @override
  _PaymentConfirmationPageState createState() =>
      _PaymentConfirmationPageState();
}

class _PaymentConfirmationPageState extends State<PaymentConfirmationPage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accountOwnerController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  DateTime? _transferDateController;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Tidak ada gambar dipilih.');
      }
    });
  }

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _transferDateController) {
      setState(() {
        _transferDateController = picked;
      });
    }
  }

  Future<void> _uploadPaymentConfirmation(BuildContext context) async {
    if (_image == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('token'); // Assuming the token is saved under 'token'

    if (token == null) {
      print("Token is null. Please check your SharedPreferences.");
      return;
    }

    var uri = Uri.parse(
        '${Config.baseUrl}/payment/confirm'); // Ubah URL sesuai dengan server Anda
    var request = http.MultipartRequest("POST", uri);

    // Menambahkan header ke request
    request.headers['Authorization'] = 'Bearer $token';

    // Menambahkan fields ke request
    request.fields['ticket_id'] = widget.orderId.toString();
    request.fields['transfer_date'] =
        DateFormat('yyyy-MM-dd').format(_transferDateController!);
    request.fields['bank_name'] = _bankNameController.text;
    request.fields['account_number'] = _accountNumberController.text;
    request.fields['account_owner'] = _accountOwnerController.text;
    request.fields['nominal'] = _nominalController.text;

    // Menambahkan file gambar ke request
    var stream = http.ByteStream(_image!.openRead());
    var length = await _image!.length();
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: _image!.path.split('/').last,
        contentType: MediaType('image', 'jpeg'));
    request.files.add(multipartFile);

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("Status code: ${response.statusCode}");
      print("Response body: $responseBody");

if (response.statusCode == 302) {
      // Handle redirect manually
      final location = response.headers['location'];
      if (location != null) {
        var newUri = Uri.parse(location);
        var newRequest = http.MultipartRequest("POST", newUri);
        newRequest.headers['Authorization'] = 'Bearer $token';
        newRequest.fields.addAll(request.fields);

        // Create new MultipartFile for the redirected request
        var redirectedStream = http.ByteStream(_image!.openRead());
        var redirectedLength = await _image!.length();
        var redirectedMultipartFile = http.MultipartFile(
          'image',
          redirectedStream,
          redirectedLength,
          filename: _image!.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
        newRequest.files.add(redirectedMultipartFile);

        response = await newRequest.send();
        responseBody = await response.stream.bytesToString();

        print("Redirected Status code: ${response.statusCode}");
        print("Redirected Response body: $responseBody");
      }
    } else if (response.statusCode == 200) {
      final respJson = json.decode(responseBody);
      print(respJson);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  'Bukti Pembayaran Telah Berhasil Dikirim. Harap Tunggu Admin untuk Mengaktifkan Tiket'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print("Failed to upload payment confirmation.");
        print("Status code: ${response.statusCode}");
        print("Response body: $responseBody");
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 240, 240),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 128, 187, 197),
        title: Text('Konfirmasi Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _bankNameController,
                decoration: InputDecoration(
                  labelText: 'Nama Bank/E-Money Anda',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Bank/E-Money tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Nomor Rekening Anda',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Rekening tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _accountOwnerController,
                decoration: InputDecoration(
                  labelText: 'Nama Pemilik Akun Rekening',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pemilik Akun Rekening tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                "Tanggal Anda men-transfer pembayaran:",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () => _selectedDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  child: Text(
                    _transferDateController == null
                        ? 'Pilih Tanggal'
                        : DateFormat('yyyy-MM-dd')
                            .format(_transferDateController!),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nominalController,
                decoration: InputDecoration(
                  labelText: 'Nominal Transfer',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal Transfer tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _image == null ? Text('No image selected.') : Image.file(_image!),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Bukti Transfer',
                    style:
                        TextStyle(color: Color.fromARGB(255, 128, 187, 197))),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _transferDateController != null) {
                    _uploadPaymentConfirmation(context);
                  } else {
                    print("Form validation failed");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Pastikan semua field terisi dengan benar dan gambar sudah dipilih.')),
                    );
                  }
                },
                child: Text('Konfirmasi Pembayaran',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 128, 187, 197),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
