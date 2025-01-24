import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration
import 'dart:math';

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  String selectedMonth = "JANUARY"; // Default selected month
  List<String> months = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER'
  ];

  Future<List<Map<String, dynamic>>> fetchMeritData(String month) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('merit')
        .where('Timestamp',
            isGreaterThanOrEqualTo:
                DateTime(DateTime.now().year, months.indexOf(month) + 1, 1))
        .where('Timestamp',
            isLessThan:
                DateTime(DateTime.now().year, months.indexOf(month) + 2, 1))
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  void addPresetMeritData() async {
    final List<Map<String, dynamic>> presetData = List.generate(15, (index) {
      final random = Random();
      return {
        "MatricNo": "MATRIC-${1000 + index}",
        "MeritValue": random.nextInt(200), // Values from 0 to 199
        "ReviewComments": "Sample comment ${index + 1}",
        "Timestamp": DateTime(
          2023,
          random.nextInt(12) + 1,
          random.nextInt(28) + 1,
        ),
      };
    });

    final batch = FirebaseFirestore.instance.batch();
    for (var data in presetData) {
      final docRef = FirebaseFirestore.instance.collection('merit').doc();
      batch.set(docRef, data);
    }
    await batch.commit();
    print("Preset merit data added successfully!");
  }

  @override
  void initState() {
    super.initState();
    // Uncomment the next line to populate Firestore with preset data
    // addPresetMeritData();
  }

  Color getColorForMerit(int meritValue) {
    if (meritValue < 10) {
      return Colors.red[100]!; // Light red
    } else if (meritValue >= 11 && meritValue <= 50) {
      return Colors.yellow[100]!; // Light yellow
    } else if (meritValue >= 51 && meritValue <= 150) {
      return Colors.green[100]!; // Light green
    } else {
      return Colors.purple[100]!; // Light purple
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistic'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Mark added mark\nof Students',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          // Chart Section (Fetching Data)
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchMeritData(selectedMonth),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final meritData = snapshot.data!;
                  return meritData.isNotEmpty
                      ? ListView.builder(
                          itemCount: meritData.length,
                          itemBuilder: (context, index) {
                            final data = meritData[index];
                            return Card(
                              color: getColorForMerit(data['MeritValue']),
                              child: ListTile(
                                title: Text("MatricNo: ${data['MatricNo']}"),
                                subtitle: Text("Comment: ${data['ReviewComments']}"),
                                trailing: Text("Merit: ${data['MeritValue']}"),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text('No data available for $selectedMonth.'),
                        );
                } else {
                  return Center(child: Text('No merit data found.'));
                }
              },
            ),
          ),
          SizedBox(height: 16),
          // Horizontal Scrollable Months Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: months.map((month) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        selectedMonth = month;
                      });
                    },
                    child: Text(
                      month,
                      style: TextStyle(
                        color:
                            selectedMonth == month ? Colors.white : Colors.blue,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: selectedMonth == month
                          ? Colors.green
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Add functionality for print or navigation
              print("Printing Statistics...");
            },
            icon: Icon(Icons.print),
            label: Text('Print'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
