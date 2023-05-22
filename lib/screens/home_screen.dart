import 'package:detect_tone/functions/auth_functions.dart';
import 'package:detect_tone/functions/detect_functions.dart';
import 'package:detect_tone/screens/auth_screen.dart';
import 'package:detect_tone/screens/history_screen.dart';
import 'package:detect_tone/utils/parse_functions.dart';
import 'package:detect_tone/widgets/emotion_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final textController = TextEditingController();
  bool isLoading = false;
  bool isPressed = false;
  bool isSaving = false;
  List<Map<String, dynamic>> data = [];
  List<double> values = [];

  void getListFromMap() {
    for (var element in data) {
      values.add(
        element['percent'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome to tone detector",
          textScaleFactor: 1,
        ),
        actions: [
          IconButton(
            tooltip: "See Previous Searches",
            onPressed: () {
              Navigator.of(context).pushNamed(HistoryScreen.routeName);
            },
            icon: const Icon(
              Icons.history,
            ),
          ),
          IconButton(
            tooltip: "Logout",
            onPressed: () async {
              await AuthFunctions.logout(context).then(
                (value) {
                  if (value) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AuthScreen.routeName,
                      (route) => false,
                    );
                  }
                },
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    key: const ValueKey("text"),
                    autocorrect: false,
                    controller: textController,
                    enableSuggestions: true,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 0.5,
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(
                        Icons.text_fields,
                      ),
                      labelText: "Enter your sentence",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter sentence";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (!isLoading)
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      data = [];
                      if (textController.text.isEmpty) {
                        ParseFunctions.showSnackbar(
                          text: "Please enter sentence before checking",
                          context: context,
                        );
                        return;
                      }
                      data = await DetectFunctions.getPrediction(
                          text: textController.text.trim());
                      getListFromMap();
                      setState(() {
                        isPressed = true;
                      });
                    },
                    child: const Text(
                      "Detect Tone",
                      textScaleFactor: 1,
                    ),
                  ),
                if (isLoading) const CircularProgressIndicator.adaptive(),
                if (isPressed && data.isEmpty)
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                if (isPressed && data.isNotEmpty)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Is this prediction correct?",
                              textScaleFactor: 1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    ParseFunctions.showSnackbar(
                                      text: "Feedback Saved, Thank you",
                                      context: context,
                                    );
                                    setState(() {
                                      isPressed = false;
                                      textController.text = "";
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.error,
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                  child: const Text(
                                    "No",
                                    textScaleFactor: 1,
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isSaving = true;
                                    });
                                    int max =
                                        (DetectFunctions.findMax(data: values) %
                                            5);
                                    Map<String, dynamic> prediction = data[max];
                                    String key = prediction["emotion"];
                                    await DetectFunctions.addCorrectPrediction(
                                      text: textController.text.trim(),
                                      prediction: key,
                                    ).then(
                                      (_) {
                                        ParseFunctions.showSnackbar(
                                          text: "Feedback Saved, Thank you",
                                          context: context,
                                        );
                                        setState(() {
                                          isSaving = false;
                                          isPressed = false;
                                          textController.text = "";
                                        });
                                      },
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  child: const Text(
                                    "Yes",
                                    textScaleFactor: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Here are the results",
                          textScaleFactor: 1,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      EmotionWidget(
                        text: data[2]["emotion"],
                        percent: data[2]["percent"],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      EmotionWidget(
                        text: data[3]["emotion"],
                        percent: data[3]["percent"],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      EmotionWidget(
                        text: data[0]["emotion"],
                        percent: data[0]["percent"],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      EmotionWidget(
                        text: data[1]["emotion"],
                        percent: data[1]["percent"],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      EmotionWidget(
                        text: data[4]["emotion"],
                        percent: data[4]["percent"],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (isSaving)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white70,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
        ],
      ),
    );
  }
}
