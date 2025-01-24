import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                      width: 400, // Chart container width
                      height: 500, // Chart container height
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade400, // Added border
                          width: 2,
                        ),
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
                            child: FutureBuilder<Map<String, int>>(
                              future: _fetchClassData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.hasData) {
                                  final classData = snapshot.data!;
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            // Class Labels
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: classData.keys
                                                  .map((className) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4.0),
                                                  child: Text(
                                                    className,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF545454),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            const SizedBox(width: 16),
                                            // Horizontal Bars
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: classData.entries
                                                    .map((entry) {
                                                  final className = entry.key;
                                                  final studentCount =
                                                      entry.value;
                                                  return _buildHorizontalBar(
                                                    studentCount.toDouble() *
                                                        10, // Scale bar length
                                                    Colors.primaries[
                                                        className.hashCode %
                                                            Colors.primaries
                                                                .length],
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // Legend
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 12,
                                        runSpacing: 8,
                                        children:
                                            classData.entries.map((entry) {
                                          final className = entry.key;
                                          final color = Colors.primaries[
                                              className.hashCode %
                                                  Colors.primaries.length];
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                color: color,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                className,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF545454),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Center(
                                      child: Text('No class data found.'));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a horizontal bar
  Widget _buildHorizontalBar(double width, Color color) {
    return Container(
      height: 20,
      width: width, // Simulated width of the bar
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // Fetch class data from Firestore and count students per class
  Future<Map<String, int>> _fetchClassData() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final Map<String, int> classCounts = {};

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final className = data['Class'] as String?;

      if (className != null) {
        classCounts[className] = (classCounts[className] ?? 0) + 1;
      }
    }

    return classCounts;
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: ChartPage(userDocId: "dummyUserDocId"), // Provide a valid userDocId
    ),
  );
}
