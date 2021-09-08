import 'package:first_project/services/database.dart';
import 'package:first_project/views/addquestion.dart';
import 'package:first_project/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:validators/validators.dart';

import 'home_admin.dart';

class CreateSurvey extends StatefulWidget {
  @override
  _CreateSurveyState createState() => _CreateSurveyState();
}

class _CreateSurveyState extends State<CreateSurvey> {
  final _formKey = GlobalKey<FormState>();
  String ImageURL, Title, Descriptor, Id;

  DatabaseService databaseService = new DatabaseService();

  bool _isLoading = false;

  CreateSurveyOnline() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      Id = randomAlphaNumeric(16);

      Map<String, String> surveyMap = {
        "Id": Id,
        "ImgURL": ImageURL,
        "Title": Title,
        "Desc": Descriptor,
      };

      await databaseService.addSurveyData(surveyMap, Id).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddQuestion(Id)));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarAdmin(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeAdmin()))),
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
                    Image.asset(
                      'assets/images/Risultati.jpg',
                      fit: BoxFit.cover,
                    ),
                    Spacer(),
                    TextFormField(
                      validator: (val) => val.isEmpty
                          ? "Enter Image URL"
                          : !isURL(val)
                              ? "Enter correct Image URL "
                              : null,
                      decoration: InputDecoration(
                        hintText: "Image URL",
                      ),
                      onChanged: (val) {
                        ImageURL = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty ? "Enter Title" : null,
                      decoration: InputDecoration(
                        hintText: "Title",
                      ),
                      onChanged: (val) {
                        Title = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Enter Description" : null,
                      decoration: InputDecoration(
                        hintText: "Description",
                      ),
                      onChanged: (val) {
                        Descriptor = val;
                      },
                    ),
                    Spacer(),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            CreateSurveyOnline();
                          },
                          child: blueButton(
                              context: context,
                              label: "Crea Sondaggio",
                              buttonWidth: null)),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
