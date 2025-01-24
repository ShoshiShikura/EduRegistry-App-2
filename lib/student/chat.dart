import 'package:eduregistryselab/admin/real_chat.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required String userDocId});

  @override
  Widget build(BuildContext context) {
    // Sample chat data
    final List<Map<String, String>> chats = [
      {"name": "Puan Siti", "class": "KELAS 5 BIJAK"},
      {"name": "Nurul", "class": "KELAS 6 CERDIK"},
      {"name": "Syafiq", "class": "KELAS 5 PANDAI"},
      {"name": "Siti", "class": "KELAS 4 BIJAK"},
      {"name": "Zainab", "class": "KELAS 5 AMANAH"},
      {"name": "Hafiz", "class": "KELAS 4 PANDAI"},
      {"name": "Ismail", "class": "KELAS 4 BIJAK"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF), // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Chat",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Container(), // Removes the back button
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ChatCard(
                name: chat["name"]!,
                studentClass: chat["class"]!,
                onTap: () {
                  // Handle navigation to specific chat screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailPage(chat["name"]!),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // Set "Chat" as the selected index
        onTap: (index) {
          // Handle navigation based on index
          if (index == 0) {
            Navigator.pushNamed(context, '/home_page');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/grade_page');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/notifications');
          } else if (index == 3) {
            // Stay on Chat page
          } else if (index == 4) {
            Navigator.pushNamed(context, '/profile');
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
    );
  }
}
