import 'package:eduregistryselab/admin/home_page_admin.dart' as teacher_home;
import 'package:eduregistryselab/superadmin/superadmin.dart' as superadmin_home;
import 'package:flutter/material.dart';
import 'package:eduregistryselab/student/forgot_pass_page.dart'; // Import the ForgotPasswordPage
// import 'package:eduregistryselab/admin/forgot_pass_admin.dart'; // Import the Forgot Password Admin Page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this package

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  AdminLoginPageState createState() => AdminLoginPageState();
}

class AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _matricController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isButtonDisabled = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _login() async {
    final enteredMatric = _matricController.text.trim();
    final enteredPassword = _passwordController.text.trim();

    if (enteredMatric.isEmpty || enteredPassword.isEmpty) {
      _showErrorDialog('Fields cannot be empty.');
      return;
    }

    setState(() {
      _isButtonDisabled = true;
    });

    try {
      // Query Firestore for user credentials
      final QuerySnapshot query = await _firestore
          .collection('users')
          .where('Matric No', isEqualTo: enteredMatric)
          .where('Password', isEqualTo: enteredPassword)
          .get();

      if (query.docs.isNotEmpty) {
        final user = query.docs.first.data() as Map<String, dynamic>;
        final String role = user['Role'] ?? '';
        final String userDocId = query.docs.first.id; // Get document ID

        // Save matric number and role to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('matric', enteredMatric);
        await prefs.setString('role', role);
        await prefs.setString('userDocId', userDocId); // Save document ID

        // Navigate based on the user's role
        if (role == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => teacher_home.HomePageAdmin(
                userDocId: userDocId, // Pass userDocId
              ),
            ),
          );
        } else if (role == 'Superadmin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => superadmin_home.SuperAdminPage(
                userDocId: userDocId, // Pass userDocId
              ),
            ),
          );
        } else {
          _showErrorDialog(
            'You are a student. Please go to student login page.',
          );
        }
      } else {
        _showErrorDialog('Incorrect matric number or password.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    } finally {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _matricController.clear();
                _passwordController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 150,
                    right: 0,
                    child: Center(
                      child: Column(
                        children: const [
                          Text(
                            'EduRegistry',
                            style: TextStyle(
                              color: Color(0xFF332DA1),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Track. Analyze. Empower.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Matric Field
                  Positioned(
                    left: 56,
                    top: 329,
                    child: const Text(
                      'Matric Number',
                      style: TextStyle(
                        color: Color(0xFF545454),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 45,
                    top: 365,
                    child: Container(
                      width: 330,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _matricController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(14),
                          hintText: 'Enter your matric number',
                        ),
                      ),
                    ),
                  ),

                  // Password Field
                  Positioned(
                    left: 56,
                    top: 427,
                    child: const Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0xFF545454),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 45,
                    top: 458,
                    child: Container(
                      width: 330,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(14),
                          hintText: 'Enter your password',
                        ),
                      ),
                    ),
                  ),

                  // Sign In Button
                  Positioned(
                    left: 45,
                    top: 579,
                    child: SizedBox(
                      width: 330,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _isButtonDisabled ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonDisabled
                              ? Colors.grey
                              : const Color(0xFF0961F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Forgot Password Button
                  Positioned(
                    left: 0,
                    top: 635,
                    right: 0,
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFF0961F5),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
