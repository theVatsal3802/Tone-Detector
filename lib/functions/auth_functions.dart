import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthFunctions {
  static Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      var msg = "Something went wrong";
      if (e.code == "invalid-email") {
        msg = "Invalid email";
      } else if (e.code == "user-not-found") {
        msg = "Account not found, Ask Admin to create one";
      } else if (e.code == "user-disabled") {
        msg = "Your account has been disabled by admin";
      } else if (e.code == "wrong-password") {
        msg = "Wrong password";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            textScaleFactor: 1,
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "OK",
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ),
      );
      return false;
    }
  }

  static Future<bool> signup(
    BuildContext context,
    String email,
    String password,
    String name,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      var msg = "Something went wrong";
      if (e.code == "invalid-email") {
        msg = "Invalid email";
      } else if (e.code == "email-already-in-use") {
        msg = "Email is already in use, try logging in.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            textScaleFactor: 1,
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "OK",
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ),
      );
      return false;
    }
  }

  static Future<bool> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Logout Failed, try again",
            textScaleFactor: 1,
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "OK",
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          ),
        ),
      );
      return false;
    }
  }
}
