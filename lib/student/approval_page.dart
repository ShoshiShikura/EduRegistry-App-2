import 'package:flutter/material.dart';

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Appointments'),
      ),
      body: const Center(
        child: Text('Approval Appointments Page'),
      ),
    );
  }
}
