import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'dashboard.dart';

enum RegistrationResult {
  success,
  emailAlreadyExists, duplicateEmail,
  // tambahkan nilai enum lainnya sesuai kebutuhan
}

class ApiManager {
  final String baseUrl;
  final storage = FlutterSecureStorage();

  ApiManager({required this.baseUrl});

  Future<List<Note>> getNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<Map<String, dynamic>> notesData =
          List<Map<String, dynamic>>.from(jsonResponse);

      return notesData.map((noteData) => Note.fromJson(noteData)).toList();
    } else {
      throw Exception('Failed to get notes');
    }
  }

  Future<String?> addNoteDetail(String judul, String isi, File? gambar) async {
    // final response = await http.post(
    //   Uri.parse('$baseUrl/addnote'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: {'judul': judul, 'isi': isi, 'gambar': gambar},
    // );
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/addnote'))
      ..files.add(await http.MultipartFile.fromPath('gambar', gambar!.path))
      ..fields['judul'] = judul
      ..fields['isi'] = isi
      ..fields['headers'] = "application/json";

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final token = "Succesfully";
      return token;
    } else {
      throw Exception('gagal');
    }
  }

  Future<List<Map<String, dynamic>>> getNoteDetail() async {
    final response = await http.get(Uri.parse('$baseUrl/NoteDetail'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonResponse);
    } else {
      throw Exception('Failed to get NoteDetail');
    }
  }

  Future<void> updateNote(
      String id, String judul, String isi, File? gambar) async {
    final token = await storage.read(key: 'kode_rahassia');
    // final response = await http.put(
    //   Uri.parse('$baseUrl/notes/$id'), // Sesuaikan dengan endpoint API Anda
    //   headers: {
    //     'Content-Type': 'application/json', // Ganti menjadi application/json
    //     'Authorization': 'Bearer $token', // Tambahkan token
    //   },
    //   body: jsonEncode({
    //     'judul': judul,
    //     'isi': isi,
    //   }),
    // );

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/notes/$id'))
      ..files.add(await http.MultipartFile.fromPath('gambar', gambar!.path))
      ..fields['judul'] = judul
      ..fields['isi'] = isi
      ..fields['headers'] = "application/json";

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Failed to update note');
    }
  }

  Future<String?> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'name': name, 'email': email, 'password': password},
    );

    if (response.statusCode == 201) {
      final token = "Succesfully";
      return token;
    } else {
      throw Exception('Failed to register, email sudah tersedia');
    }
  }

  Future<String?> login2(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['token'];

      await storage.write(key: 'auth_token', value: token);

      return token;
    } else {
      throw Exception('Gagalllllllllllll');
    }
  }

  Future<void> deleteNote(String id) async {
    final token = await storage.read(key: 'kode_rahassia');
    final response = await http.delete(
      Uri.parse('$baseUrl/notes/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete notes');
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final token = jsonResponse['token'];

        await storage.write(key: 'auth_token', value: token);

        return token;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error in login: $e');
      throw e;
    }
  }

  Future<String?> authenticate(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['token'];

      // Save the token securely
      await storage.write(key: 'kode_rahassia', value: token);

      return token;
    } else {
      throw Exception('Failed to authenticate');
    }
  }
}
