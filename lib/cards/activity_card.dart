import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String name;

  // Constructor to accept data for each activity
  const ActivityCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // Controls the shadow depth
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Optional: round the corners
      ),
      margin: const EdgeInsets.all(8.0), // Add margin around the card
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Padding inside the card
        child: Text(
          name, // Only the activity name is displayed here
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
