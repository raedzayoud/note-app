import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/app/components/crud.dart';
import 'package:note_app/app/components/customtextfield.dart';
import 'package:note_app/app/components/valid.dart';
import 'package:note_app/constant/linkapi.dart';
import 'package:note_app/main.dart';

class Edit extends StatefulWidget {
  final Map<String, dynamic>? note;
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
      title.text = widget.note?['notes_title'] ?? '';
      content.text = widget.note?['notes_content'] ?? '';
    }
  }

  Future<void> editNotes() async {
    if (formstate.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

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

      setState(() {
        isLoading = false;
      });

      if (response["status"] == 'success') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("home", (context) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("There is a problem")),
        );
      }
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Image.asset("images/addnotes.png"),
                    ),
                    SizedBox(height: 50),
                    CustomTextField(
                      hint: "Title",
                      controller: title,
                      valid: (val) {
                        return validInput(val!, 1, 20);
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      hint: "Content",
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
                            height: 150,
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
                                    await pickImage(ImageSource.gallery);
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
                                InkWell(
                                  onTap: () async {
                                    await pickImage(ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    child: Text(
                                      "From Camera",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      color: file == null ? Color.fromARGB(255, 104, 189, 108) : Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Choose Image",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () async {
                        await editNotes();
                      },
                      color: Color.fromARGB(255, 104, 189, 108),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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
