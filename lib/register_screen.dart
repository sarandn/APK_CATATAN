import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'api_manager.dart';

class RegisterScreen extends StatelessWidget {
  // Controllers for full name, email, and password text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.brown, // Set app bar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo above the registration form
              Image.asset(
                'logo1.', // Replace with the path to your logo image
                height: 80, // Adjust the height as needed
              ),
              SizedBox(height: 16), // Add some spacing

              // Registration form with full name, email, and password fields
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person), // Add person icon
                ),
              ),
              SizedBox(height: 16), // Add some spacing

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email), // Add email icon
                ),
              ),
              SizedBox(height: 16), // Add some spacing

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock), // Add lock icon
                ),
              ),
              SizedBox(height: 24), // Add some spacing

              // "Register" button
              ElevatedButton(
                onPressed: () async {
                  try {
                    final name = fullNameController.text;
                    final username = emailController.text;
                    final password = passwordController.text;
                    final apiManager =
                        Provider.of<ApiManager>(context, listen: false);
                    await apiManager.register(name, username, password);
                    // Show a toast on successful registration

                    Navigator.pushReplacementNamed(context, '/login');
                    // Handle successful registration
                  } catch (e) {
                    print('Registration failed. Error: $e');
                    // Handle registration failure
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Set button background color
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown,),
                    
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