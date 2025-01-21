import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEditProfilePage extends StatefulWidget {
  final String userDocId;
  final String name;
  final String className;
  final String matricNumber;
  final String icNumber;
  final String phone;
  final String address;

  const AdminEditProfilePage({
    super.key,
    required this.userDocId,
    required this.name,
    required this.className,
    required this.matricNumber,
    required this.icNumber,
    required this.phone,
    required this.address,
  });

  @override
  _AdminEditProfilePageState createState() => _AdminEditProfilePageState();
}

class _AdminEditProfilePageState extends State<AdminEditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController classController;
  late TextEditingController matricNumberController;
  late TextEditingController icNumberController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    classController = TextEditingController(text: widget.className);
    matricNumberController = TextEditingController(text: widget.matricNumber);
    icNumberController = TextEditingController(text: widget.icNumber);
    phoneController = TextEditingController(text: widget.phone);
    addressController = TextEditingController(text: widget.address);
  }

  void _saveProfile() async {
    final updatedProfile = {
      'name': nameController.text,
      'className': classController.text,
      'matricNumber': matricNumberController.text,
      'icNumber': icNumberController.text,
      'phone': phoneController.text,
      'address': addressController.text,
    };

    try {
      await _firestore.collection('users').doc(widget.userDocId).update(updatedProfile);
      Navigator.pop(context, updatedProfile);
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildTextField(controller: nameController, label: "Name"),
              const SizedBox(height: 10),
              _buildTextField(controller: classController, label: "Class"),
              const SizedBox(height: 10),
              _buildTextField(controller: matricNumberController, label: "Matric No"),
              const SizedBox(height: 10),
              _buildTextField(controller: icNumberController, label: "IC No"),
              const SizedBox(height: 10),
              _buildTextField(controller: phoneController, label: "Phone No"),
              const SizedBox(height: 10),
              _buildTextField(controller: addressController, label: "Address"),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 64.0),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
