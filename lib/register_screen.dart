import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.brown,
                    width: 2.0,
                  ),
                  color: Colors.brown,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'images/logo1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
  onPressed: () async {
    try {
      final name = fullNameController.text;
      final email = emailController.text;
      final password = passwordController.text;
      final apiManager = Provider.of<ApiManager>(context, listen: false);

      // Panggil metode register dari ApiManager
      final registrationResult = await apiManager.register(name, email, password);

      if (registrationResult == "Success") {
        // Registrasi berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registrasi berhasil!"),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to login screen directly
        Navigator.pushReplacementNamed(context, '/login');
      } else if (registrationResult == "emailAlreadyExists") {
        // Email sudah terdaftar
        Fluttertoast.showToast(
          msg: "Registrasi gagal. Email sudah terdaftar.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Penanganan kesalahan registrasi lainnya
        Fluttertoast.showToast(
          msg: "Registrasi gagal. Coba lagi!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Registrasi gagal. Error: $e');
      // Handle kegagalan registrasi
      Fluttertoast.showToast(
        msg: "Registrasi gagal. Coba lagi!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  },
  style: ElevatedButton.styleFrom(
    primary: Colors.brown,
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      'Daftar',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}

