import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Category extends StatelessWidget {
  final String imagePath;
  final String title;
  const Category({Key? key, required this.imagePath, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 128, 187, 197), borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Image.asset(
                  imagePath,
                  width: 35,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                maxLines: 1,
                style: TextStyle(
                    fontFamily: 'Santana', fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
