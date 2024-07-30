import 'package:flutter/material.dart';
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

  editNotes() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var reponse = await c.PostRequest(linkedit, {
        "title": title.text,
        "content": content.text,
        "id": widget.note['notes_id'].toString(),
      });
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
  void initState() {
    super.initState();
    title.text = widget.note['notes_title'];
    content.text = widget.note['notes_content'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit Note"),
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
                      height: 20,
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
