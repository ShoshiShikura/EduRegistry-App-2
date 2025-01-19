import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package

class AddMerit extends StatefulWidget {
  const AddMerit({super.key});

  @override
  _AddMeritState createState() => _AddMeritState();
}

class _AddMeritState extends State<AddMerit> {
  final TextEditingController _matricController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  final Map<String, int> _goodDeeds = {
    'Clean the desk': 1,
    'Help a friend': 2,
    'Submit homework on time': 3,
    'Participate in class': 2,
    'Volunteer for tasks': 5,
    'Organize study group': 4,
    'Help teacher': 3,
    'Recycle waste': 1,
    'Show kindness': 2,
    'Maintain class decorum': 3
  }; // Good deeds and merit values

  String? _selectedDeed;

  void _submitMerit() async {
    String matricNumber = _matricController.text.trim();
    String reviewComments = _reviewController.text.trim();
    int meritValue = _goodDeeds[_selectedDeed] ?? 0;

    if (matricNumber.isEmpty || _selectedDeed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    try {
      // Reference to Firestore
      final firestore = FirebaseFirestore.instance;

      // Check if Matric No exists in 'users' collection
      final userDoc =
          await firestore.collection('users').doc(matricNumber).get();

      if (userDoc.exists) {
        // Update TotalMerit in the 'users' collection
        int currentMerit = userDoc.data()?['TotalMerit'] ?? 0;
        await firestore.collection('users').doc(matricNumber).update({
          'TotalMerit': currentMerit + meritValue,
        });

        // Add entry to the 'merit' collection
        await firestore.collection('merit').add({
          'MatricNo': matricNumber,
          'MeritValue': meritValue,
          'ReviewComments': reviewComments,
          'Timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Merit added successfully for Matric No: $matricNumber')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Matric No: $matricNumber not found in users collection.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add Merit',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Matric Number:',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _matricController,
              decoration: const InputDecoration(
                hintText: 'Enter Student Matric Number',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Good Deed:',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: _selectedDeed,
              hint: const Text('Select a good deed'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDeed = newValue;
                });
              },
              items:
                  _goodDeeds.keys.map<DropdownMenuItem<String>>((String deed) {
                return DropdownMenuItem<String>(
                  value: deed,
                  child: Text(deed),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            const Text(
              'Review Comments:',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                hintText: 'Write your review here',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitMerit,
                child: const Text('Submit Merit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
