import 'package:flutter/material.dart';
import 'package:note_app/app/components/crud.dart';
import 'package:note_app/app/components/customtextfield.dart';
import 'package:note_app/app/components/valid.dart';
import 'package:note_app/constant/linkapi.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _Signup();
}

class _Signup extends State<Signup> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> _form = GlobalKey();
  Crud _c = Crud();
  sigup() async {
    if (_form.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await _c.PostRequest(linkSignup, {
        "username": username.text,
        "email": email.text,
        "password": password.text,
      });
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        Navigator.of(context).pushReplacementNamed("login");
      } else {
        print("Failed Insert Date");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Form(
                    key: _form,
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 40),
                            child: Text(
                              "Welcome Back \n       Sign up ",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 29),
                            )),
                        SizedBox(
                          height: 80,
                        ),
                        CustomTextField(
                            valid: (val) {
                              return validInput(val!, 3, 20);
                            },
                            hint: "Entrer Your Username",
                            controller: username),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                            valid: (val) {
                              return validInput(val!, 3, 20);
                            },
                            hint: "Entrer Your Email",
                            controller: email),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          valid: (val) {
                            return validInput(val!, 3, 20);
                          },
                          hint: "Entrer Your Password",
                          controller: password,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          //argin: EdgeInsets.only(top: 90),
                          child: MaterialButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 100, vertical: 10),
                            onPressed: () async {
                              await sigup();
                            },
                            child:
                                Text("Sign Up", style: TextStyle(fontSize: 20)),
                            color: Colors.blue,
                            textColor: Colors.white,
                          ),
                        ),
                        Container(
                          //argin: EdgeInsets.only(top: 90),
                          child: MaterialButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 90, vertical: 10),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed("login");
                            },
                            child:
                                Text("Login", style: TextStyle(fontSize: 20)),
                            //color: Colors.blue,
                            // textColor: Colors.white,
                          ),
                        )
                      ],
                    ))
              ],
            ),
    );
  }
}
