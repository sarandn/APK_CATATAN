import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.brown, // Ganti warna app bar menjadi coklat
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors
                    .brown, // Ganti warna background avatar menjadi coklat
                backgroundImage: AssetImage(
                    'images/foto.jpg'), // Ganti dengan path gambar sesuai kebutuhan
                // Tambahkan shadow
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Nama Pengguna',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown, // Ganti warna teks menjadi coklat
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Email@contoh.com',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Fungsi yang akan dijalankan ketika tombol ditekan
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .brown, // Ganti warna latar belakang tombol menjadi coklat
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Ubah Foto Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
