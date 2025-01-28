import 'package:flutter/material.dart';
import 'package:fyp_roam_ride/firebase/fire_store_service.dart';

class DescriptionPlaces extends StatelessWidget {
  final String place;
  final String id;
  final String district;

  final Map<int, String> typeMap = {
    1: "Religious",
    2: "Hotel",
    3: "Villa",
    4: "Nature",
    5: "Historical",
    6: "Museum",
    7: "Beach"
  };

  DescriptionPlaces(this.district, this.place, this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    FireStoreService fireStoreService = FireStoreService();
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: FutureBuilder(
          future: fireStoreService.getPlace(district, id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading places'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image section
                    Image.network(
                      snapshot.data?['image_url'],
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Place name
                          Text(
                            snapshot.data?["place"],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),

                          // District
                          Text(
                            "District: ${snapshot.data?["district"]}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 8),

                          // Duration
                          Text(
                            "Duration: ${snapshot.data?["duration"]} minutes",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 8),

                          // Type
                          Text(
                            "Type: ${typeMap[snapshot.data?["type"]] ?? "Unknown"}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 8),

                          // Rating
                          Row(
                            children: [
                              Text(
                                "Rating: ",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700]),
                              ),
                              ...List.generate(5, (index) {
                                return Icon(
                                  index < snapshot.data?["rating"]
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: 16),

                          // Description
                          Text(
                            "Description:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            snapshot.data?["description"],
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
