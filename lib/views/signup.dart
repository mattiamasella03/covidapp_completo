import 'package:first_project/helper/functions.dart';
import 'package:first_project/services/auth.dart';
import 'package:first_project/views/home.dart';
import 'package:first_project/views/signin.dart';
import 'package:first_project/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:first_project/services/database.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String email, password, nome, cognome, sesso, eta, id;
  DatabaseService databaseService = new DatabaseService();
  AuthService authService = new AuthService();
  bool _isLoading = false;

  uploadRegistrationData(String uid) async {
    id = uid;

    Map<String, String> RegistrationMap = {
      "Nome": nome,
      "Cognome": cognome,
      "Sesso": sesso,
      "Età": eta
    };

    await databaseService.addRegistrationData(RegistrationMap, id);
    await databaseService.addAmazonWin(id, true);
  }

  SignUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      authService.signUpWithEmailAndPassword(email, password).then((value) {
        if (value != null) {
          print(value.uid);
          setState(() {
            _isLoading = false;
          });
          uploadRegistrationData(value.uid);

          Helper_functions.saveUserLoggedDetails(isLoggedin: true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
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
        title: appBarRegistration(context),
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
                        return val.isEmpty ? "Enter Name" : null;
                      },
                      decoration: InputDecoration(hintText: "Name"),
                      onChanged: (val) {
                        nome = val;
                      },
                    ),
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty ? "Enter Surname" : null;
                      },
                      decoration: InputDecoration(hintText: "Surname"),
                      onChanged: (val) {
                        cognome = val;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton(
                        value: sesso,
                        items: [
                          DropdownMenuItem(
                            child: Text("Man"),
                            value: 'Uomo',
                          ),
                          DropdownMenuItem(
                            child: Text("Woman"),
                            value: 'Donna',
                          )
                        ],
                        onChanged: (val) {
                          sesso = val;
                          setState(() {
                            sesso = val;
                          });
                        },
                        hint: Text("Select sex")),
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty ? "Enter your age" : null;
                      },
                      decoration: InputDecoration(hintText: "Age"),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        eta = val;
                      },
                    ),
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
                          SignUp();
                        },
                        child: blueButton(
                            context: context,
                            label: "Iscriviti",
                            buttonWidth: null)),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Hai già un account?   ",
                            style: TextStyle(
                              fontSize: 15.5,
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                          child: Text(
                            "Accedi",
                            style: TextStyle(
                                fontSize: 15.5,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
    ;
  }
}
