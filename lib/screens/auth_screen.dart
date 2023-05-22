import 'package:detect_tone/functions/auth_functions.dart';
import 'package:detect_tone/screens/verify_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './home_screen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RegExp email = RegExp(r"\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6}");
  RegExp password = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}");

  bool isLoading = false;
  bool isLogin = true;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? const HomeScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isLogin) ...[
                              TextFormField(
                                key: const ValueKey("name"),
                                autocorrect: true,
                                enableSuggestions: true,
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
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
                                    Icons.person,
                                  ),
                                  labelText: "Name",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter your name";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                            TextFormField(
                              key: const ValueKey("email"),
                              autocorrect: false,
                              enableSuggestions: false,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
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
                                  Icons.email,
                                ),
                                labelText: "Email",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your email";
                                } else if (!email
                                    .hasMatch(value.trim().toLowerCase())) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              key: const ValueKey("password"),
                              autocorrect: false,
                              controller: passwordController,
                              enableSuggestions: false,
                              obscureText: true,
                              textCapitalization: TextCapitalization.none,
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
                                  Icons.key,
                                ),
                                labelText: "Password",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter password";
                                } else if (!password.hasMatch(value.trim())) {
                                  return "Password must be between 8 to 15 characters and must contain atleast one uppercase, one lowercase and one digit.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (isLoading)
                              const CircularProgressIndicator.adaptive(),
                            if (!isLoading)
                              ElevatedButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  bool valid =
                                      _formKey.currentState!.validate();
                                  if (!valid) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  _formKey.currentState!.save();
                                  if (isLogin) {
                                    await AuthFunctions.login(
                                      context,
                                      emailController.text.trim().toLowerCase(),
                                      passwordController.text.trim(),
                                    ).then(
                                      (value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (value) {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            HomeScreen.routeName,
                                            (route) => false,
                                          );
                                        }
                                      },
                                    );
                                  } else {
                                    await AuthFunctions.signup(
                                      context,
                                      emailController.text.trim().toLowerCase(),
                                      passwordController.text.trim(),
                                      nameController.text.trim(),
                                    ).then(
                                      (value) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (value) {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            VerifyEmailScreen.routeName,
                                            (route) => false,
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                                child: Text(
                                  isLogin ? "Login" : "Sign Up",
                                  textScaleFactor: 1,
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                              child: Text(
                                isLogin
                                    ? "New here?\nSign up now"
                                    : "Already a member?\nLogin Instead",
                                textScaleFactor: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
