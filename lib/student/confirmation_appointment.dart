import 'package:flutter/material.dart';
import 'appointment.dart'; // Import the AppointmentPage

class ConfirmationAppointment extends StatelessWidget {
  final String? selectedStudent;
  final DateTime? selectedDate;
  final String? selectedTime;

  const ConfirmationAppointment({
    super.key,
    required this.selectedStudent,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    // Format the date to a more user-friendly format
    String formattedDate =
        "${selectedDate?.day.toString().padLeft(2, '0')}-${(selectedDate?.month ?? 1).toString().padLeft(2, '0')}-${selectedDate?.year ?? 0}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Appointment Confirmation',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display selected student
            Text(
              'Student: $selectedStudent',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Display selected date and time
            Text(
              'Date: $formattedDate',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Time: $selectedTime',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Hardcoded teacher name (as per the initial RequestPage)
            const Text(
              'Teacher: Siti Amirah Binti Razak',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Confirm button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Show SnackBar notification
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Appointment request has been submitted!')),
                  );

                  // After showing the SnackBar, navigate to the AppointmentPage
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppointmentPage(),
                      ),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('CONFIRM APPOINTMENT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
