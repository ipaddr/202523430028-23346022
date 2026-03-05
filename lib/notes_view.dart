// Week 4 - Preparing Notes View to Read All Notes
import 'package:flutter/material.dart';
import 'services/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final NotesService _notesService = NotesService();

  @override
  void initState() {
    super.initState();
    _notesService.init();
  }

  // load data pertama
  Future<void> _loadNotes() async {
    await _notesService.database;
    await _notesService.getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
      ),

      // tombol tambah
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _notesService.createNote("New Note");
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notesService.allNotes,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Notes Yet"),
            );
          }

          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {

              final note = notes[index];

              return ListTile(
                title: Text(note['text']),

                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _notesService.deleteNote(note['id']);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}