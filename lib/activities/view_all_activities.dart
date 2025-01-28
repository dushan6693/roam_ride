import 'package:flutter/material.dart';
import 'package:fyp_roam_ride/cards/activity_card.dart';

import '../cards/place_card.dart';
import '../places/description_places.dart';
import '../firebase/fire_store_service.dart';

class ViewAllActivities extends StatefulWidget {
  final String currentDistrict;
  const ViewAllActivities(this.currentDistrict, {super.key});
  @override
  State<ViewAllActivities> createState() => _ViewAllActivitiesState();
}

class _ViewAllActivitiesState extends State<ViewAllActivities> {
  @override
  Widget build(BuildContext context) {
    FireStoreService fireStoreService = FireStoreService();
    return Scaffold(
      appBar: AppBar(
        title: Text('All Activities in ${widget.currentDistrict}'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fireStoreService.getPopularActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No activities available'));
          } else {
            final activities = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: activities.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  childAspectRatio: 3.2 / 5,
                  crossAxisSpacing: 5, // Space between columns
                  mainAxisSpacing: 5, // Space between rows
                ),
                itemBuilder: (context, index) {
                  var activity = activities[index];

                  return GestureDetector(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => Description(
                    //             widget.currentDistrict, activity['name'], activity['id'])),
                    //   );
                    // },
                    child: ActivityCard(
                      name: activity['name'],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
