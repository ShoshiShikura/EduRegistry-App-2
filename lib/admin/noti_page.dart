import 'package:flutter/material.dart';

class NotiPage extends StatelessWidget {
  final String userDocId;

  const NotiPage({super.key, required this.userDocId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF), // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notification',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SectionHeader(title: "Today"),
              NotificationCard(
                icon: Icons.category,
                title: "New Student has been added!",
                description: "Rachel Awind Anak Awi",
                isHighlighted: true,
              ),
              NotificationCard(
                icon: Icons.category_outlined,
                title: "Merit has been added!",
                description: "Danny Chong.",
              ),
              NotificationCard(
                icon: Icons.local_offer,
                title: "Merit has been added!",
                description: "Liu Xin Xin",
              ),
              const SectionHeader(title: "Yesterday"),
              NotificationCard(
                icon: Icons.credit_card,
                title: "New student has been added!",
                description: "Christopher Anak Ngau",
              ),
              const SectionHeader(title: "Nov 20, 2022"),
              NotificationCard(
                icon: Icons.account_circle,
                title: "Merit has been added!",
                description: "Daniel Hamidi bin Abu",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isHighlighted;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: isHighlighted ? Colors.blue.shade50 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
