import 'package:flutter/material.dart';
import 'package:note_app/constant/linkapi.dart';
import 'package:note_app/main.dart';

class Homeprofile extends StatefulWidget {
  const Homeprofile({super.key});

  @override
  State<Homeprofile> createState() => _HomeprofileState();
}

class _HomeprofileState extends State<Homeprofile> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController sexeController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fullnameController.text = sharedPreferences.getString("username") ?? '';
    emailController.text = sharedPreferences.getString("email") ?? '';
    adresseController.text = sharedPreferences.getString("adresse") ?? '';
    sexeController.text = sharedPreferences.getString("sexe") ?? '';
    ageController.text = sharedPreferences.getString("age") ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
          Navigator.of(context).pushReplacementNamed("home");
        },),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(
                  "${linkImageRoot}/${sharedPreferences.getString("image") ?? ''}",
                ),
                onBackgroundImageError: (_, __) => const Icon(Icons.error),
              ),
            ),
            SizedBox(height: 20),
            buildTextField("Full Name", fullnameController),
            buildTextField("Email", emailController),
            buildTextField("Adresse", adresseController),
            buildTextField("Gender", sexeController),
            buildTextField("Age", ageController),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter $label"),
          ),
        ],
      ),
    );
  }
}
