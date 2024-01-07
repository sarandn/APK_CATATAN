import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasnote/api_manager.dart';
import 'form_screen.dart';
import 'note_detail.dart';
import 'login_screen.dart';
import 'profile.dart';
import 'update_form.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

// ... (kode sebelumnya)

class _DashboardPageState extends State<DashboardPage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final apiManager = Provider.of<ApiManager>(context, listen: false);

    try {
      List<Note> fetchedNotes = await apiManager.getNotes();
      setState(() {
        notes = fetchedNotes;
      });
    } catch (e) {
      // Handle error (e.g., show an error message)
      print('Error fetching notes: $e');
    }
  }

  Future<void> _updateNote(Note note) async {
  final apiManager = Provider.of<ApiManager>(context, listen: false);

  // Implementasi logika update note di sini

  try {
    // Contoh pemanggilan updateNote
    await apiManager.updateNote(
      note.id.toString(),
      'Judul Baru', // Ganti dengan judul baru
      'Isi Baru', // Ganti dengan isi baru
    );

    // Reload notes after successful update
    await _fetchNotes();
  } catch (e) {
    // Handle error (e.g., show an error message)
    print('Error updating note: $e');

    // Tambahkan logika penanganan kesalahan di sini, misalnya menampilkan AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update note. Error: $e'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


  Future<void> _deleteNote(String id) async {
    final apiManager = Provider.of<ApiManager>(context, listen: false);

    try {
      await apiManager.deleteNote(id);
      // Reload notes after successful deletion
      await _fetchNotes();
    } catch (e) {
      // Handle error (e.g., show an error message)
      print('Error deleting note: $e');

      // Tambahkan logika penanganan kesalahan di sini, misalnya menampilkan AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete note. Error: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(String noteId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this note?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await _deleteNote(noteId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes Dashboard'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return Card(
              color: Colors.brown,
              child: ListTile(
                title: Text(
                  note.judul,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        // Tampilkan dialog konfirmasi
                        bool deleteConfirmed = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Konfirmasi Hapus'),
                              content: Text(
                                  'Apakah Anda yakin ingin menghapus data dengan ID ${note.id}?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(false); // Batal menghapus
                                  },
                                  child: Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(true); // Konfirmasi menghapus
                                  },
                                  child: Text('Hapus'),
                                ),
                              ],
                            );
                          },
                        );

                        // Jika konfirmasi untuk menghapus diberikan
                        if (deleteConfirmed == true) {
                          try {
                            await _deleteNote(note.id
                                .toString()); // Pastikan ID dikonversi menjadi String
                            print('Delete Note: ${note.judul}');

                            // Menampilkan notifikasi bahwa Catatan berhasil dihapus
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Catatan berhasil dihapus!'),
                                duration: Duration(seconds: 2),
                              ),
                            );

                            // Menjalankan fungsi untuk me-reload catatan setelah dihapus
                            await _fetchNotes();
                          } catch (e) {
                            // Handle error (e.g., show an error message)
                            print('Error deleting note: $e');
                            // Tambahkan logika penanganan kesalahan di sini, misalnya menampilkan AlertDialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'Failed to delete note. Please try again.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NoteUpdateFormPage(note: note),
                          ),
                        ).then((_) {
                          // Reload notes after returning from update screen
                          _fetchNotes();
                        });
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailPage(note: note),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteFormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Note {
  final dynamic id; // Use dynamic to accept both String and int
  final String judul;

  final String isi;

  Note({
    required this.id,
    required this.judul,
    required this.isi,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int, // Ubah ke tipe int
      judul: json['judul'] as String,
      isi: json['isi'] as String,
    );
  }
}