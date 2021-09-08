import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/models/models.dart';
import 'package:first_project/services/database.dart';
import 'package:first_project/views/home.dart';

import 'package:first_project/widgets/answer_survey_widgets.dart';
import 'package:first_project/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AnswerSurvey extends StatefulWidget {
  final String id;

  AnswerSurvey(this.id);
  @override
  _AnswerSurveyState createState() => _AnswerSurveyState();
}

/// Stream
Stream infoStream;

class _AnswerSurveyState extends State<AnswerSurvey> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot questionsSnapshot;

  bool isLoading = true;

  @override
  void initState() {
    print("${widget.id}");
    databaseService.getSurveyData(widget.id).then((value) {
      questionsSnapshot = value;

      isLoading = false;

      setState(() {});
    });

    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshots(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();
    questionModel.question = questionSnapshot["question"];
    questionModel.id = widget.id;
    print(questionModel.question);

    List<String> options = [
      questionSnapshot["option1"],
      questionSnapshot["option2"],
      questionSnapshot["option3"],
    ];

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];

    print(options[0]);
    print(options[1]);
    print(options[2]);

    questionModel.answeredA = false;
    questionModel.answeredB = false;
    questionModel.answeredC = false;

    return questionModel;
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    questionsSnapshot.docs == null
                        ? Container(
                            child: Center(
                              child: Text("No Data"),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            itemCount: questionsSnapshot.docs.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return AnswerSurveyTile(
                                questionmodel:
                                    getQuestionModelFromDatasnapshots(
                                        questionsSnapshot.docs[index]),
                                index: index,
                              );
                            }),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          databaseService.IdSession().then((value) {
            print('Userid $value');
            print(widget.id);
            databaseService.addIdUser(value, widget.id);

            //databaseService.addIdSurvey(value, widget.id);
          });

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
      ),
    );
  }
}

class AnswerSurveyTile extends StatefulWidget {
  final QuestionModel questionmodel;
  final int index;
  AnswerSurveyTile({this.questionmodel, this.index});
  @override
  _AnswerSurveyTileState createState() => _AnswerSurveyTileState();
}

class _AnswerSurveyTileState extends State<AnswerSurveyTile> {
  String optionSelected = "";
  DatabaseService databaseService = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q${widget.index + 1} ${widget.questionmodel.question}",
            style: TextStyle(fontSize: 17, color: Colors.black87),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              optionSelected = widget.questionmodel.option1;
              widget.questionmodel.answeredB = false;
              widget.questionmodel.answeredC = false;

              widget.questionmodel.answeredA = true;

              setState(() {});
              databaseService.addAnswerData(
                  FirebaseAuth.instance.currentUser.uid,
                  widget.questionmodel.id,
                  widget.questionmodel.question,
                  optionSelected);
            },
            child: OptionTile(
              description: widget.questionmodel.option1,
              option: "A",
              optionSelected: widget.questionmodel.answeredA,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              optionSelected = widget.questionmodel.option2;
              widget.questionmodel.answeredB = true;
              widget.questionmodel.answeredC = false;

              widget.questionmodel.answeredA = false;

              setState(() {});

              /* databaseService.IdSession().then((value) {
                databaseService.addAnswerData(value, widget.questionmodel.id,
                    widget.questionmodel.question, optionSelected);
              });*/
              // }
              databaseService.addAnswerData(
                  FirebaseAuth.instance.currentUser.uid,
                  widget.questionmodel.id,
                  widget.questionmodel.question,
                  optionSelected);
            },
            child: OptionTile(
              description: widget.questionmodel.option2,
              option: "B",
              optionSelected: widget.questionmodel.answeredB,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              optionSelected = widget.questionmodel.option3;
              widget.questionmodel.answeredB = false;
              widget.questionmodel.answeredC = true;

              widget.questionmodel.answeredA = false;

              setState(() {});
              databaseService.addAnswerData(
                  FirebaseAuth.instance.currentUser.uid,
                  widget.questionmodel.id,
                  widget.questionmodel.question,
                  optionSelected);
              // }
            },
            child: OptionTile(
              description: widget.questionmodel.option3,
              option: "C",
              optionSelected: widget.questionmodel.answeredC,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
