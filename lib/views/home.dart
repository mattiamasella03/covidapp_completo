import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:first_project/services/database.dart';
import 'package:first_project/views/answer_survey.dart';
import 'package:first_project/views/signin.dart';
import 'package:first_project/views/win_amazon.dart';
import 'package:first_project/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream surveyStream;
  bool surveyDone = false;

  DatabaseService databaseService = new DatabaseService();

  Widget surveyList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: surveyStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    surveyDone = snapshot.data.docs[index]
                        .data()['users']
                        .toString()
                        .contains(FirebaseAuth.instance.currentUser.uid);

                    return SurveyTitle(
                        imgUrl: snapshot.data.docs[index].data()["ImgURL"],
                        desc: snapshot.data.docs[index].data()["Desc"],
                        title: snapshot.data.docs[index].data()["Title"],
                        id: snapshot.data.docs[index].data()["Id"],
                        done: surveyDone);
                  });
        },
      ),
    );
  }

  showAlertDialogNome(BuildContext context, String nome) {
    // set up the AlertDialog
    FirebaseFirestore.instance.collection('Survey').get().then((snap) {
      int size = snap.size;

      FirebaseFirestore.instance
          .collection('Survey')
          .where('users', arrayContains: FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        int n_survey_done = value.size;
        int survey_notdone = size - n_survey_done;

        Widget WinButton = MaterialButton(
          child: Text(
            "RISCATTA IL TUO PREMIO",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..strokeWidth = 10
                ..color = Colors.orange[700],
            ),
          ),
          onPressed: () {
            databaseService.addAmazonWin(
                FirebaseAuth.instance.currentUser.uid, false);

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Results()));
          },
        );

        if (survey_notdone == 0) {
          databaseService
              .getAmazonWin(FirebaseAuth.instance.currentUser.uid)
              .then((value) {
            if (value['Buono_Amazon'] == true) {
              AlertDialog alert = AlertDialog(
                title: Text(
                  "Complimenti $nome hai completato tutti i sondaggi !!!",
                  textAlign: TextAlign.center,
                ),
                content:
                    /*Text("Hai completato tutti i sondaggi !!!",
                    textAlign: TextAlign.center),*/
                    Image.asset(
                  'assets/images/amazon.jpg',
                  fit: BoxFit.contain,
                ),
                actions: [WinButton],
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            } else {
              AlertDialog alert = AlertDialog(
                title: Image.asset(
                  'assets/images/stay.jpg',
                  fit: BoxFit.contain,
                ),
                /*Text(
                  "STAY TUNED",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )*/
                content: Text(
                    "Continua a seguirci per ricevere nuovi fantastici premi !!!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center),
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            }
            ;
          });
        } else {
          AlertDialog alert = AlertDialog(
            title: Text("Benvenuto $nome", textAlign: TextAlign.center),
            content: Text(
              "Hai ancora ${survey_notdone} sondaggi da fare ",
              textAlign: TextAlign.center,
            ),
          );

          // show the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        }
      });
    });
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((val) {
      showAlertDialogNome(context, val['Nome']);
    });

    databaseService.getSurveyzData().then((val) {
      surveyStream = val;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBar(context),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              },
            )
          ],
          brightness: Brightness.light,
        ),
        body: surveyList());
  }
}

ConfirmReplaySurvey({BuildContext context, String id}) {
  DatabaseService databaseService = new DatabaseService();

  Widget yesButton = MaterialButton(
    child: Text("Yes"),
    onPressed: () {
      databaseService.RemoveUserId(FirebaseAuth.instance.currentUser.uid, id);
      databaseService.RemoveUserData(FirebaseAuth.instance.currentUser.uid, id);

      Navigator.pop(context);
    },
  );
  Widget noButton = MaterialButton(
    child: Text("No"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("ConfirmDialog"),
    content: Text("Do you want to do the survey again?"),
    actions: [
      noButton,
      yesButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class SurveyTitle extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String id;
  final bool done;

  SurveyTitle({
    @required this.imgUrl,
    @required this.title,
    @required this.desc,
    @required this.id,
    @required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (done == true) {
          ConfirmReplaySurvey(context: context, id: id);
        }
      },
      onTap: () {
        if (done == false) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AnswerSurvey(id)));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imgUrl,
                  width: MediaQuery.of(context).size.width - 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/sondaggi.jpg',
                    width: MediaQuery.of(context).size.width - 48,
                    fit: BoxFit.cover,
                  ),
                )),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: done == true
                    ? Colors.black26.withOpacity(0.8)
                    : Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
