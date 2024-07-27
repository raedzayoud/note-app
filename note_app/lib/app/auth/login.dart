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
  Login() async {
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
        Navigator.of(context).pushReplacementNamed("home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'there is a problem ! if you don t have an account create it '),
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
                              "Welcome Back",
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
                            hint: "Entrer Your Email",
                            controller: email),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          hint: "Entrer Your Password",
                          valid: (val) {
                            return validInput(val!, 3, 20);
                          },
                          controller: password,
                        ),
                       SizedBox(height: 20),
                        Container(
                          //argin: EdgeInsets.only(top: 90),
                          child: MaterialButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 100, vertical: 10),
                            onPressed: () async {
                              await Login();
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 20),
                            ),
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
                                  .pushReplacementNamed("signup");
                            },
                            child:
                                Text("Sign Up", style: TextStyle(fontSize: 20)),
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
