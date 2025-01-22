import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_merit.dart';
import 'package:eduregistryselab/student/appointment.dart';
import 'chart_page.dart';
import 'real_chat.dart';
import 'profile_page.dart';
import 'noti_page.dart';

class HomePageAdmin extends StatefulWidget {
  final String userDocId;

  const HomePageAdmin({super.key, required this.userDocId});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeContent(userDocId: widget.userDocId),
      ChartPage(userDocId: widget.userDocId),
      NotiPage(userDocId: widget.userDocId),
      RealChat(userDocId: widget.userDocId),
      AdminProfilePage(userDocId: widget.userDocId),
    ];
  }

  Future<String> _fetchUserName() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userDocId)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['Name'] ?? 'Admin'; // Fetch 'Name' field
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
        backgroundColor: const Color(0xFFEAF3FF),
        appBar: _currentIndex == 0
            ? AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                title: FutureBuilder<String>(
                  future: _fetchUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Hi, Admin',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Hi, Admin',
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
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.userDocId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey,
                        );
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          !snapshot.data!.exists) {
                        return const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey,
                          child:
                              Icon(Icons.person, size: 15, color: Colors.white),
                        );
                      } else {
                        final data = snapshot.data?.data()
                            as Map<String, dynamic>?; // Safely cast to Map
                        final profilePicUrl =
                            data?['ProfileImageUrl']; // Access field

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminProfilePage(
                                    userDocId: widget.userDocId),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: profilePicUrl != null
                                ? NetworkImage(profilePicUrl)
                                : null,
                            backgroundColor: Colors.grey,
                            child: profilePicUrl == null
                                ? const Icon(Icons.person,
                                    size: 15, color: Colors.white)
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              )
            : null,
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Chart',
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

class HomeContent extends StatelessWidget {
  final String userDocId;

  const HomeContent({super.key, required this.userDocId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What would you like to learn today?",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            // Blue Card for Dashboard
            Card(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WEEK 7',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
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
            const SizedBox(height: 16),
            // Buttons for Merit System and Appointment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMerit(),
                      ),
                    );
                  },
                  child: const Text("MERIT SYSTEM"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentPage(),
                      ),
                    );
                  },
                  child: const Text("APPOINTMENT"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "SEE ALL",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Filters for Ranking
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Chip(label: Text("All")),
                Chip(label: Text("KELAS TERBERSIH")),
                Chip(label: Text("Merit Tertinggi")),
              ],
            ),
            const SizedBox(height: 16),
            // Example Ranking Item
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    "1",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text("KELAS 5 BIJAK"),
                subtitle: Text("850/- | 4.2 | 7830 Std"),
                trailing: Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
