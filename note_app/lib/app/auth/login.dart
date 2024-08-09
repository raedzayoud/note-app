import 'package:flutter/material.dart';
import 'package:note_app/app/components/crud.dart';
import 'package:note_app/app/components/customtextfield.dart';
import 'package:note_app/app/components/valid.dart';
import 'package:note_app/constant/linkapi.dart';
import 'package:note_app/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<void> login() async {
    if (_form.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await c.PostRequest(linkLogin, {
        "email": email.text,
        "password": password.text,
      });
      isLoading = false;
      setState(() {});
      if (response['status'] == 'success') {
        sharedPreferences.setString("id", response['data']['id'].toString());
        sharedPreferences.setString("username", response['data']['username']);
        sharedPreferences.setString("email", response['data']['email']);
        sharedPreferences.setString("age", response['data']['age'].toString());
        sharedPreferences.setString("adresse", response['data']['adresse']);
        sharedPreferences.setString("sexe", response['data']['sexe']);
        sharedPreferences.setString("image", response['data']['image']);
        Navigator.of(context).pushReplacementNamed("home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'There is a problem! If you don\'t have an account, create it.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey();
  bool isLoading = false;
  Crud c = Crud();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Welcome back to our App",
                      style: TextStyle(
                          color: Color.fromARGB(255, 171, 243, 174),
                          fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Transform.scale(
                    child: Image.asset("images/noteapp.jpg"),
                    scale: 0.8,
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        CustomTextField(
                          valid: (val) => validInput(val!, 3, 60),
                          hint: "Enter Your Email",
                          controller: email,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          obscureText: true,
                          hint: "Enter Your Password",
                          valid: (val) => validInput(val!, 3, 20),
                          controller: password,
                        ),
                        SizedBox(height: 20),
                        MaterialButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 10),
                          onPressed: login,
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20),
                          ),
                          color: Color.fromARGB(255, 171, 243, 174),
                          textColor: Colors.white,
                        ),
                        SizedBox(height: 10),
                        MaterialButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 90, vertical: 10),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed("signup");
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 20),
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
