import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduregistryselab/student/profile.dart';
import 'package:eduregistryselab/student/appointment.dart';

class HomePage extends StatelessWidget {
  final String userDocId;

  const HomePage({super.key, required this.userDocId});

  Future<String> _fetchUserName() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['Name'] ?? 'Student'; // Fetch 'Name' field
      } else {
        throw Exception("User document not found.");
      }
    } catch (e) {
      throw Exception("Error fetching user data: $e");
    }
  }

  Future<bool> _onWillPop() async {
    return false; // Disables back button functionality
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF3FF), // Light blue background
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Hides the back button
          title: FutureBuilder<String>(
            future: _fetchUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                  'Hi, Student',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                );
              } else if (snapshot.hasError) {
                return const Text(
                  'Hi, Student',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                );
              } else {
                return Text(
                  'Hi, ${snapshot.data}',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                // Handle notifications here
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What Would you like to learn Today?\nSearch Below.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  // Featured Card
                  Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'WEEK 7',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Nilam Week\nGET YOUR MERIT BY JOINING OUR PROGRAM',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Merit System and Appointment Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the Merit System Page
                          Navigator.pushNamed(context, '/grade_page');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: const Text(
                          "MERIT SYSTEM",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the Appointment Page
                          Navigator.pushNamed(context, '/appointment');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        child: const Text(
                          "APPOINTMENT",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Ranking Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Ranking",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "SEE ALL",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Tabs for rankings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Chip(
                        label: const Text("All"),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.blue),
                      ),
                      Chip(
                        label: const Text(
                          "KELAS TERBERSIH",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      Chip(
                        label: const Text("Merit Tertinggi"),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Ranking Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: const Text(
                        "1.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: const Text("KELAS 5 BIJAK"),
                      subtitle: const Text("850/-  |  4.2  |  7830 Std"),
                      trailing: const Icon(Icons.star, color: Colors.yellow),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          onTap: (index) async {
            if (index == 0) {
              Navigator.pushNamed(context, '/main'); // Navigate to HomePage
            } else if (index == 1) {
              Navigator.pushNamed(
                  context, '/grade_page'); // Navigate to GradePage
            } else if (index == 2) {
              Navigator.pushNamed(
                  context, '/notifications'); // Notifications Page
            } else if (index == 3) {
              Navigator.pushNamed(context, '/chat'); // Chat Page
            } else if (index == 4) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? userDocId = prefs.getString('userDocId');
              if (userDocId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userDocId: userDocId),
                  ),
                );
              } else {
                print('UserDocId is null');
              }
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grade),
              label: 'Grade',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
