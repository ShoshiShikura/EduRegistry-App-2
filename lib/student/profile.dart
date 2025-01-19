import 'package:flutter/material.dart';
import 'edit_profile.dart';
import 'package:eduregistryselab/login_choice_page.dart';
import 'package:eduregistryselab/student/home_page.dart' as user_home;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool isLoading = true; // Add loading indicator state

  // Fetch user data from Firestore using userDocId
  Future<void> _fetchUserData() async {
    String id = widget.userDocId;
    print("Retrieved userDocId: $id");

    if (id.isNotEmpty) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        // Fetch user document from Firestore using userDocId
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(id).get();

        if (userDoc.exists) {
          print("Fetched user document: ${userDoc.data()}"); // Debug print

          setState(() {
            name = userDoc["Name"] ?? "N/A";
            className = userDoc["Class"] ?? "N/A";
            matricNo = userDoc["Matric No"] ?? "N/A";
            icNo = userDoc["IC No"] ?? "N/A";
            phone = userDoc["NoPhone"] ?? "N/A";
            address = userDoc["Address"] ?? "N/A";
            isLoading = false; // Data loaded
          });
        } else {
          print("User document does not exist.");
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
                    // Profile Icon Without Camera Icon
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.black54,
                        ),
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
                              userDocId: widget.userDocId, // FIX HERE
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
