import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:test_app/features/home_screen/presentation/view/home_screen.dart';
import 'cores/utils/shared_pre_helper.dart';
import 'features/login/presentation/view/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferenceHelper.initSharedPreference();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    title: 'Syncfusion PDF Viewer Demo',
    theme: ThemeData(
      useMaterial3: false,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomeScreen(),
  ));
}
