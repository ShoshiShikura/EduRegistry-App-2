import 'package:flutter/material.dart';
import 'package:eduregistryselab/admin/home_page_admin.dart';

class ChartPage extends StatelessWidget {
  final String userDocId;

  const ChartPage({super.key, required this.userDocId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header with background color
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: const Color(0xFF0961F5), // Updated header color
                  child: const Center(
                    child: Text(
                      'Class vs Students',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Chart Container
                Expanded(
                  child: Center(
                    child: Container(
                      width: 350,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Number of Students per Class',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF545454),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Dummy Bar for Class A
                                _buildBar('A', 50, Colors.blue),
                                // Dummy Bar for Class B
                                _buildBar('B', 70, Colors.red),
                                // Dummy Bar for Class C
                                _buildBar('C', 30, Colors.green),
                                // Dummy Bar for Class D
                                _buildBar('D', 60, Colors.orange),
                                // Dummy Bar for Class E
                                _buildBar('E', 40, Colors.purple),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Classes',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF545454),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Back Button at the top-left corner
            Positioned(
              top: 10,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a dummy bar
  Widget _buildBar(String label, double height, Color color) {
    return Column(
      children: [
        Container(
          height: height, // Simulating the height of the bar
          width: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF545454),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: ChartPage(userDocId: "dummyUserDocId"), // Provide a valid userDocId
    ),
  );
}
