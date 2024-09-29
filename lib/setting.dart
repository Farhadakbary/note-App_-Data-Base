import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget{
  final Function updateTheme;
  final Function updateFontSize;

  const SettingsPage(
      {super.key, required this.updateTheme, required this.updateFontSize,});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{

  bool isDarkMode = false;
  double fontSize = 12.0;
  String language = 'English';

  List <String> items = ['English', 'Dari', 'Duetch', 'Arabic'];

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }
  disposed(){
    super.dispose();
  }
  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      fontSize = prefs.getDouble('fontSize') ?? 12.0;
      language = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> saveThemePreference(bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  Future<void> saveFontSizePreference(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', value);
  }

  Future<void> saveFontStylePreference(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4B0082),
                  Color(0xFF1E90FF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
        ),
        title:  Text('Settings',style: TextStyle(fontSize: fontSize),),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient:  SweepGradient(
            colors: [
              Color(0xFF6A5ACD),
              Colors.white,
              Color(0xFF4169E1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text('Dark Mode', style: TextStyle(fontSize: fontSize)),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                        widget.updateTheme(isDarkMode);
                      });
                      saveThemePreference(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Font Size: ${fontSize.toStringAsFixed(1)}', style:  TextStyle(fontSize: fontSize)),
              Slider(
                value: fontSize,
                min: 12.0,
                max: 24.0,
                label: fontSize.toString(),
                onChanged: (value) {
                  setState(() {
                    fontSize = value;
                    widget.updateFontSize(fontSize);
                  });
                  saveFontSizePreference(value);
                },
              ),
              const SizedBox(height: 20),
               Text('Language', style: TextStyle(fontSize: fontSize)),
              DropdownButton(
                  hint: Text(language),
                  items: items.map<DropdownMenuItem<String>>(( item){
                    return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item));
                  }).toList(),
                  onChanged: (value){
                    setState(() {
                      language = value!;
                    });
                    saveFontStylePreference(value!);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}