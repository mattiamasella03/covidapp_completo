import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/helper/functions.dart';
import 'package:first_project/services/auth.dart';
import 'package:first_project/views/home.dart';
import 'package:first_project/views/home_admin.dart';
import 'package:first_project/views/win_amazon.dart';
import 'package:first_project/views/signup.dart';
import 'package:first_project/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

showAlertDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Errore"),
    content: Text("Inserire dati corretti"),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  String ad_email = 'admin@gmail.com';
  String ad_passw = 'admin1234';
  AuthService authService = new AuthService();
  bool _isLoading = false;

  SignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.signInEmailAndPass(email, password).then((val) {
        if (val != null) {
          setState(() {
            _isLoading = false;
          });
          Helper_functions.saveUserLoggedDetails(isLoggedin: true);
          if (email == ad_email && password == ad_passw) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeAdmin()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          }
        } else {
          setState(() {
            _isLoading = false;
            showAlertDialog(context);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: appBar(context),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty ? "Enter correct email" : null;
                      },
                      decoration: InputDecoration(hintText: "Email"),
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val) {
                        return val.isEmpty ? "Enter Password" : null;
                      },
                      decoration: InputDecoration(hintText: "Password"),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        SignIn();
                      },
                      child: blueButton(
                          context: context, label: "Accedi", buttonWidth: null),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Se non hai un account?   ",
                            style: TextStyle(
                              fontSize: 15.5,
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            "Registrati",
                            style: TextStyle(
                                fontSize: 15.5,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      'assets/images/covid.png',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
    );
    ;
  }
}
