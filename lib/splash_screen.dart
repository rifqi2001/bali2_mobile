// import 'package:flutter/material.dart';

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({Key? key}) : super(key: key);
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//               const Spacer(),
//             Image.asset('assets/images/landing1.jpg'),
//             const SizedBox(height: 40),
//             const Text(
//               "Dapatkan Rekreasi Terbaik Anda!!",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Melalui aplikasi ini anda dapat merasakan rekreasi terbaik dan seputar informasi terkini di Pantai Balongan Indah II dengan cara yang simple dan praktis!",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.black54,
//               ),
//             ),
//             const Spacer(),
            
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamedAndRemoveUntil(context,'login',(route) => false);
//               },
//               style: ElevatedButton.styleFrom(
//                 shape: const StadiumBorder(),
//                 backgroundColor: Color.fromARGB(255, 128, 187, 197),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 15,
//                   horizontal: 10,
//                 ),
//               ),
//               child: const Text("Mulai Sekarang", style: TextStyle(color: Colors.white),),
//             )
//                   ],
//                 ),
//           )),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainPage/bottom_bar.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(Duration(seconds: 3)); // Delay for splash screen

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Change this to your desired background color
      body: Center(
        child: Image.asset('assets/images/bali2_logo.png', width: 150, height: 150), // Adjust size as needed
      ),
    );
  }
}
