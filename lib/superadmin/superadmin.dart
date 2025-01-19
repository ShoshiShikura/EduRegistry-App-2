import 'package:flutter/material.dart';
import 'package:eduregistryselab/superadmin/statisticPage.dart'; // Import the StatisticPage
import 'package:eduregistryselab/superadmin/student_page.dart'; // Import the StudentPage
import 'package:eduregistryselab/superadmin/teacher_page.dart'; // Import the TeacherPage
import 'package:eduregistryselab/login_choice_page.dart'; // Import the TeacherPage

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import this package

class SuperAdminPage extends StatelessWidget {
  final String userDocId;

  const SuperAdminPage({super.key, required this.userDocId});

  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data()!;
      } else {
        throw Exception("User document not found.");
      }
    } catch (e) {
      throw Exception("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable the back button
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false, // Remove back button
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton(
                onPressed: () async {
                  // Clear SharedPreferences and navigate back to login page
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginChoicePage()),
                  );
                },
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
        body: FutureBuilder<Map<String, dynamic>>(
          future: _fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final userData = snapshot.data!;
              final String userName = userData['Name'] ?? 'User';

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personalized Greeting Section
                      Text(
                        'Hi, $userName',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                          'What would you like to learn today? Search Below.'),
                      const SizedBox(height: 16),

                      // WEEK 7 DASHBOARD button linked to StatisticPage
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the Statistic Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StatisticPage()),
                            );
                          },
                          child: const Text(
                            'WEEK 7\nDASHBOARD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Navigation Buttons for Student and Teacher Pages
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to StudentPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StudentPage(userDocId: userDocId)),
                              );
                            },
                            child: const Text('STUDENT'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to TeacherPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TeacherPage(userDocId: userDocId)),
                              );
                            },
                            child: const Text('TEACHER'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // List Of Section
                      const Text('List Of'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {}, child: const Text('All')),
                          TextButton(
                              onPressed: () {}, child: const Text('Teacher')),
                          TextButton(
                              onPressed: () {}, child: const Text('Student')),
                          TextButton(
                              onPressed: () {}, child: const Text('SEE ALL')),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Dummy User List Section
                      ...List.generate(4, (index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text('User ${index + 1}'),
                            subtitle: const Text('1 AMANAH'),
                            trailing: Text('${105 - index}'),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No user data available.'));
            }
          },
        ),
        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Grade'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notification'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: 'Statistic'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
