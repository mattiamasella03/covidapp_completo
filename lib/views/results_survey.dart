import 'package:charts_flutter/flutter.dart' as chart;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/services/database.dart';
import 'package:first_project/views/home_admin.dart';

import 'package:first_project/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultsSurvey extends StatefulWidget {
  final String id;

  ResultsSurvey(
    this.id,
  );

  @override
  _ResultsSurveyState createState() => _ResultsSurveyState();
}

/// Stream
Stream infoStream;

class _ResultsSurveyState extends State<ResultsSurvey> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot answersSnapshot;
  QuerySnapshot questionsSnapshot;
  QuerySnapshot usersSnapshot;

  DocumentSnapshot surveySnapshot;

  bool isLoading = true;

  Map<String, dynamic> results;
  Map<String, dynamic> results_sex;
  Map<String, dynamic> results_year;

  @override
  void initState() {
    results = new Map();

    databaseService.getSurveyInfo(widget.id).then((value) {
      surveySnapshot = value;

      setState(() {});
    });

    databaseService.getUsersInfo().then((value) {
      usersSnapshot = value;
      setState(() {});
    });

    databaseService.getSurveyData(widget.id).then((value) {
      questionsSnapshot = value;
      setState(() {});
    });

    databaseService.getUserData(widget.id).then((value) {
      answersSnapshot = value;
      isLoading = false;

      setState(() {});
    });

    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    super.initState();
  }

  List getYearInfo(QuerySnapshot usersSnapshot, DocumentSnapshot surveySnapshot,
      int min, int max) {
    List data = [];
    List year = [];
    List users = [];
    results_year = new Map();

    final Map<String, dynamic> survey =
        surveySnapshot.data() as Map<String, dynamic>;

    for (int i = 0; i < survey['users'].length; i++) {
      users.add(survey['users'][i]);
    }

    for (int j = 0; j < usersSnapshot.docs.length; j++) {
      if (users.contains(usersSnapshot.docs[j].id)) {
        if (int.parse(usersSnapshot.docs[j]["Età"]) >= min &&
            int.parse(usersSnapshot.docs[j]["Età"]) <= max) {
          year.add(usersSnapshot.docs[j].id);
        }
      }
    }

    for (int k = 0; k < answersSnapshot.docs.length; k++) {
      final Map<String, dynamic> doc =
          answersSnapshot.docs[k].data() as Map<String, dynamic>;

      if (year.contains(answersSnapshot.docs[k].id)) {
        for (int i = 0; i < doc.keys.length; i++) {
          String key = doc.keys.toList()[i];
          String value = doc.values.toList()[i];
          if (results_year.containsKey(key)) {
            List arr = results_year[key];

            arr.add(value);

            results_year.addAll({key: arr});
          } else {
            results_year.putIfAbsent(key, () => [value]);
          }
        }
        for (int z = 0; z < results_year.keys.length; z++) {
          String key = results_year.keys.toList()[z];
          List values = results_year.values.toList()[z];

          var map = Map();

          values.forEach((element) {
            if (!map.containsKey(element)) {
              map[element] = 1;
            } else {
              map[element] += 1;
            }
          });

          data.add([key, map]);
        }
      }
    }

    return data;
  }

  List getSexInfo(QuerySnapshot usersSnapshot, DocumentSnapshot surveySnapshot,
      String sex) {
    List data = [];
    List _sex = [];
    List users = [];
    results_sex = new Map();

    final Map<String, dynamic> survey =
        surveySnapshot.data() as Map<String, dynamic>;

    for (int i = 0; i < survey['users'].length; i++) {
      users.add(survey['users'][i]);
    }

    for (int j = 0; j < usersSnapshot.docs.length; j++) {
      if (users.contains(usersSnapshot.docs[j].id)) {
        if (usersSnapshot.docs[j]["Sesso"] == sex) {
          _sex.add(usersSnapshot.docs[j].id);
        }
      }
    }

    for (int k = 0; k < answersSnapshot.docs.length; k++) {
      final Map<String, dynamic> doc =
          answersSnapshot.docs[k].data() as Map<String, dynamic>;

      if (_sex.contains(answersSnapshot.docs[k].id)) {
        for (int i = 0; i < doc.keys.length; i++) {
          String key = doc.keys.toList()[i];
          String value = doc.values.toList()[i];
          if (results_sex.containsKey(key)) {
            List arr = results_sex[key];

            arr.add(value);

            results_sex.addAll({key: arr});
          } else {
            results_sex.putIfAbsent(key, () => [value]);
          }
        }
        for (int z = 0; z < results_sex.keys.length; z++) {
          String key = results_sex.keys.toList()[z];
          List values = results_sex.values.toList()[z];

          var map = Map();

          values.forEach((element) {
            if (!map.containsKey(element)) {
              map[element] = 1;
            } else {
              map[element] += 1;
            }
          });

          data.add([key, map]);
        }
      }
    }

    return data;
  }

  List getAnswersFromSnapshots(QuerySnapshot answerSnapshot) {
    List data = [];
    results = new Map();
    for (int j = 0; j < answerSnapshot.docs.length; j++) {
      final Map<String, dynamic> doc =
          answerSnapshot.docs[j].data() as Map<String, dynamic>;

      for (int i = 0; i < doc.keys.length; i++) {
        String key = doc.keys.toList()[i];
        String value = doc.values.toList()[i];
        if (results.containsKey(key)) {
          List arr = results[key];
          arr.add(value);

          results.addAll({key: arr});
        } else {
          results.putIfAbsent(key, () => [value]);
        }
      }
    }

    for (int z = 0; z < results.keys.length; z++) {
      String key = results.keys.toList()[z];
      List values = results.values.toList()[z];

      var map = Map();

      values.forEach((element) {
        if (!map.containsKey(element)) {
          map[element] = 1;
        } else {
          map[element] += 1;
        }
      });

      data.add([key, map]);
    }

    return data;
  }

  List dataForGraphic(QuerySnapshot answerSnapshot, int index) {
    List total_list = getAnswersFromSnapshots(answerSnapshot);

    List QND_list = [];

    for (int i = 0; i < questionsSnapshot.docs.length; i++) {
      final Map<String, dynamic> doc =
          questionsSnapshot.docs[i].data() as Map<String, dynamic>;
      QND_list.add(doc.values.first);
    }

    total_list = List.from(total_list)
      ..sort((a, b) => QND_list.indexOf(a[0]) - QND_list.indexOf(b[0]));

    List<ChartData> chartData = [];

    List question = [];
    List answers = [];

    for (int i = 0; i < total_list.length; i++) {
      question.add(total_list[i][0]);
      answers.add(total_list[i][1]);
    }

    Map type_ans = new Map();
    List keys = [];
    List list_key = [];
    List list_occorrenze = [];

    List occorrenze = [];
    type_ans.addAll(answers[index]);

    keys.add(type_ans.keys);
    occorrenze.add(type_ans.values);

    list_key = keys[0].toList();
    list_occorrenze = occorrenze[0].toList();

    for (int i = 0; i < list_key.length; i++) {
      chartData.add(ChartData(list_key[i], list_occorrenze[i]));
    }

    return chartData;
  }

  List DataForYear(QuerySnapshot answerSnapshot, int index, int min, int max) {
    List total_list = getYearInfo(usersSnapshot, surveySnapshot, min, max);
    List QND_list = [];

    for (int i = 0; i < questionsSnapshot.docs.length; i++) {
      final Map<String, dynamic> doc =
          questionsSnapshot.docs[i].data() as Map<String, dynamic>;
      QND_list.add(doc.values.first);
    }

    total_list = List.from(total_list)
      ..sort((a, b) => QND_list.indexOf(a[0]) - QND_list.indexOf(b[0]));

    List<ChartData> chartData = [];

    List question = [];
    List answers = [];

    for (int i = 0; i < total_list.length; i++) {
      question.add(total_list[i][0]);
      answers.add(total_list[i][1]);
    }

    Map type_ans = new Map();
    List keys = [];
    List list_key = [];
    List list_occorrenze = [];

    List occorrenze = [];
    type_ans.addAll(answers[index]);

    keys.add(type_ans.keys);
    occorrenze.add(type_ans.values);

    list_key = keys[0].toList();
    list_occorrenze = occorrenze[0].toList();

    for (int i = 0; i < list_key.length; i++) {
      chartData.add(ChartData(list_key[i], list_occorrenze[i]));
    }

    return chartData;
  }

  List DataForSex(QuerySnapshot answerSnapshot, int index, String sex) {
    List total_list = getSexInfo(usersSnapshot, surveySnapshot, sex);
    List QND_list = [];

    for (int i = 0; i < questionsSnapshot.docs.length; i++) {
      final Map<String, dynamic> doc =
          questionsSnapshot.docs[i].data() as Map<String, dynamic>;
      QND_list.add(doc.values.first);
    }

    total_list = List.from(total_list)
      ..sort((a, b) => QND_list.indexOf(a[0]) - QND_list.indexOf(b[0]));

    List<ChartData> chartData = [];

    List question = [];
    List answers = [];

    for (int i = 0; i < total_list.length; i++) {
      question.add(total_list[i][0]);
      answers.add(total_list[i][1]);
    }

    Map type_ans = new Map();
    List keys = [];
    List list_key = [];
    List list_occorrenze = [];

    List occorrenze = [];
    type_ans.addAll(answers[index]);

    keys.add(type_ans.keys);
    occorrenze.add(type_ans.values);

    list_key = keys[0].toList();
    list_occorrenze = occorrenze[0].toList();

    for (int i = 0; i < list_key.length; i++) {
      chartData.add(ChartData(list_key[i], list_occorrenze[i]));
    }

    return chartData;
  }

  _getSeriesData(int index) {
    var data = dataForGraphic(answersSnapshot, index);
    List<chart.Series<ChartData, String>> series = [
      chart.Series(
          id: "Grades",
          data: data,
          labelAccessorFn: (ChartData row, _) => '${row.x} : ${row.y}',
          domainFn: (ChartData grades, _) => grades.x,
          measureFn: (ChartData grades, _) => grades.y)
    ];

    return series;
  }

  _getBarData(int index) {
    var data = DataForSex(answersSnapshot, index, "Uomo");
    var data2 = DataForSex(answersSnapshot, index, "Donna");

    List<chart.Series<ChartData, String>> series = [
      chart.Series(
          id: "Uomo",
          data: data,
          domainFn: (ChartData grades, _) => grades.x,
          measureFn: (ChartData grades, _) => grades.y),
      chart.Series(
          colorFn: (_, __) => chart.MaterialPalette.pink.shadeDefault,
          id: "Donna",
          data: data2,
          domainFn: (ChartData grades, _) => grades.x,
          measureFn: (ChartData grades, _) => grades.y)
    ];

    return series;
  }

  _getYearData(int index) {
    var data = DataForYear(answersSnapshot, index, 0, 25);
    var data1 = DataForYear(answersSnapshot, index, 26, 30);
    var data2 = DataForYear(answersSnapshot, index, 0, 25);
    var data3 = DataForYear(answersSnapshot, index, 26, 30);
    var data4 = DataForYear(answersSnapshot, index, 0, 25);

    List<chart.Series<ChartData, String>> series = [
      chart.Series(
          id: "0-20",
          data: data,
          domainFn: (ChartData grades, _) => grades.x,
          measureFn: (ChartData grades, _) => grades.y),
      chart.Series(
          colorFn: (_, __) => chart.MaterialPalette.yellow.shadeDefault,
          id: "21-40",
          data: data1,
          domainFn: (ChartData grades, _) => grades.x,
          measureFn: (ChartData grades, _) => grades.y),
      chart.Series(
          colorFn: (_, __) => chart.MaterialPalette.red.shadeDefault,
          id: "41-60",
          data: data2,
          domainFn: (ChartData grades, _) => grades.x,
          measureFn: (ChartData grades, _) => grades.y),
      chart.Series(
          colorFn: (_, __) => chart.MaterialPalette.green.shadeDefault,
          id: "61-80",
          data: data3,
          domainFn: (ChartData grades, _) => grades.x,
          measureFn: (ChartData grades, _) => grades.y),
      chart.Series(
          colorFn: (_, __) => chart.MaterialPalette.gray.shadeDefault,
          id: "81-100",
          data: data4,
          domainFn: (ChartData grades, _) => grades.x,
          measureFn: (ChartData grades, _) => grades.y),
    ];

    return series;
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: appBarResults(context),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeAdmin()))),
          elevation: 0.0,
          brightness: Brightness.dark,
          bottom: TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.article),
              ),
              Tab(
                icon: Icon(Icons.family_restroom),
              ),
              Tab(
                icon: Icon(Icons.cake),
              ),
            ],
          ),
        ),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : TabBarView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text("\n RISULTATI RISPOSTE TOTALI",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            Expanded(
                              child: ListView.builder(
                                  itemExtent: 500,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: questionsSnapshot.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      child: new chart.PieChart(
                                        _getSeriesData(index),
                                        animate: true,
                                        behaviors: [
                                          new chart.ChartTitle(
                                              " \n\n\nQ${index + 1}: ${questionsSnapshot.docs[index].get("question").toString()}",
                                              titleStyleSpec:
                                                  chart.TextStyleSpec(
                                                      fontSize: 18),
                                              maxWidthStrategy: chart
                                                  .MaxWidthStrategy.truncate,
                                              behaviorPosition:
                                                  chart.BehaviorPosition.top,
                                              titleOutsideJustification: chart
                                                  .OutsideJustification
                                                  .startDrawArea,
                                              innerPadding: 35),
                                        ],
                                        defaultRenderer:
                                            new chart.ArcRendererConfig(
                                                arcWidth: 500,
                                                arcRendererDecorators: [
                                              new chart.ArcLabelDecorator()
                                            ]),
                                      ),
                                      height: 400,
                                      width: 400,
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                        Text("\n RISULTATI RISPOSTE IN BASE AL SESSO",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        Expanded(
                          child: ListView.builder(
                              itemExtent: 300,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: questionsSnapshot.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: new chart.BarChart(
                                    _getBarData(index),
                                    animate: true,
                                    barGroupingType:
                                        chart.BarGroupingType.grouped,
                                    primaryMeasureAxis: new chart
                                            .NumericAxisSpec(
                                        tickProviderSpec: new chart
                                                .BasicNumericTickProviderSpec(
                                            desiredTickCount: 3)),
                                    behaviors: [
                                      new chart.SeriesLegend(
                                        position: chart.BehaviorPosition.bottom,
                                        outsideJustification: chart
                                            .OutsideJustification.endDrawArea,
                                        horizontalFirst: true,
                                        desiredMaxRows: 4,
                                        entryTextStyle: chart.TextStyleSpec(
                                            color: chart.Color(
                                                r: 127, g: 63, b: 191),
                                            fontFamily: 'Georgia',
                                            fontSize: 15),
                                      ),
                                      new chart.ChartTitle(
                                          "Q${index + 1}: ${questionsSnapshot.docs[index].get("question").toString()}  \n",
                                          titleStyleSpec:
                                              chart.TextStyleSpec(fontSize: 18),
                                          maxWidthStrategy:
                                              chart.MaxWidthStrategy.truncate,
                                          behaviorPosition:
                                              chart.BehaviorPosition.top,
                                          titleOutsideJustification: chart
                                              .OutsideJustification
                                              .startDrawArea,
                                          innerPadding: 35,
                                          outerPadding: 75),
                                    ],
                                  ),
                                  height: 400,
                                  width: 400,
                                );
                              }),
                        ),
                        SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                        Text("\n RISULTATI RISPOSTE IN BASE ALL'ETA'",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        Expanded(
                          child: ListView.builder(
                              itemExtent: 450,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: questionsSnapshot.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: new chart.BarChart(
                                    _getYearData(index),
                                    animate: true,
                                    // vertical: true,
                                    barGroupingType:
                                        chart.BarGroupingType.grouped,
                                    primaryMeasureAxis: new chart
                                            .NumericAxisSpec(
                                        tickProviderSpec: new chart
                                                .BasicNumericTickProviderSpec(
                                            desiredTickCount: 3)),
                                    secondaryMeasureAxis: new chart
                                            .NumericAxisSpec(
                                        tickProviderSpec: new chart
                                                .BasicNumericTickProviderSpec(
                                            desiredTickCount: 5)),
                                    behaviors: [
                                      new chart.SeriesLegend(
                                        position: chart.BehaviorPosition.bottom,
                                        outsideJustification: chart
                                            .OutsideJustification.startDrawArea,
                                        horizontalFirst: true,
                                        entryTextStyle: chart.TextStyleSpec(
                                          fontSize: 14,
                                        ),
                                      ),
                                      new chart.ChartTitle(
                                          "\n\n\n Q${index + 1}: ${questionsSnapshot.docs[index].get("question").toString()}",
                                          titleStyleSpec:
                                              chart.TextStyleSpec(fontSize: 18),
                                          maxWidthStrategy:
                                              chart.MaxWidthStrategy.truncate,
                                          behaviorPosition:
                                              chart.BehaviorPosition.top,
                                          titleOutsideJustification: chart
                                              .OutsideJustification
                                              .startDrawArea,
                                          innerPadding: 70,
                                          outerPadding: 35),
                                    ],
                                  ),
                                  height: 400,
                                  width: 400,
                                );
                              }),
                        ),
                        SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final int y;
  final Color color;
}
