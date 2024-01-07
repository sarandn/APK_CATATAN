import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasnote/api_manager.dart';
import 'package:uasnote/dashboard.dart';
import 'package:uasnote/user_manager.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiManager apiManager =
      ApiManager(baseUrl: 'http://localhost:8000/api');
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserManager()),
          Provider.value(value: apiManager),
        ],
        child: MaterialApp(
          title: 'Flutter Auth CRUD Example',
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/dashboard': (context) => DashboardPage(),
            '/update': (context) => DashboardPage(),
          },
        ));
  }
}