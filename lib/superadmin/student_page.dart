import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentPage extends StatefulWidget {
  final String userDocId;

  const StudentPage({super.key, required this.userDocId});

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _icNoController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to add a student to Firestore
  Future<void> _addStudent() async {
    final String name = _nameController.text.trim();
    final String studentClass = _classController.text.trim();
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final String icNo = _icNoController.text.trim();
    final String matricNo = _matricNoController.text.trim();
    final String phone = _phoneController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isEmpty ||
        studentClass.isEmpty ||
        address.isEmpty ||
        email.isEmpty ||
        icNo.isEmpty ||
        matricNo.isEmpty ||
        phone.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields!')),
      );
      return;
    }

    try {
      // Check if Matric No already exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('Matric No', isEqualTo: matricNo)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If Matric No exists, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Matric No "$matricNo" is not available'),
          ),
        );
      } else {
        // Add student if Matric No is unique
        await FirebaseFirestore.instance.collection('users').add({
          'Name': name,
          'Class': studentClass,
          'Address': address,
          'Email': email,
          'IC No': icNo,
          'Matric No': matricNo,
          'No. Phone': phone,
          'Password': password,
          'Role': 'Student', // Auto-set Role
          'School': 'SK Bukit Tembakau', // Auto-set School
          'TotalMerit': 0, // Auto-set Total Merit
        });

        // Clear the input fields
        _nameController.clear();
        _classController.clear();
        _addressController.clear();
        _emailController.clear();
        _icNoController.clear();
        _matricNoController.clear();
        _phoneController.clear();
        _passwordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student added successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add student: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Student',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Input Fields
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _classController,
                decoration: InputDecoration(
                  labelText: 'Class',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _icNoController,
                decoration: InputDecoration(
                  labelText: 'IC No',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _matricNoController,
                decoration: InputDecoration(
                  labelText: 'Matric No',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'No. Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: _addStudent,
                child: Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
