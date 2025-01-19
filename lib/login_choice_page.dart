import 'package:flutter/material.dart';
import 'student/login_page.dart'; // Import your login_page.dart here
import 'package:eduregistryselab/admin/admin_login_page.dart'; // Import your admin_login_page.dart here

void main() {
  runApp(MaterialApp(
    home: LoginChoicePage(),
  ));
}

class LoginChoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 428,
          height: 926,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFFFFF8F5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              // The "Sign in to your account" text
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  'Sign in to your account',
                  style: TextStyle(
                    color: Color(0xFF202244),
                    fontSize: 23,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 50), // Space between text and buttons
              // Centered "Parent" button with navigation and hover effect
              HoverableButton(
                label: "Parent",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              SizedBox(height: 20), // Space between buttons
              // Centered "Admin" button with navigation to admin_login_page
              HoverableButton(
                label: "Admin",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HoverableButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  HoverableButton({required this.label, required this.onTap});

  @override
  _HoverableButtonState createState() => _HoverableButtonState();
}

class _HoverableButtonState extends State<HoverableButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 241,
          height: 46,
          decoration: ShapeDecoration(
            color: _isHovered ? Color(0xFF0749C4) : Color(0xFF0961F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Jost',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
