import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'note_form.dart';
import 'notes_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Flutter College"),
      ),
      body: NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
