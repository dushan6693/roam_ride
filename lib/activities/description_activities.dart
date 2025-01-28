import 'package:flutter/material.dart';
import 'package:fyp_roam_ride/firebase/fire_store_service.dart';

class DescriptionActivities extends StatefulWidget {
  final String id;
  const DescriptionActivities(this.id, {super.key});

  @override
  State<DescriptionActivities> createState() => DescriptionActivitiesState();
}

class DescriptionActivitiesState extends State<DescriptionActivities> {
  FireStoreService fireStoreService = FireStoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
        ),
        body: FutureBuilder(
            future: fireStoreService.getActivity(widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading activities'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              } else {
                var data = snapshot.data;
                return Center(
                  child: Text(
                      'Activity details here, id:${data?['id']}name:${data?['name']}'),
                );
              }
            }));
  }
}
