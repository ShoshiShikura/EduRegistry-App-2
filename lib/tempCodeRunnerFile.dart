import 'package:flutter/material.dart';
import 'student/login_page.dart'; // Ensure this is the correct path for LoginPage
import 'splash_screen.dart'; // Ensure this is the correct path for SplashScreen
// import 'package:eduregistryselab/home_page_superadmin.dart'; // Ensure this is the correct path for HomePage
import 'package:eduregistryselab/student/home_page.dart'; // Ensure this is the correct path for HomePage
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences for userDocId

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'EduRegistry', // App title
      initialRoute: '/', // Set the initial route to the splash screen
      routes: {
        '/': (context) =>
            const SplashScreen(), // SplashScreen is the initial screen
        '/login': (context) => const LoginPage(), // Route to LoginPage
        '/home': (context) => FutureBuilder<String>(
              future:
                  _getUserDocId(), // Retrieve userDocId from SharedPreferences
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading user data'));
                }
                final userDocId = snapshot.data ?? '';
                return HomePage(
                    userDocId: userDocId); // Pass the userDocId to HomePage
              },
            ),
      },
    );
  }

  // Retrieve userDocId from SharedPreferences
  Future<String> _getUserDocId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userDocId') ??
        ''; // Default to empty string if not found
  }
}
