import 'package:flutter/material.dart';

InputField({
  required TextEditingController controller,
  required String hintText,
  bool isObscure = false,
}) {
  return Container(

    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        hintText: hintText,
        border: InputBorder.none,
      ),
      obscureText: isObscure,
    ),
  );
}