import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/text_utils.dart';
import '../main.dart';
import '../mainPage/bottom_bar.dart'; // Sesuaikan dengan lokasi file BottomBar

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({Key? key}) : super(key: key);

  @override
  _MyLoginScreenState createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    // final String apiUrl = 'http://192.168.43.9:80/api/login';
    final String apiUrl = '${Config.baseUrl}/login';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['token'] != null && responseData['user'] != null) {
          print('Login Successful: ${responseData['token']}');

          // Simpan token dan data pengguna ke SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['token']);
          await prefs.setString('user', json.encode(responseData['user']));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomBar()),
          );
        } else {
          setState(() {
            errorMessage = 'Data pengguna tidak valid';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage =
              'Login gagal. Periksa kembali email dan kata sandi Anda.';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error login: $e');
      setState(() {
        errorMessage =
            'Terjadi kesalahan saat proses login. Silakan coba lagi.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/blue_bg2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 600,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Center(
                            child: TextUtil(
                              text: "Masuk",
                              weight: true,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          TextUtil(text: "Email", color: Colors.black),
                          Container(
                            height: 35,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.black45),
                              ),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                suffixIcon:
                                    Icon(Icons.mail, color: Colors.black45),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextUtil(text: "Kata Sandi", color: Colors.black),
                          Container(
                            height: 35,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.black45),
                              ),
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.black45),
                              decoration: const InputDecoration(
                                suffixIcon:
                                    Icon(Icons.lock, color: Colors.black45),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          if (errorMessage.isNotEmpty)
                            Center(
                              child: Text(
                                errorMessage,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          if (isLoading)
                            Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          const SizedBox(height: 20.0),
                          // Center(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Expanded(
                          //         child: Divider(
                          //           color: Colors.black45,
                          //           height: 1,
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding:
                          //             EdgeInsets.symmetric(horizontal: 8.0),
                          //         child: Text(
                          //           "atau lanjutkan dengan",
                          //           style: TextStyle(
                          //               fontSize: 10.0, color: Colors.black45),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Divider(
                          //           color: Colors.black45,
                          //           height: 1,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(height: 20.0),
                          // GestureDetector(
                          //   onTap: () {
                          //     // Handle klik tombol login with Google di sini
                          //   },
                          //   child: Container(
                          //     width: MediaQuery.of(context).size.width,
                          //     padding: EdgeInsets.symmetric(
                          //         vertical: 5, horizontal: 5),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(color: Colors.white),
                          //       borderRadius: BorderRadius.circular(5),
                          //     ),
                          //     child: Center(
                          //       child: Row(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           Icon(
                          //             FontAwesomeIcons.google,
                          //             size: 15,
                          //             color: Colors.red,
                          //           ),
                          //           SizedBox(width: 10),
                          //           Text(
                          //             'Masuk dengan akun Google',
                          //             style: TextStyle(fontSize: 12),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Container(
                                height: 15,
                                width: 15,
                                color: Colors.black45,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'forgot');
                                  },
                                  child: TextUtil(
                                    text: "Lupa Kata Sandi",
                                    size: 12,
                                    weight: true,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: login,
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              alignment: Alignment.center,
                              child: TextUtil(
                                text: "Masuk",
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, 'register');
                            },
                            child: Center(
                              child: Text(
                                "Belum punya akun? DAFTAR disini",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
