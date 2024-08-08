import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/app/components/crud.dart';
import 'package:note_app/app/components/customtextfield.dart';
import 'package:note_app/app/components/valid.dart';
import 'package:note_app/constant/linkapi.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController adresse = TextEditingController();
  String? gender;
  File? file;
  bool isLoading = false;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final Crud _c = Crud();

  Future<void> signup() async {
    if (_form.currentState!.validate()) {
      if (gender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a gender")),
        );
        return;
      }
      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an image")),
        );
        return;
      }
      setState(() {
        isLoading = true;
      });
      var response = await _c.postRequestwithFile(
        linkSignup,
        {
          "username": username.text,
          "email": email.text,
          "password": password.text,
          "age": age.text,
          "adresse": adresse.text,
          "gender": gender!,
        },
        file!,
      );
      setState(() {
        isLoading = false;
      });
      if (response['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("login");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to Insert Data")),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          file = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error picking image")),
      );
    }
  }

  Widget buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
            title: const Text("Male"),
            value: "Male",
            groupValue: gender,
            onChanged: (val) {
              setState(() {
                gender = val as String?;
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text("Female"),
            value: "Female",
            groupValue: gender,
            onChanged: (val) {
              setState(() {
                gender = val as String?;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildImagePickerButton() {
    return Container(
      width: 270,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: file == null ? Color.fromARGB(255, 171, 243, 174) : Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        child: const Text(
          "Choose Image",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              height: 150,
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "Please Choose an Image",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () async {
                      await _pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: const Text(
                        "From Gallery",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSignupButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 171, 243, 174)
      ),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
        onPressed: signup,
        child: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: ListView(
                children: [
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: const Text(
                            "Create your own Account",
                            style: TextStyle(color: Color.fromARGB(255, 171, 243, 174), fontSize: 27),
                          ),
                        ),
                        Transform.scale(
                          child: Image.asset("images/noteapp.jpg"),
                          scale: 0.8,
                        ),
                        CustomTextField(
                          valid: (val) {
                            return validInput(val!, 3, 20);
                          },
                          hint: "Enter Your Username",
                          controller: username,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          keyboardType: TextInputType.emailAddress,
                          valid: (val) {
                            return validInput(val!, 3, 60,isEmail: true);
                          },
                          hint: "Enter Your Email",
                          controller: email,
                          
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          keyboardType: TextInputType.number,
                          valid: (val) {
                            return validInput(val!, 1, 20);
                          },
                          hint: "Enter Your Age",
                          controller: age,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          valid: (val) {
                            return validInput(val!, 3, 20);
                          },
                          hint: "Enter Your Address",
                          controller: adresse,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(left: 25),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Gender",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        buildGenderSelector(),
                        CustomTextField(
                          valid: (val) {
                            return validInput(val!, 3, 20);
                          },
                          hint: "Enter Your Password",
                          controller: password,
                        ),
                        buildImagePickerButton(),
                        buildSignupButton(),
                        Container(
                          child: MaterialButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 90, vertical: 10),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed("login");
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
