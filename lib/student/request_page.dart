import 'package:flutter/material.dart';
import 'confirmation_appointment.dart'; // Import the confirmation appointment page

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String? selectedStudent;
  DateTime? selectedDate = DateTime.now();
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'REQUEST PAGE',
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
              _buildStepHeader('Choose Student'),
              _buildStudentList(),
              const SizedBox(height: 20),
              _buildStepHeader('Set Date'),
              _buildDatePicker(),
              const SizedBox(height: 20),
              _buildStepHeader('Set Time'),
              _buildTimePicker(),
              const SizedBox(height: 20),
              // Remove the confirmation card
              // _buildStepHeader('Confirm Appointment'),
              // _buildConfirmationCard(),
              const SizedBox(height: 20),
              // Updated button to navigate to ConfirmationAppointment
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Check if all necessary fields are filled
                    if (selectedStudent != null &&
                        selectedDate != null &&
                        selectedTime != null) {
                      // Navigate to the confirmation page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmationAppointment(
                            selectedStudent: selectedStudent,
                            selectedDate: selectedDate,
                            selectedTime: selectedTime,
                          ),
                        ),
                      );
                    } else {
                      // If not all fields are filled, show a message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please complete all fields.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('SUBMIT REQUEST'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStudentList() {
    final students = ['Jamal Musiala', 'Akmal'];
    return Column(
      children: students
          .map(
            (student) => ListTile(
              title: Text(student),
              subtitle: const Text('SK Kampung Padang'),
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              trailing: Radio<String>(
                value: student,
                groupValue: selectedStudent,
                onChanged: (value) {
                  setState(() {
                    selectedStudent = value;
                  });
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDatePicker() {
    return CalendarDatePicker(
      initialDate: selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      onDateChanged: (date) {
        setState(() {
          selectedDate = date;
        });
      },
    );
  }

  Widget _buildTimePicker() {
    final times = ['8.00 AM', '9.00 AM', '10.00 AM', '11.00 AM', '12.00 PM'];
    return Column(
      children: times
          .map(
            (time) => ListTile(
              title: Text(time),
              trailing: Radio<String>(
                value: time,
                groupValue: selectedTime,
                onChanged: (value) {
                  setState(() {
                    selectedTime = value;
                  });
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
