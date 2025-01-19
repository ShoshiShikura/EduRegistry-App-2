import 'package:eduregistryselab/student/new_password_student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFF8F5),
      ),
      home: const AuthenPagestudent(),
    );
  }
}

class AuthenPagestudent extends StatelessWidget {
  const AuthenPagestudent({super.key});

  void _verify(BuildContext context) {
    // Show a SnackBar as a popup message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Verification Successful',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF0961F5),
        duration: const Duration(seconds: 3), // Popup stays for 3 seconds
      ),
    );

    // Navigate to NewPasswordstudent after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewPassword()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 80), // Adjusts the overall top spacing
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'EduRegistry',
                          style: TextStyle(
                            color: Color(0xFF332DA1),
                            fontSize: 24,
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'LEARN FROM HOME',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Pushes the box lower
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F0EE),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Authentication',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF202244),
                              fontSize: 23,
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Enter the code sent to your email',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF202244),
                              fontSize: 11,
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Enter code',
                              hintStyle: const TextStyle(
                                fontFamily: 'Jost',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Didn’t get the code? ',
                                  style: TextStyle(
                                    color: Color(0xFF202244),
                                    fontSize: 11,
                                    fontFamily: 'Jost',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Resend code',
                                  style: TextStyle(
                                    color: Color(0xFF0961F5),
                                    fontSize: 11,
                                    fontFamily: 'Jost',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 180,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => _verify(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0961F5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                shadowColor: const Color(0x4C000000),
                                elevation: 4,
                              ),
                              child: const Text(
                                'Verify',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Jost',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
