import 'package:first_project/services/database.dart';

import 'package:first_project/views/home.dart';
import 'package:first_project/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  DatabaseService databaseService = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
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
              Image.asset(
                'assets/images/amazon.png',
                fit: BoxFit.cover,
              ),
              Text(
                "TI RINGRAZIAMO PER AVER COMPLETATO TUTTI I NOSTRI SONDAGGI",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "HAI VINTO UN BUONO AMAZON DEL VALORE DI 15 € ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    foreground: Paint()
                      ..style = PaintingStyle.fill
                      ..strokeWidth = 10
                      ..color = Colors.orange[700],
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "CODICE COUPON: \n KEMP-MK2V3H-54TCZM",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
