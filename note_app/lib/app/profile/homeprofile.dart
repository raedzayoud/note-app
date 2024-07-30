import 'package:flutter/material.dart';

class Homeprofile extends StatefulWidget {
  const Homeprofile({super.key});

  @override
  State<Homeprofile> createState() => _HomeprofileState();
}

class _HomeprofileState extends State<Homeprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Profile"),
      actions: [],),
    );
  }
}