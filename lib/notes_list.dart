import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'note_form.dart';

class NoteList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('notes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final notes = snapshot.data!.docs;

        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            final noteId = note.id;
            final noteData = note.data() as Map<String, dynamic>;

            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(noteData['description']),
                subtitle: Text('Fecha: ${DateFormat('yyyy-MM-dd').format((noteData['date'] as Timestamp).toDate())}\nEstado: ${noteData['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteForm(noteId: noteId, noteData: noteData),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _firestore.collection('notes').doc(noteId).delete();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
