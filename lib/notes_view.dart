// Week 4 - Preparing Notes View to Read All Notes
// Week 4 - Preparing to Create New Notes
// Week 4 - Displaying Notes in Notes View
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
    _notesService.init(); // load notes pertama
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

        print("ADD BUTTON PRESSED");

        await _notesService.createNote("New Note");

      },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notesService.allNotes,
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: Text("No Notes Yet"),
            );
          }

          final notes = snapshot.data!;

          if (notes.isEmpty) {
            return const Center(
              child: Text("No Notes Yet"),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {

              final note = notes[index];

              return ListTile(
                title: Text(note['text']),

                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    print("BUTTON CLICKED");
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