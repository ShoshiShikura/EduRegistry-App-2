import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherPage extends StatefulWidget {
  final String userDocId;

  const TeacherPage({super.key, required this.userDocId});

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _icNoController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to check for duplicate Matric No
  Future<bool> _isMatricNoDuplicate(String matricNo) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('Matric No', isEqualTo: matricNo)
          .get();

      return querySnapshot.docs.isNotEmpty; // True if a duplicate exists
    } catch (e) {
      print('Error checking Matric No: $e');
      return false;
    }
  }

  // Function to add a teacher to Firestore
  Future<void> _addTeacher() async {
    final String name = _nameController.text.trim();
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final String icNo = _icNoController.text.trim();
    final String matricNo = _matricNoController.text.trim();
    final String phone = _phoneController.text.trim();
    final String password = _passwordController.text.trim();

    // Validate input fields
    if (name.isEmpty ||
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

    // Check for duplicate Matric No
    if (await _isMatricNoDuplicate(matricNo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Matric No "$matricNo" is not available')),
      );
      return;
    }

    // Prepare teacher data
    final String role = 'Admin'; // Auto-set Role
    final String school = 'SK Bukit Tembakau'; // Auto-set School

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'Name': name,
        'Class': null, // Teachers don't have a class
        'Address': address,
        'Email': email,
        'IC No': icNo,
        'Matric No': matricNo,
        'No. Phone': phone,
        'Password': password,
        'Role': role,
        'School': school,
        'Subjects': [], // Empty array initially
        'TotalMerit': null, // Teachers don't use TotalMerit
      });

      // Clear the input fields
      _nameController.clear();
      _addressController.clear();
      _emailController.clear();
      _icNoController.clear();
      _matricNoController.clear();
      _phoneController.clear();
      _passwordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teacher added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add teacher: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Teacher',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Input Fields
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Teacher Name',
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
                onPressed: _addTeacher,
                child: Text('Add Teacher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
