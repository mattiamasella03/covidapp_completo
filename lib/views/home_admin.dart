import 'package:first_project/services/database.dart';
import 'package:first_project/views/new_survey.dart';
import 'package:first_project/views/profil_user.dart';
import 'package:first_project/views/results_survey.dart';
import 'package:first_project/views/signin.dart';
import 'package:first_project/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  Stream surveyStream;
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
                    return SurveyTitle(
                      imgUrl: snapshot.data.docs[index].data()["ImgURL"],
                      desc: snapshot.data.docs[index].data()["Desc"],
                      title: snapshot.data.docs[index].data()["Title"],
                      id: snapshot.data.docs[index].data()["Id"],
                    );
                  });
        },
      ),
    );
  }

  @override
  void initState() {
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
        title: appBarAdmin(context),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.people, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Profil()))),
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
              // do something
            },
          )
        ],
        brightness: Brightness.dark,
      ),
      body: surveyList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                databaseService.NewVoucher(true);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeAdmin()));
              },
              label: const Text('Eroga Buoni'),
              icon: const Icon(Icons.euro),
              backgroundColor: Colors.orange,
            ),
            FloatingActionButton.extended(
              label: const Text('Aggiungi Sondaggio'),
              icon: const Icon(Icons.add),
              heroTag: null,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateSurvey()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyTitle extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String id;
  bool confirmDel = false;
  DatabaseService databaseService = new DatabaseService();

  SurveyTitle(
      {@required this.imgUrl,
      @required this.title,
      @required this.desc,
      @required this.id});

  showConfirmDialog({BuildContext context}) {
    // set up the buttons

    Widget yesButton = MaterialButton(
      child: Text("Yes"),
      onPressed: () {
        databaseService.deleteUsers(id);
        databaseService.deleteQND(id);
        databaseService.deleteSurvey(id);

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
      content: Text("Would you like to delete this survey?"),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ResultsSurvey(id)));
      },
      onLongPress: () {
        showConfirmDialog(context: context);
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
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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
