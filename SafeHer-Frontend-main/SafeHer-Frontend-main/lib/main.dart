import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeher/screens/login_screen.dart';

import 'theme/app_theme.dart';
import 'main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const SafeHerApp());
}

class SafeHerApp extends StatelessWidget {
  const SafeHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeHer AI',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home:  LoginScreen(),
    );
  }
}
