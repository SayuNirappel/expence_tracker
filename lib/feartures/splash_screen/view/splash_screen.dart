import 'package:expence_tracker/feartures/home_screen/view/home_screen.dart';
import 'package:expence_tracker/feartures/login_screen/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isSplash = true;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      isSplash = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isSplash) {
      return const Scaffold(
        body: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "E",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 120,
                  color: Colors.red),
            ),
            Text(
              "Tracker",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                  color: Colors.deepPurple),
            )
          ],
        )),
      );
    } else {
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //snapshot is a passed parameter
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      );
    }
  }
}
