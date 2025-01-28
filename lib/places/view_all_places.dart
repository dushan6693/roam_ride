import 'package:flutter/material.dart';

import '../cards/place_card.dart';
import 'description_places.dart';
import '../firebase/fire_store_service.dart';

class ViewAllPlaces extends StatefulWidget {
  final String currentDistrict;
  const ViewAllPlaces(this.currentDistrict, {super.key});
  @override
  State<ViewAllPlaces> createState() => _ViewAllPlacesState();
}

class _ViewAllPlacesState extends State<ViewAllPlaces> {
  @override
  Widget build(BuildContext context) {
    FireStoreService fireStoreService = FireStoreService();
    return Scaffold(
      appBar: AppBar(
        title: Text('All Places in ${widget.currentDistrict}'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fireStoreService.getPlaces(widget.currentDistrict),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No places available'));
          } else {
            final places = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: places.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  childAspectRatio: 3.2 / 5,
                  crossAxisSpacing: 5, // Space between columns
                  mainAxisSpacing: 5, // Space between rows
                ),
                itemBuilder: (context, index) {
                  var activity = places[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DescriptionPlaces(
                                widget.currentDistrict,
                                activity['place'],
                                activity['id'])),
                      );
                    },
                    child: PlaceCard(
                      imageUrl: activity['image_url'],
                      name: activity['place'],
                      rating: activity['rating'],
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
