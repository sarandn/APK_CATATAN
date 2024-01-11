import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasnote/dashboard.dart';
import 'package:uasnote/api_manager.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class NoteUpdateFormPage extends StatefulWidget {
  final Note note;

  NoteUpdateFormPage({required this.note});

  @override
  _NoteUpdateFormPageState createState() => _NoteUpdateFormPageState();
}

class _NoteUpdateFormPageState extends State<NoteUpdateFormPage> {
  late TextEditingController _judulController;
  late TextEditingController _isiController;
  late TextEditingController _gambarController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.note.judul);
    _isiController = TextEditingController(text: widget.note.isi);
    _gambarController = TextEditingController(text: widget.note.gambar);
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
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _judulController,
              decoration: InputDecoration(labelText: 'judul'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _isiController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'isi'),
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

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final apiManager =
                      Provider.of<ApiManager>(context, listen: false);
                  await apiManager.updateNote(widget.note.id.toString(),
                      _judulController.text, _isiController.text, _image!);

                  // Tampilkan notifikasi bahwa catatan berhasil diupdate
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Catatan berhasil diperbarui!'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Kembali ke halaman sebelumnya
                  Navigator.pop(context);
                } catch (e) {
                  print('Error updating note: $e');
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}