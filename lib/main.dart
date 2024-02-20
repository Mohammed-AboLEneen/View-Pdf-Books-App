import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'cores/utils/shared_pre_helper.dart';
import 'features/login/presentation/view/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferenceHelper.initSharedPreference();
  await Hive.initFlutter();
  runApp(MaterialApp(
    title: 'Syncfusion PDF Viewer Demo',
    theme: ThemeData(
      useMaterial3: false,
    ),
    debugShowCheckedModeBanner: false,
    home: const LoginScreen(),
  ));
}
