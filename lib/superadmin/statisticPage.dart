import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticPage extends StatelessWidget {
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
              'Total Mark add and deducted mark\nNumber of Student and Teacher',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          // Add a placeholder for the chart
          Expanded(
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                color: Colors.blue.shade50,
                child: Center(
                  child: Text(
                    'Chart Placeholder',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Month Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['AUG', 'SEP', 'OCT', 'NOV', 'DEC'].map((month) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () {
                    // Implement month selection logic if needed
                  },
                  child: Text(
                    month,
                    style: TextStyle(
                      color: month == 'DEC' ? Colors.white : Colors.blue,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        month == 'DEC' ? Colors.green : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Add functionality for print or navigation
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
