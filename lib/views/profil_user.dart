import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/services/database.dart';

import 'package:first_project/views/home_admin.dart';
import 'package:first_project/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot userSnapshot;
  QuerySnapshot surveySnapshot;

  void initState() {
    databaseService.getUsersInfo().then((val) {
      userSnapshot = val;
      setState(() {});
    });

    databaseService.numberSurvey().then((val) {
      surveySnapshot = val;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarAdmin(context),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeAdmin()));
            }),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Totali Utenti Registrati: ${userSnapshot.size}",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(
                  "Totali Sondaggi disponibili:  ${surveySnapshot.size}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Image.asset(
                'assets/images/stats.jpg',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
