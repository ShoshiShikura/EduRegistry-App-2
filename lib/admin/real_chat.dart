import 'package:flutter/material.dart';

// Main Chat Page
class RealChat extends StatelessWidget {
  final String userDocId;

  const RealChat({super.key, required this.userDocId});

  @override
  Widget build(BuildContext context) {
    // List of students with their classes
    final List<Map<String, String>> chats = [
      {"name": "Puan Siti", "class": "KELAS 5 BIJAK"},
      {"name": "Nurul", "class": "KELAS 6 CERDIK"},
      {"name": "Syafiq", "class": "KELAS 5 PANDAI"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
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
    );
  }
}

class ChatCard extends StatelessWidget {
  final String name;
  final String studentClass;
  final VoidCallback onTap;

  const ChatCard({
    super.key,
    required this.name,
    required this.studentClass,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(studentClass),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.black54),
      ),
    );
  }
}

// Chat Details Page
class ChatDetailPage extends StatelessWidget {
  final String name;

  const ChatDetailPage(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          name,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Chat conversation example
          Expanded(
            child: ListView(
              children: [
                // Teacher's message
                ChatBubble(
                  message:
                      "Hello, Syafiq! I would like to discuss your merit today.",
                  isTeacher: true,
                ),
                // Student's response
                ChatBubble(
                  message: "Sure, Puan Siti! I'm ready to hear your feedback.",
                  isTeacher: false,
                ),
                // Teacher's message
                ChatBubble(
                  message:
                      "You've been doing well in class, but I need to see more involvement in group activities.",
                  isTeacher: true,
                ),
                // Student's response
                ChatBubble(
                  message:
                      "I understand. I'll work on it and try to contribute more.",
                  isTeacher: false,
                ),
                // Teacher's message
                ChatBubble(
                  message:
                      "Great! I'll update your merit points soon. Keep up the good work!",
                  isTeacher: true,
                ),
              ],
            ),
          ),
          // Text input field for new messages
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Send the message (implement message sending logic)
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Chat Bubble for displaying messages
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isTeacher;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isTeacher,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isTeacher ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isTeacher ? Colors.blue : Colors.green,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isTeacher ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
