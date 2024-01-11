import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_manager.dart';
import 'package:provider/provider.dart';

class NoteFormPage extends StatefulWidget {
  @override
  _NoteFormPageState createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  File? _image;

  Future<void> _addNote() async {
    final apiManager = Provider.of<ApiManager>(context, listen: false);

    final judul = _judulController.text;
    final isi = _isiController.text;

    if (judul.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Judul cannot be empty!'),
      ));
      return; // Don't proceed if judul is empty
    }

    try {
      final result = await apiManager.addNoteDetail(judul, isi, _image!);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result ?? 'Gagal mengirim catatan'),
      ));

      if (result == 'Succesfully') {
        print('Navigating to dashboard...');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        print('Failed to send note. Result: $result');
      }
    } catch (e) {
      print('Error in _addNote: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan: $e'),
      ));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: Container(
        color: Colors.brown,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextFormField(
                controller: _judulController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Judul',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _isiController,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Isi',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Tambahkan widget untuk menampilkan foto yang dipilih
              if (_image != null)
                Image.file(
                  _image!,
                  height: 100,
                ),

              // Tambahkan tombol untuk memilih foto
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown,
                ),
                child: Text(
                  'Pilih Foto',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              SizedBox(height: 16),

              ElevatedButton(
                onPressed: _addNote,
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown,
                ),
                child: Text(
                  'Kirim',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}