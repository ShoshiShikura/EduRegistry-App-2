import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:eduregistryselab/login_choice_page.dart'; // Import your admin_login_page.dart here

class AdminProfilePage extends StatefulWidget {
  final String userDocId;

  const AdminProfilePage({super.key, required this.userDocId});

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  // Define initial values for profile fields
  String name = "Loading...";
  String className = "Loading...";
  String matricNumber = "Loading...";
  String icNumber = "Loading...";
  String phone = "Loading...";
  String address = "Loading...";
  String profileImageUrl = ""; // Store the profile image URL
  File? _profileImage; // Store the selected profile image

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    // Fetch user data locally (No Firebase integration needed for now)
    setState(() {
      name = "John Doe";
      className = "Software Engineering";
      matricNumber = "123456";
      icNumber = "890123456789";
      phone = "0123456789";
      address = "123 Street, City, Country";
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path); // Update profile picture
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _signOut(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginChoicePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () => _signOut(context),
              child: const Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage, // Tap to change the profile picture
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!) // Show picked image
                      : const AssetImage('assets/default_profile.png') as ImageProvider,
                  child: _profileImage == null
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt, color: Colors.blue),
                label: const Text(
                  "Change Profile Picture",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              ProfileField(label: "Name", value: name),
              ProfileField(label: "Class", value: className),
              ProfileField(label: "Matric Number", value: matricNumber),
              ProfileField(label: "IC Number", value: icNumber),
              ProfileField(label: "Phone", value: phone),
              ProfileField(label: "Address", value: address),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
