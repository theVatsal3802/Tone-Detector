import 'package:detect_tone/functions/detect_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = "/history";
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> data;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    data = DetectFunctions.getUserSearches(uid: user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          textScaleFactor: 1,
        ),
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    "Searched on: ${snapshot.data![index]["date"]}",
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expandedAlignment: Alignment.centerLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Sentence\n${snapshot.data![index]["text"]}",
                        textScaleFactor: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Prediction: ${snapshot.data![index]["prediction"]}",
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Search History",
                textScaleFactor: 1,
              ),
            );
          }
        },
      ),
    );
  }
}
