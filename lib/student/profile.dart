import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';
import 'package:eduregistryselab/login_choice_page.dart';
import 'package:eduregistryselab/student/home_page.dart' as user_home;

class ProfilePage extends StatefulWidget {
  final String userDocId;

  const ProfilePage({super.key, required this.userDocId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Define initial values for the profile fields
  String name = "Loading...";
  String className = "Loading...";
  String matricNo = "Loading...";
  String icNo = "Loading...";
  String phone = "Loading...";
  String address = "Loading...";
  String profileImageUrl = ""; // URL for the profile picture

  bool isLoading = true; // Add loading indicator state

  File? _profileImage; // Local profile image file

  // Fetch user data from Firestore using userDocId
  Future<void> _fetchUserData() async {
    String id = widget.userDocId;
    if (id.isNotEmpty) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        // Fetch user document from Firestore using userDocId
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(id).get();

        if (userDoc.exists) {
          setState(() {
            name = userDoc["Name"] ?? "N/A";
            className = userDoc["Class"] ?? "N/A";
            matricNo = userDoc["Matric No"] ?? "N/A";
            icNo = userDoc["IC No"] ?? "N/A";
            phone = userDoc["NoPhone"] ?? "N/A";
            address = userDoc["Address"] ?? "N/A";
            profileImageUrl = userDoc["ProfileImageUrl"] ?? "";
            isLoading = false; // Data loaded
          });
        } else {
          setState(() {
            isLoading = false; // Stop loading
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    }
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Optionally upload the image to Firestore or Firebase Storage
      await _uploadProfileImage();
    }
  }

  // Upload the profile image (Firebase Storage integration required)
  Future<void> _uploadProfileImage() async {
    if (_profileImage != null) {
      // Mock: Replace with actual Firebase Storage upload and URL retrieval
      String uploadedImageUrl = "path/to/your/uploaded/image.jpg";

      // Update Firestore with the new image URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userDocId)
          .update({'ProfileImageUrl': uploadedImageUrl});

      setState(() {
        profileImageUrl = uploadedImageUrl;
      });
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginChoicePage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    user_home.HomePage(userDocId: widget.userDocId),
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _logout,
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (profileImageUrl.isNotEmpty
                                ? NetworkImage(profileImageUrl)
                                    as ImageProvider
                                : null),
                        child: _profileImage == null && profileImageUrl.isEmpty
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
                    ProfileField(label: "Matric No", value: matricNo),
                    ProfileField(label: "IC No", value: icNo),
                    ProfileField(label: "Phone", value: phone),
                    ProfileField(label: "Address", value: address),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              name: name,
                              className: className,
                              matricNo: matricNo,
                              icNo: icNo,
                              phone: phone,
                              address: address,
                              userDocId: widget.userDocId,
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            name = result['name'];
                            className = result['className'];
                            matricNo = result['matricNo'];
                            icNo = result['icNo'];
                            phone = result['phone'];
                            address = result['address'];
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 64.0),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
