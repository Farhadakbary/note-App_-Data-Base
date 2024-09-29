import 'package:flutter/material.dart';
import 'package:noteapp2/noteapp_splashscreen.dart';
import 'package:noteapp2/setting.dart';
import 'package:noteapp2/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginpage.dart';
void main() {
  runApp(
    const MyApp(),
  );
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  double fontSize = 12.0;
  String language = 'English';
  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      fontSize = prefs.getDouble('fontSize') ?? 12.0;
      language = prefs.getString('language')?? 'English';
    });
  }

  void updateTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void updateFontSize(double value) {
    setState(() {
      fontSize = value;
    });
  }
  void updateFLanguage(String value) {
    setState(() {
      language = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/settings': (context) => SettingsPage(
              updateTheme: updateTheme,
              updateFontSize: updateFontSize,
            ),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/splash':(context)=>const SplashScreen()
      },
      home: const SplashScreen(),
    );
  }
}
