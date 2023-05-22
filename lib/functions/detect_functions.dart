import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detect_tone/utils/parse_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class DetectFunctions {
  static int findMax({required List<double> data}) {
    int index = 0;
    double value = 0;
    for (var element in data) {
      if (element > value) {
        index = data.indexOf(element);
        value = element;
      }
    }
    return index;
  }

  static Future<void> addCorrectPrediction({
    required String text,
    required String prediction,
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

  static Future<List<Map<String, dynamic>>> getPrediction(
      {required String text}) async {
    final url = Uri.parse("https://dpv.vercel.app?query=$text");
    final response = await http.get(url);
    final Map<String, dynamic> data = json.decode(response.body);
    List<Map<String, dynamic>> myMap = [];
    for (var element in data.keys) {
      myMap.add(
        {
          "emotion": element,
          "percent": data[element],
        },
      );
    }
    return myMap;
  }
}
