import 'package:bali_2/mainPage/my_ticket.dart';
import 'package:bali_2/mainPage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:bali_2/mainPage/home_page.dart';
// import 'package:bali_2/ticketPage/ticket_page.dart';
// import 'package:bali_2/mainPage/note_page.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

@override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 1;
  final List<Widget> body = [
    MyTicketPage(),
    HomePage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Color.fromARGB(255, 128, 187, 197),
        index: currentIndex,
        onTap: ontap,
        items: [
          CurvedNavigationBarItem(
            child: Icon(CupertinoIcons.tickets),
            label: 'Tiket',
          ),
          // CurvedNavigationBarItem(
          //   child: Icon(Icons.bookmark_add_outlined),
          //   label: 'Arsip',
          // ),
          CurvedNavigationBarItem(
            child: Icon(CupertinoIcons.home, color: Colors.white,),
            label: 'Beranda',
          ),
          // CurvedNavigationBarItem(
          //   child: Icon(Icons.history_toggle_off),
          //   label: 'Riwayat',
          // ),
          CurvedNavigationBarItem(
            child: Icon(CupertinoIcons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  void ontap(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
