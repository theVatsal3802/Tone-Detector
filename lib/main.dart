import 'package:detect_tone/screens/auth_screen.dart';
import 'package:detect_tone/screens/home_screen.dart';
import 'package:detect_tone/screens/splash_screen.dart';
import 'package:detect_tone/screens/verify_email_screen.dart';
import 'package:detect_tone/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detect Tone',
      theme: theme(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          return const AuthScreen();
        },
      ),
      routes: {
        AuthScreen.routeName: (context) => const AuthScreen(),
        VerifyEmailScreen.routeName: (context) => const VerifyEmailScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
    );
  }
}
