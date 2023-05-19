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
  List<Map<String, dynamic>> data = DetectFunctions.getPrediction();

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
                      if (textController.text.isEmpty) {
                        ParseFunctions.showSnackbar(
                          text: "Please enter sentence before checking",
                          context: context,
                        );
                        return;
                      }
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
                if (isPressed)
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
                                    setState(() {
                                      isSaving = true;
                                    });
                                    await DetectFunctions.addCorrectPrediction(
                                      text: textController.text.trim(),
                                      prediction: "Sadness",
                                      isCorrect: false,
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
                                    await DetectFunctions.addCorrectPrediction(
                                      text: textController.text.trim(),
                                      prediction: "Joy",
                                      isCorrect: true,
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
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: EmotionWidget(
                              text: data[index]["emotion"],
                              percent: data[index]["percent"],
                            ),
                          );
                        },
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
