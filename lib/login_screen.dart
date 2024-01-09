import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasnote/api_manager.dart';
// import 'dashboard.dart';
import 'user_manager.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _auth(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;
    final userManager = Provider.of<UserManager>(context, listen: false);
    final apiManager = Provider.of<ApiManager>(context, listen: false);

    try {
      final token = await apiManager.login2(email, password);
      // Show a toast on successful login
      userManager.setAuthToken(token);
      Navigator.pushReplacementNamed(context, '/dashboard');
      // Handle successful login
    } catch (e) {
      print('Login failed. Error: $e');

      // Check if the error message indicates that the user is not registered
      if (e.toString().contains('The provided credentials are incorrect')) {
        // Show a notification for failed login (user not registered)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. User not registered.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Show a generic notification for other login failures
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      // Handle login failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.brown,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/logo1.png',
                  height: 80,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.key, color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _auth(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Masuk',
                      style: TextStyle(fontSize: 18, color: Colors.brown),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Belum punya akun? Daftar dulu yuk',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
