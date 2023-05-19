import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detect_tone/utils/parse_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetectFunctions {
  static Future<void> addCorrectPrediction({
    required String text,
    required String prediction,
    required bool isCorrect,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection("data").add(
      {
        "text": text,
        "prediction": prediction,
        "uid": user!.uid,
        "date": ParseFunctions.getDate(
          date: DateTime.now(),
        ),
        "isCorrect": isCorrect,
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getUserSearches(
      {required String uid}) async {
    final data = await FirebaseFirestore.instance
        .collection("data")
        .where(
          "uid",
          isEqualTo: uid,
        )
        .get();
    List<Map<String, dynamic>> result = [];
    for (var element in data.docs) {
      result.add(
        element.data(),
      );
    }
    return result;
  }

  static List<Map<String, dynamic>> getPrediction() {
    return [
      {
        "emotion": "Joy",
        "percent": 0.8,
      },
      {
        "emotion": "Anger",
        "percent": 0.4,
      },
      {
        "emotion": "Surprise",
        "percent": 0.75,
      },
      {
        "emotion": "Sadness",
        "percent": 0.35,
      },
      {
        "emotion": "Fear",
        "percent": 0.25,
      },
    ];
  }
}
