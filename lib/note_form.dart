import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({Key? key, this.noteId, this.noteData}) : super(key: key);

  final String? noteId;
  final Map<String, dynamic>? noteData;

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  String _id = '';
  String _description = '';
  DateTime? _selectedDate;
  String _status = 'creado';
  bool _important = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (widget.noteData != null) {
      _id = widget.noteData!['id'];
      _description = widget.noteData!['description'];
      _selectedDate = (widget.noteData!['date'] as Timestamp).toDate();
      _status = widget.noteData!['status'];
      _important = widget.noteData!['important'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? 'Agregar Nota' : 'Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _id,
                decoration: InputDecoration(
                  labelText: "ID",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (String id) {
                  setState(() {
                    _id = id;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: "Descripción",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (String description) {
                  setState(() {
                    _description = description;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  _selectedDate != null
                      ? 'Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'
                      : 'Seleccione una fecha',
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  labelText: "Estado",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'creado', child: Text('Creado')),
                  DropdownMenuItem(value: 'por hacer', child: Text('Por hacer')),
                  DropdownMenuItem(value: 'trabajando', child: Text('Trabajando')),
                  DropdownMenuItem(value: 'finalizado', child: Text('Finalizado')),
                ],
                onChanged: (String? status) {
                  setState(() {
                    _status = status!;
                  });
                },
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: Text('Importante'),
                value: _important,
                onChanged: (bool important) {
                  setState(() {
                    _important = important;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.noteId == null) {
                      addNote(_id, _description, _selectedDate, _status, _important);
                    } else {
                      updateNote(widget.noteId!, _id, _description, _selectedDate, _status, _important);
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addNote(String id, String description, DateTime? date, String status, bool important) async {
    try {
      await _firestore.collection('notes').add({
        'id': id,
        'description': description,
        'date': date,
        'status': status,
        'important': important,
      });
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  Future<void> updateNote(String noteId, String id, String description, DateTime? date, String status, bool important) async {
    try {
      await _firestore.collection('notes').doc(noteId).update({
        'id': id,
        'description': description,
        'date': date,
        'status': status,
        'important': important,
      });
    } catch (e) {
      print('Error updating note: $e');
    }
  }
}
