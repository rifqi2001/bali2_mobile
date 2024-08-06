import 'dart:convert';
import 'dart:ui';
import 'package:bali_2/login_screen.dart';
import 'package:bali_2/mainPage/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../utils/text_utils.dart';
import 'main.dart';

class MyRegisterScreen extends StatefulWidget {
  const MyRegisterScreen({Key? key}) : super(key: key);

  @override
  State<MyRegisterScreen> createState() => _MyRegisterScreen();
}

class _MyRegisterScreen extends State<MyRegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
      }),
    );

    if (response.statusCode == 201) {
      _showSuccessDialog();
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      String errorMessage =
          responseBody['message'] ?? 'Pendaftaran tidak berhasil';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registrasi Berhasil'),
          content: Text('Silahkan kembali untuk login.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyLoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blue_bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Container(
                height: 700,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: TextUtil(
                                text: "Daftar",
                                weight: true,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            const Spacer(),
                            TextUtil(text: "Email", color: Colors.black),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: TextFormField(
                                controller: _emailController,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.mail, color: Colors.black45),
                                  border: UnderlineInputBorder(),
                                  errorStyle: TextStyle(height: 0.8),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Silahkan masukkan email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Spacer(),
                            TextUtil(text: "Nama", color: Colors.black),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: TextFormField(
                                controller: _nameController,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.person, color: Colors.black45),
                                  border: UnderlineInputBorder(),
                                  errorStyle: TextStyle(height: 0.8),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Silahkan masukkan nama';
                                  } else if (value.length > 14) {
                                    return 'Nama maksimal 14 karakter';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Spacer(),
                            TextUtil(text: "Nomor Telepon", color: Colors.black),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: TextFormField(
                                controller: _phoneController,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.phone_android, color: Colors.black45),
                                  border: UnderlineInputBorder(),
                                  errorStyle: TextStyle(height: 0.8),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Silahkan masukkan nomor telepon';
                                  } else if (value.length < 11) {
                                    return 'Nama minimal 11 karakter';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Spacer(),
                            TextUtil(text: "Kata Sandi", color: Colors.black),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(_isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: UnderlineInputBorder(),
                                  errorStyle: TextStyle(height: 0.8)
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Silahkan masukkan kata sandi';
                                  } else if (value.length < 8) {
                                    return 'Kata sandi minimal memiliki 8 karakter';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Spacer(),
                            TextUtil(
                                text: "Konfirmasi Kata Sandi",
                                color: Colors.black),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: !_isPasswordVisible,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(_isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: UnderlineInputBorder(),
                                  errorStyle: TextStyle(height: 0.8)
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Silahkan konfirmasi kata sandi';
                                  } else if (value !=
                                      _passwordController.text) {
                                    return 'Kata sandi tidak sesuai';
                                  } else if (value.length < 8) {
                                    return 'Kata sandi minimal terdiri dari 8 karakter';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _register,
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: TextUtil(
                                  text: "Daftar",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, 'login');
                              },
                              child: Center(
                                child: Text(
                                  "Sudah punya akun? MASUK disini",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
