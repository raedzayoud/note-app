import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String ?Function(String?)valid;
  final bool obscureText;
  final TextInputType? keyboardType;


  CustomTextField({
    super.key,
    required this.hint,
    required this.controller, required this.valid, this.obscureText=false, this.keyboardType=TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        obscureText:obscureText ,
        keyboardType: keyboardType,
        validator: valid,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
