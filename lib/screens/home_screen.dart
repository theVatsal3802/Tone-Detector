import 'package:detect_tone/functions/auth_functions.dart';
import 'package:detect_tone/screens/auth_screen.dart';
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
      body: SingleChildScrollView(
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
                maxLines: 3,
                keyboardType: TextInputType.multiline,
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
                onPressed: () {
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
              FutureBuilder(
                future: null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return Column(
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
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                  ),
                                  child: const Text(
                                    "No",
                                    textScaleFactor: 1,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
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
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return const Padding(
                            padding: EdgeInsets.all(10),
                            child: EmotionWidget(
                              text: "Happy 😁",
                              percent: 0.8,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
