import 'package:flutter/material.dart';
import 'package:eduregistryselab/superadmin/statisticPage.dart';
import 'package:eduregistryselab/superadmin/student_page.dart';
import 'package:eduregistryselab/superadmin/teacher_page.dart';
import 'package:eduregistryselab/login_choice_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuperAdminPage extends StatefulWidget {
  final String userDocId;

  const SuperAdminPage({super.key, required this.userDocId});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  String filterRole = "All"; // Default filter for displaying all users

  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userDocId)
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

  Stream<QuerySnapshot> _getFilteredUsers() {
    if (filterRole == "All") {
      return FirebaseFirestore.instance.collection('users').snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('users')
          .where('Role', isEqualTo: filterRole)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton(
                onPressed: () async {
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting and Dashboard Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StatisticPage()),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Navigation Buttons for Student and Teacher Pages
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StudentPage(userDocId: widget.userDocId)),
                            );
                          },
                          child: const Text('STUDENT'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TeacherPage(userDocId: widget.userDocId)),
                            );
                          },
                          child: const Text('TEACHER'),
                        ),
                      ],
                    ),
                  ),

                  // Filter Buttons for List of Users
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              filterRole = "All";
                            });
                          },
                          child: const Text('All'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              filterRole = "Admin";
                            });
                          },
                          child: const Text('Teacher'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              filterRole = "Student";
                            });
                          },
                          child: const Text('Student'),
                        ),
                      ],
                    ),
                  ),

                  // User List Section
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _getFilteredUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No users found.'),
                          );
                        }

                        final users = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index].data()
                                as Map<String, dynamic>; // Cast Firestore data
                            final name = user['Name'] ?? 'Unknown';
                            final userClass = user['Class'] ?? 'Unknown';

                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(name),
                                subtitle: Text(userClass),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No user data available.'));
            }
          },
        ),
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
