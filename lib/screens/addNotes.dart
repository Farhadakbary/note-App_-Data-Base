import 'dart:async';
import 'package:flutter/material.dart';
import '../database/databaseHelper.dart';
import '../class/note.dart';

class AddNotePage extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  const AddNotePage(this.note, this.appBarTitle, {super.key});

  @override
  State<StatefulWidget> createState() =>
      _AddNotePageState(this.note, this.appBarTitle);
}

class _AddNotePageState extends State<AddNotePage> {
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;
  _AddNotePageState(this.note, this.appBarTitle);

  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _formattedDate = '';
  String? _formattedTime = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
  }

  @override
  Widget build(BuildContext context) {
    _topicController.text = note.title;
    _descriptionController.text = note.description;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: SweepGradient(
          colors: [
            Color(0xFF6A5ACD),
            Colors.white,
            Color(0xFF4169E1),
          ],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text(appBarTitle),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple,
                      Color(0xFF00C6FF),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _topicController,
                      decoration: const InputDecoration(labelText: 'Topic'),
                      onChanged: (value) {
                        setState(() {
                          note.title = _topicController.text;
                        });
                      },
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      onChanged: (value) {
                        setState(() {
                          note.description = _descriptionController.text;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_topicController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.grey[400],
                            content: const Text(
                                'The topic and the description can\'t be empty',
                                style: TextStyle(color: Colors.black)),
                          ));
                        } else if (_descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.grey[400],
                            content: const Text(
                                'The topic and the description can\'t be empty',
                                style: TextStyle(color: Colors.black)),
                          ));
                        } else {
                          saveNote();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateDateTime() {
    Timer.periodic(const Duration(seconds: 0), (Timer t) {
      final now = DateTime.now();
      setState(() {
        _formattedDate = '${now.year}-${now.month}-${now.day}';
        _formattedTime = '${now.hour}:${now.minute}:${now.second}';
      });
    });
  }

  void saveNote() async {
    note.date = '''
    $_formattedDate
    $_formattedTime''';
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.grey,
          content: Text('saved', style: TextStyle(color: Colors.black))));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.grey,
          content: Text('updated', style: TextStyle(color: Colors.black))));
    }
    Navigator.of(context).pop(true);
  }
}
