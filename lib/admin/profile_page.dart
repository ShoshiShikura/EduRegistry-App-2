import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:eduregistryselab/login_choice_page.dart';
import 'package:eduregistryselab/admin/edit_profile_admin.dart';
import 'package:eduregistryselab/admin/home_page_admin.dart' as admin_home;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfilePage extends StatefulWidget {
  final String userDocId;

  const AdminProfilePage({super.key, required this.userDocId});

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
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
            matricNo = userDoc["MatricNo"] ?? "N/A";
            icNo = userDoc["IC"] ?? "N/A";
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
      try {
        // Generate a unique file name
        String fileName = const Uuid().v4();

        // Get a reference to Firebase Storage
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageRef = storage.ref().child('profile_images/$fileName');

        // Upload the file to Firebase Storage
        UploadTask uploadTask = storageRef.putFile(_profileImage!);
        TaskSnapshot snapshot = await uploadTask;

        // Retrieve the download URL
        String uploadedImageUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore with the new image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userDocId)
            .update({'ProfileImageUrl': uploadedImageUrl});

        // Update local state with the new image URL
        setState(() {
          profileImageUrl = uploadedImageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Profile picture updated successfully!")),
        );
      } catch (e) {
        print("Error uploading profile image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile picture.")),
        );
      }
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
                    admin_home.HomePageAdmin(userDocId: widget.userDocId),
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
                                ? NetworkImage(profileImageUrl) as ImageProvider
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
                            builder: (context) => AdminEditProfilePage(
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

                        // If result is not null, update the local state
                        if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            name = result['Name'] ?? name;
                            className = result['Class'] ?? className;
                            matricNo = result['MatricNo'] ?? matricNo;
                            icNo = result['IC'] ?? icNo;
                            phone = result['NoPhone'] ?? phone;
                            address = result['Address'] ?? address;
                          });
                        }

                        // Optionally re-fetch data for consistency
                        await _fetchUserData();
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
