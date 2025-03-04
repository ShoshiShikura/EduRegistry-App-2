import 'package:eduregistryselab/admin/authen_page_admin.dart';
import 'package:flutter/material.dart';
//import 'student_signup_page.dart'; // Ensure studentSignupPage is imported
import 'package:eduregistryselab/student/login_page.dart'; // Make sure to import your studentLoginPage here

void main() {
  runApp(MaterialApp(home: ForgotPasswordPage()));
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  // Function to show success dialog and navigate to VerificationPage
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("A code has been sent to ${_emailController.text}"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AuthenPageAdmin()), // Navigate to VerificationPage
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: ListView(
        children: [
          Container(
            width: 428,
            height: 911,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Color(0xFFFFF8F5)),
            child: Stack(
              children: [
                Positioned(
                  left: 21,
                  top: 247,
                  child: Opacity(
                    opacity: 0.30,
                    child: Container(
                      width: 370,
                      height: 350,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Color(0xFFDBDBDB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 4,
                            offset: Offset(-4, 4),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 4,
                            offset: Offset(4, 4),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 4,
                            offset: Offset(0, -4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  left: 136,
                  top: 329,
                  child: Text(
                    'Enter Email Address',
                    style: TextStyle(
                      color: Color(0xFF545454),
                      fontSize: 16,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                
                Positioned(
                  left: 166,
                  top: 419,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the studentLoginPage when clicked
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Opacity(
                      opacity: 0.50,
                      child: Text(
                        'Back to Sign In',
                        style: TextStyle(
                          color: Color(0xFF0961F5),
                          fontSize: 13,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 45,
                  top: 365,
                  child: Container(
                    width: 330,
                    height: 46,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 330,
                            height: 46,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 136,
                  top: 445,
                  child: GestureDetector(
                    onTap: () {
                      if (_emailController.text.isNotEmpty) {
                        _showSuccessDialog();
                      } else {
                        // You can show an error dialog or toast if email is empty
                      }
                    },
                    child: Container(
                      width: 155,
                      height: 46,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 155,
                              height: 46,
                              decoration: ShapeDecoration(
                                color: Color(0xFF0961F5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x4C000000),
                                    blurRadius: 8,
                                    offset: Offset(1, 2),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 12,
                            child: SizedBox(
                              width: 155,
                              child: Text(
                                'Send',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Jost',
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 128,
                  top: 260,
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Color(0xFF202244),
                      fontSize: 23,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Positioned(
                    left: 0,
                    top: 150,
                    right: 0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo next to EduRegistry text
                          Image.asset(
                            'assets/logo.png', // Make sure the path is correct
                            height: 50, // Adjust the size of the logo
                          ),
                          SizedBox(width: 10), // Space between logo and text
                          Column(
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
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
