import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'api_manager.dart';
import 'form_screen.dart';
import 'note_detail.dart';
import 'login_screen.dart';
import 'profile.dart';
import 'update_form.dart';
import 'dart:io';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];

  TextEditingController _searchController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();

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
        filteredNotes =
            notes; // Inisialisasi filteredNotes dengan seluruh catatan
      });
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  void _filterNotes(String query) {
    setState(() {
      filteredNotes = notes
          .where((note) =>
              note.judul.toLowerCase().contains(query.toLowerCase()) ||
              note.isi.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _deleteNote(String id) async {
    final apiManager = Provider.of<ApiManager>(context, listen: false);

    try {
      await apiManager.deleteNote(id);
      setState(() {
        notes.removeWhere((note) => note.id.toString() == id);
        filteredNotes = notes
            .where((note) =>
                note.judul
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ||
                note.isi
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
            .toList();
      });

      // Menampilkan notifikasi berhasil dihapus
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catatan berhasil dihapus!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error deleting note: $e');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Gagal menghapus catatan. Error: $e'),
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

  File? _image;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  Future<void> _addNote() async {
    final apiManager = Provider.of<ApiManager>(context, listen: false);

    final judul = _judulController.text;
    final isi = _isiController.text;
    final gambar = _gambarController.text;

    dynamic result = await apiManager.addNoteDetail(judul, isi, _image!);

    // Periksa hasil penambahan catatan
    if (result == 'Berhasil') {
      // Catatan berhasil ditambahkan, perbarui state
      setState(() {
        // Tambahkan catatan baru ke dalam daftar catatan
        notes.add(
            Note(id: result['id'], judul: judul, isi: isi, gambar: gambar));
        // Update filteredNotes sesuai dengan kondisi terkini (misalnya: termasuk catatan baru)
        filteredNotes = notes
            .where((note) =>
                note.judul
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ||
                note.isi
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
            .toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Catatan berhasil ditambahkan!')));
      Navigator.pop(context);
    } else {
      // Gagal menambahkan catatan
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes Dashboard'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'profil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else if (value == 'keluar') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'profil',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profil'),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'keluar',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Keluar'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterNotes,
              decoration: InputDecoration(
                hintText: 'Cari apa nih...',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return Card(
                      color: Colors.brown,
                      child: ListTile(
                        title: Text(
                          note.judul,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          note.isi,
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () async {
                                await _deleteNote(note.id.toString());
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NoteUpdateFormPage(note: note),
                                  ),
                                ).then((_) {
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteFormPage()),
          ).then((_) {
            _fetchNotes();
          });
        },
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}

class Note {
  final dynamic id;
  final String judul;
  final String isi;
  final String gambar;

  Note({
    required this.id,
    required this.judul,
    required this.isi,
    required this.gambar,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int,
      judul: json['judul'] as String,
      isi: json['isi'] as String,
      gambar: json['gambar'] as String,
    );
  }
}

