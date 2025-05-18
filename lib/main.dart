import 'package:expence_tracker/feartures/login_screen/view_model/login_screen_view_model.dart';
import 'package:expence_tracker/feartures/registration_screen/view_model/registration_screen_view_model.dart';

import 'package:expence_tracker/feartures/splash_screen/view/splash_screen.dart';
import 'package:expence_tracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) => RegistrationScreenViewModel()),
      ChangeNotifierProvider(create: (context) => LoginScreenViewModel())
    ], child: MaterialApp(home: SplashScreen()));
  }
}
