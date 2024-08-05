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

  addNotes() async {
    if (file == null) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please select an image")));
    }
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var reponse = await c.postRequestwithFile(
          linkadd,
          {
            "title": title.text,
            "content": content.text,
            "id": sharedPreferences.getString("id") ?? "",
          },
          file!);
      isLoading = false;
      setState(() {});
      if (reponse["status"] == 'success') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("home", (context) => false);
      } else {
        Navigator.of(context).pushNamed("addnote");
      }
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
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white,
              child: Form(
                key: formstate,
                child: ListView(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Image.asset("images/addnotes.png"),
                    ),
                    Container(
                      height: 50,
                    ),
                    CustomTextField(
                        hint: "Enter Your Title",
                        controller: title,
                        valid: (val) {
                          return validInput(val!, 1, 20);
                        }),
                    Container(
                      height: 20,
                    ),
                    CustomTextField(
                        hint: "Enter Your Content of the note ",
                        controller: content,
                        valid: (val) {
                          return validInput(val!, 10, 200);
                        }),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: file == null ? Colors.blue : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: MaterialButton(
                          child: Text(
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
                                          Text("Please Choose image",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)),
                                          Container(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              final ImagePicker picker =
                                                  ImagePicker();
// Pick an image.
                                              final XFile? image =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              file = File(image!.path);
                                              Navigator.of(context).pop();
                                              setState(() {});
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              child: Text(
                                                "from Gallery",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              final ImagePicker picker =
                                                  ImagePicker();
// Pick an image.
                                              final XFile? image =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              file = File(image!.path);
                                              setState(() {});
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              child: Text("from Camera",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: MaterialButton(
                        onPressed: () async {
                          await addNotes();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
