import 'package:first_project/services/database.dart';
import 'package:first_project/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddQuestion extends StatefulWidget {
  final String Id;
  AddQuestion(this.Id);
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  String question, option1, option3, option2, option4;
  bool _isLoading = false;
  int numQ = 1;
  int QN = 0;
  DatabaseService databaseService = new DatabaseService();

  uploadQuestionData() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
      };

      await databaseService
          .addQuestionData(questionMap, widget.Id)
          .then((value) {
        setState(() {
          _isLoading = false;
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
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) => val.isEmpty ? "Enter Question" : null,
                      decoration: InputDecoration(
                        hintText: "Question $numQ",
                      ),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty ? "Enter Option1" : null,
                      decoration: InputDecoration(
                        hintText: "Option1",
                      ),
                      onChanged: (val) {
                        option1 = val;
                      },
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty ? "Enter Option2" : null,
                      decoration: InputDecoration(
                        hintText: "Option2",
                      ),
                      onChanged: (val) {
                        option2 = val;
                      },
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      validator: (val) => null,
                      decoration: InputDecoration(
                        hintText: "Option3",
                      ),
                      onChanged: (val) {
                        option3 = val;
                      },
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: blueButton(
                              context: context,
                              label: "Invia",
                              buttonWidth:
                                  MediaQuery.of(context).size.width / 2 - 36),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        GestureDetector(
                          onTap: () {
                            uploadQuestionData();
                            numQ = numQ + 1;
                          },
                          child: blueButton(
                              context: context,
                              label: "Aggiungi Domanda",
                              buttonWidth:
                                  MediaQuery.of(context).size.width / 2 - 36),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
