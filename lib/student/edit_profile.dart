import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String className;
  final String matricNo;
  final String icNo;
  final String phone;
  final String address;
  final String userDocId; // New parameter for Firestore document ID

  const EditProfilePage({
    super.key,
    required this.name,
    required this.className,
    required this.matricNo,
    required this.icNo,
    required this.phone,
    required this.address,
    required this.userDocId,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController classController;
  late TextEditingController matricNoController;
  late TextEditingController icNoController;
  late TextEditingController phoneNoController;
  late TextEditingController addressController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    classController = TextEditingController(text: widget.className);
    matricNoController = TextEditingController(text: widget.matricNo);
    icNoController = TextEditingController(text: widget.icNo);
    phoneNoController = TextEditingController(text: widget.phone);
    addressController = TextEditingController(text: widget.address);

    _fetchProfileData(); // Fetch Firestore data
  }

  void _fetchProfileData() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(widget.userDocId).get();

      if (userDoc.exists && userDoc['matricNo'] == widget.matricNo) {
        setState(() {
          nameController.text = userDoc['name'];
          classController.text = userDoc['className'];
          matricNoController.text = userDoc['matricNo'];
          icNoController.text = userDoc['icNo'];
          phoneNoController.text = userDoc['phone'];
          addressController.text = userDoc['address'];
        });
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  void _saveProfile() async {
    final updatedData = {
      'name': nameController.text,
      'className': classController.text,
      'matricNo': matricNoController.text,
      'icNo': icNoController.text,
      'phone': phoneNoController.text,
      'address': addressController.text,
    };

    try {
      await _firestore
          .collection('users')
          .doc(widget.userDocId)
          .update(updatedData);
      Navigator.pop(context, updatedData);
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
              _buildTextField(controller: classController, label: "Class"),
              const SizedBox(height: 10),
              _buildTextField(
                  controller: matricNoController, label: "Matric No"),
              const SizedBox(height: 10),
              _buildTextField(controller: icNoController, label: "IC No"),
              const SizedBox(height: 10),
              _buildTextField(controller: phoneNoController, label: "Phone No"),
              const SizedBox(height: 10),
              _buildTextField(controller: addressController, label: "Address"),
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

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
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
