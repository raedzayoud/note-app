import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/app/components/crud.dart';
import 'package:note_app/app/components/customtextfield.dart';
import 'package:note_app/app/components/valid.dart';
import 'package:note_app/constant/linkapi.dart';
import 'package:note_app/main.dart';

class Edit extends StatefulWidget {
  final note;
  const Edit({super.key, this.note});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  Crud c = Crud();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  bool isLoading = false;
  File? file;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      title.text = widget.note['notes_title'] ?? '';
      content.text = widget.note['notes_content'] ?? '';
    }
  }

  editNotes() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response;
      if (file == null) {
        response = await c.PostRequest(linkedit, {
          "title": title.text,
          "content": content.text,
          "id": widget.note?['notes_id']?.toString() ?? "",
          "imagename": widget.note?['notes_image']?.toString() ?? "",
        });
      } else {
        response = await c.postRequestwithFile(
          linkedit,
          {
            "title": title.text,
            "content": content.text,
            "id": widget.note?['notes_id']?.toString() ?? "",
            "imagename": widget.note?['notes_image']?.toString() ?? "",
          },
          file!,
        );
      }

      isLoading = false;
      setState(() {});
      if (response["status"] == 'success') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("home", (context) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("There is a problem")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if widget.note is null and show an appropriate message or widget if it is.
    if (widget.note == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Edit Note"),
          centerTitle: true,
        ),
        body: Center(
          child: Text("No note data available"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit Note"),
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
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Image.asset("images/addnotes.png"),
                    ),
                    Container(
                      height: 50,
                    ),
                    CustomTextField(
                        hint: "title",
                        controller: title,
                        valid: (val) {
                          return validInput(val!, 1, 20);
                        }),
                    Container(
                      height: 20,
                    ),
                    CustomTextField(
                        hint: "content",
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
                                              if (image != null) {
                                                file = File(image.path);
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              }
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
                                              if (image != null) {
                                                file = File(image.path);
                                                setState(() {});
                                              }
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
                          await editNotes();
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
