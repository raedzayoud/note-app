import 'package:flutter/material.dart';
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
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  bool isLoading = false;

  addNotes() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var reponse = await c.PostRequest(linkadd, {
        "title": title.text,
        "content": content.text,
        "id": sharedPreferences.getString("id") ?? "",
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
