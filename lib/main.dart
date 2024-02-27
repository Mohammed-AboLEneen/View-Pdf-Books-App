import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'features/login/presentation/view/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    title: 'Syncfusion PDF Viewer Demo',
    theme: ThemeData(
      useMaterial3: false,
    ),
    debugShowCheckedModeBanner: false,
    home: const LoginScreen(),
  ));
}
