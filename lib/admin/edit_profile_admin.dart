import 'package:flutter/material.dart';

class AdminEditProfilePage extends StatefulWidget {
  final String name;
  final String icNumber;
  final String matricNumber;
  final String emailAddress;
  final String address;
  final String subject;
  final String password;

  const AdminEditProfilePage({
    super.key,
    required this.name,
    required this.icNumber,
    required this.matricNumber,
    required this.emailAddress,
    required this.address,
    required this.subject,
    required this.password,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<AdminEditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController icNumberController;
  late TextEditingController matricNumberController;
  late TextEditingController emailAddressController;
  late TextEditingController addressController;
  late TextEditingController subjectController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    icNumberController = TextEditingController(text: widget.icNumber);
    matricNumberController = TextEditingController(text: widget.matricNumber);
    emailAddressController = TextEditingController(text: widget.emailAddress);
    addressController = TextEditingController(text: widget.address);
    subjectController = TextEditingController(text: widget.subject);
    passwordController = TextEditingController(text: widget.password);
  }

  void _saveProfile() {
    final updatedData = {
      'name': nameController.text,
      'icNumber': icNumberController.text,
      'matricNumber': matricNumberController.text,
      'emailAddress': emailAddressController.text,
      'address': addressController.text,
      'subject': subjectController.text,
      'password': passwordController.text,
    };

    Navigator.pop(context, updatedData);
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTextField(controller: nameController, label: "Name"),
              const SizedBox(height: 10),
              _buildTextField(controller: icNumberController, label: "IC Number"),
              const SizedBox(height: 10),
              _buildTextField(controller: matricNumberController, label: "Matric Number"),
              const SizedBox(height: 10),
              _buildTextField(controller: emailAddressController, label: "Email Address"),
              const SizedBox(height: 10),
              _buildTextField(controller: addressController, label: "Address"),
              const SizedBox(height: 10),
              _buildTextField(controller: subjectController, label: "Subject"),
              const SizedBox(height: 10),
              _buildTextField(controller: passwordController, label: "Password"),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 64.0),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
