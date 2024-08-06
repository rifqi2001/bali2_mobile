import 'dart:convert';
import 'dart:ui';
import 'package:bali_2/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String _message = '';
  bool _isLoading = false;

  Future<void> _sendResetLink() async {
    setState(() {
      _message = '';
      _isLoading = true;
    });

    final String apiUrl = '${Config.baseUrl}/forgot-password';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = 'Tautan setel ulang kata sandi dikirimkan ke email Anda';
          _isLoading = false;
        });
      } else {
        setState(() {
          _message = 'Failed to send reset password link';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error sending reset link: $e');
      setState(() {
        _message = 'Error occurred while sending reset link. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Color.fromARGB(255, 128, 187, 197),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Color.fromARGB(255, 230, 240, 240),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/icons/app_icon.png'), // path to profile image
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _sendResetLink,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 128, 187, 197),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Send Reset Link', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20.0),
            if (_message.isNotEmpty)
              Center(
                child: Text(
                  _message,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
