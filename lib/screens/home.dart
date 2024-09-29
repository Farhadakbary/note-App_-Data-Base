import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'addNotes.dart';
import '../database/databaseHelper.dart';
import 'loginpage.dart';
import '../class/note.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = [];
  List<Note> filteredNoteList = [];
  int? count;
  bool isDarkMode = false;
  double fontSize = 12.0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    saveFont();
    updateListView();
    loadPreferences();
    searchController.addListener(() {
      filterNotes(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFAB42FF),
                Color(0xFF1E90FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _deleteAll(context),
            icon: const Icon(Icons.delete_forever_rounded),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search notes by title',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
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
        child: filteredNoteList.isEmpty
            ? const Center(
            child: Text(
              'No Notes Available',
              style: TextStyle(fontSize: 25),
            ))
            : ListView.builder(
            itemCount: filteredNoteList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    navigateToAddNote(this.filteredNoteList[index], 'Edit Detail');
                  },
                  child: ListTile(
                    title: Text(filteredNoteList[index].title),
                    subtitle: Text(filteredNoteList[index].date),
                    trailing: IconButton(
                      onPressed: () {
                        _delete(context, filteredNoteList[index]);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: CupertinoColors.destructiveRed,
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[400],
        onPressed: () {
          navigateToAddNote(Note('', ''), 'Add Note');
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('log_in', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> saveFont() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getDouble('fontSize') ?? 12.0;
    });
  }

  void _delete(BuildContext context, Note note) async {
    var result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Note deleted',
            style: TextStyle(color: Colors.white),
          )));
      updateListView();
    }
  }

  void _deleteAll(BuildContext context) async {
    var result = await databaseHelper.trancateDatabase();
    if (result != 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Note  deleted',
            style: TextStyle(color: Colors.white),
          )));
      updateListView();
    }
  }

  void updateListView() {
    Future<Database> dbFuture = databaseHelper.initialize();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.filteredNoteList = noteList;
          count = noteList.length;
        });
      });
    });
  }

  void navigateToAddNote(Note note, String title) async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddNotePage(note, title)));
    if (result == true) {
      updateListView();
    }
  }

  void filterNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredNoteList = noteList;
      } else {
        filteredNoteList = noteList
            .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
