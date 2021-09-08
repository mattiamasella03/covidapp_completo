import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  Future<void> addSurveyData(surveyData, String surveyId) async {
    await FirebaseFirestore.instance
        .collection("Survey")
        .doc(surveyId)
        .set(surveyData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addIdUser(String userid, String surveyId) async {
    await FirebaseFirestore.instance.collection("Survey").doc(surveyId).update(
      {
        'users': FieldValue.arrayUnion([userid]),
      },
    );
  }

  Future<void> RemoveUserId(String userid, String surveyId) async {
    await FirebaseFirestore.instance.collection("Survey").doc(surveyId).update(
      {
        'users': FieldValue.arrayRemove([userid]),
      },
    );
  }

  Future<void> RemoveUserData(String userid, String surveyId) async {
    await FirebaseFirestore.instance
        .collection("Survey")
        .doc(surveyId)
        .collection("Users")
        .doc(userid)
        .delete();
  }

  Future<void> addQuestionData(Map questionData, String surveyId) async {
    await FirebaseFirestore.instance
        .collection("Survey")
        .doc(surveyId)
        .collection("QND")
        .add(
          questionData,
        )
        .catchError((e) {
      print(e.toString());
    });
  }

  numberSurvey() async {
    return await FirebaseFirestore.instance.collection("Survey").get();
  }

  getSurveyzData() async {
    return await FirebaseFirestore.instance.collection("Survey").snapshots();
  }

  getUsersInfo() async {
    return await FirebaseFirestore.instance.collection("Users").get();
  }

  getSurveyData(String surveyId) async {
    return await FirebaseFirestore.instance
        .collection("Survey")
        .doc(surveyId)
        .collection("QND")
        .get();
  }

  getSurveyInfo(String surveyId) async {
    return await FirebaseFirestore.instance
        .collection("Survey")
        .doc(surveyId)
        .get();
  }

  getUserData(String surveyId) async {
    return await FirebaseFirestore.instance
        .collection("Survey")
        .doc(surveyId)
        .collection("Users")
        .get();
  }

  Future<void> addRegistrationData(
      Map RegistrationMap, String RegistrationId) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(RegistrationId)
        .set(RegistrationMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addAmazonWin(String userid, bool buono) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userid)
        .update({"Buono_Amazon": buono});
  }

  Future<void> NewVoucher(bool buono) async {
    Future<QuerySnapshot> docs =
        FirebaseFirestore.instance.collection("Users").get();
    docs.then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(element.id)
            .update({"Buono_Amazon": buono});
      });
    });
  }

  getAmazonWin(String userId) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .get();
  }

  Future<void> deleteSurvey(String surveyId) async {
    await FirebaseFirestore.instance
        .collection("Survey")
        .doc(surveyId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> deleteQND(String surveyid) async {
    Future<QuerySnapshot> qnds = FirebaseFirestore.instance
        .collection("Survey")
        .doc(surveyid)
        .collection("QND")
        .get();
    qnds.then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Survey")
            .doc(surveyid)
            .collection("QND")
            .doc(element.id)
            .delete()
            .then((value) => print("success"));
      });
    });
  }

  Future<void> deleteUsers(String surveyid) async {
    Future<QuerySnapshot> qnds = FirebaseFirestore.instance
        .collection("Survey")
        .doc(surveyid)
        .collection("Users")
        .get();
    qnds.then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Survey")
            .doc(surveyid)
            .collection("Users")
            .doc(element.id)
            .delete()
            .then((value) => print("success"));
      });
    });
  }

  Future<void> addAnswerData(
      String userid, String surveyId, String question, String answer) async {
    await FirebaseFirestore.instance
        .collection("Survey")
        .doc(surveyId)
        .collection("Users")
        .doc(userid)
        .set({question: answer}, SetOptions(merge: true));
  }

  Future<String> IdSession() async {
    final User user = await FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    return uid;
  }
}
