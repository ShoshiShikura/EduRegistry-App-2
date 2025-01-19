import 'package:flutter/material.dart';
import 'package:eduregistryselab/student/upcoming_page.dart';
import 'package:eduregistryselab/student/request_page.dart';
import 'package:eduregistryselab/student/approval_page.dart';
import 'package:eduregistryselab/student/history_page.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'APPOINTMENT',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to the RequestPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RequestPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('REQUEST NEW APPOINTMENT'),
              ),
              const SizedBox(height: 20),
              _buildSection(
                  context,
                  'Upcoming',
                  [
                    _buildAppointmentCard(
                      name: 'Muhammad Afiq Bin Amran',
                      dateTime: '11/4/2024 8.00 AM',
                      teacherName: 'Kamarul Bin Ishak',
                      /*buttons: [
                        _buildActionButton('CHANGE', Colors.blue, Colors.white),
                        _buildActionButton('CANCEL', Colors.red, Colors.white),
                      ],*/
                    ),
                  ],
                  const UpcomingPage()),
              const SizedBox(height: 20),
              _buildSection(
                  context,
                  'Request',
                  [
                    _buildAppointmentCard(
                      name: 'Muhammad Afiq Bin Amran',
                      dateTime: '11/4/2024 8.00 AM',
                      teacherName: 'Kamarul Bin Ishak',
                      buttons: [
                        _buildActionButton('CHANGE', Colors.blue, Colors.white),
                        _buildActionButton('CANCEL', Colors.red, Colors.white),
                      ],
                    ),
                  ],
                  const RequestPage()),
              const SizedBox(height: 20),
              _buildSection(
                  context,
                  'Approval',
                  [
                    _buildAppointmentCard(
                      name: 'Muhammad Afiq Bin Amran',
                      dateTime: '11/4/2024',
                      teacherName: 'Kamarul Bin Ishak',
                      buttons: [
                        _buildActionButton('ACCEPT', Colors.blue, Colors.white),
                        _buildActionButton('DENY', Colors.red, Colors.white),
                      ],
                    ),
                  ],
                  const ApprovalPage()),
              const SizedBox(height: 20),
              _buildSection(
                  context,
                  'History',
                  [
                    _buildAppointmentCard(
                      name: 'Muhammad Afiq Bin Amran',
                      dateTime: '11/12/2024',
                      teacherName: 'Siti Amirah Binti Razak',
                    ),
                  ],
                  const HistoryPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title,
      List<Widget> children, Widget navigateToPage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => navigateToPage),
                );
              },
              child: const Text(
                'View All',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        Column(children: children),
      ],
    );
  }

  Widget _buildAppointmentCard({
    required String name,
    required String dateTime,
    required String teacherName,
    List<Widget>? buttons,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            const SizedBox(height: 8),
            Text('Date & Time: $dateTime'),
            const SizedBox(height: 8),
            Text('Teacher Name: $teacherName'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buttons ?? [const SizedBox.shrink()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, Color textColor) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
