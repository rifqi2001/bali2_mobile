import 'package:bali_2/forgot_password.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bali_2/login_screen.dart';
import 'package:bali_2/register_screen.dart';
import 'package:bali_2/splash_screen.dart';
import 'package:bali_2/mainPage/bottom_bar.dart';
import 'package:bali_2/mainPage/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data == true) {
            return BottomBar();
          } else {
            return MyLoginScreen();
          }
        },
      ),
      routes: {
        'login': (context) => const MyLoginScreen(),
        'register': (context) => const MyRegisterScreen(),
        'splash': (context) => SplashScreen(),
        'bottom': (context) => const BottomBar(),
        'home': (context) => const HomePage(),
        'forgot': (context) => ForgotPasswordPage(),
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }
}

class Config {
  static const String baseUrl = 'http://192.168.1.200:80/api';
  // static const String baseUrl = 'http://beachgo-balongan.my.id/api';
}
