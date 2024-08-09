import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/app/components/crud.dart';
import 'package:note_app/app/components/customtextfield.dart';
import 'package:note_app/app/components/valid.dart';
import 'package:note_app/constant/linkapi.dart';
import 'package:note_app/main.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  Crud c = Crud();
  File? file;
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  bool isLoading = false;

  Future<void> addNotes() async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image")),
      );
      return;
    }
    if (formstate.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      var response = await c.postRequestwithFile(
        linkadd,
        {
          "title": title.text,
          "content": content.text,
          "id": sharedPreferences.getString("id") ?? "",
        },
        file!,
      );

      setState(() {
        isLoading = false;
      });

      if (response["status"] == 'success') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("home", (context) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add note")),
        );
      }
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No image selected")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Add Note"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white,
              child: Form(
                key: formstate,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Image.asset("images/addnotes.png"),
                    ),
                    SizedBox(height: 50),
                    CustomTextField(
                      hint: "Enter Your Title",
                      controller: title,
                      valid: (val) {
                        return validInput(val!, 1, 20);
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      hint: "Enter Your Content of the note",
                      controller: content,
                      valid: (val) {
                        return validInput(val!, 10, 200);
                      },
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            height: 120,
                            child: Column(
                              children: [
                                Text(
                                  "Please Choose Image",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                SizedBox(height: 20),
                                InkWell(
                                  onTap: () async {
                                    await pickImage();
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: Text(
                                      "From Gallery",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                      color: file == null ? Color.fromARGB(255, 104, 189, 108) : Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Choose Image",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () async {
                        await addNotes();
                      },
                      color: Color.fromARGB(255, 104, 189, 108),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
