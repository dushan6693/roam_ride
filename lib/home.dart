import 'package:flutter/material.dart';
import 'package:fyp_roam_ride/activities/description_activities.dart';
import 'package:fyp_roam_ride/cards/activity_card.dart';
import 'package:fyp_roam_ride/cards/place_card.dart';
import 'package:fyp_roam_ride/places/description_places.dart';
import 'package:fyp_roam_ride/firebase/fire_store_service.dart';
import 'package:fyp_roam_ride/search_delegate.dart';
import 'package:fyp_roam_ride/activities/view_all_activities.dart';
import 'package:fyp_roam_ride/places/view_all_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'app_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? currentDistrict;
  String currentDif = 'Colombo'; //default value to currentDistrict
  static const List<String> sriLankaDistricts = [
    "Ampara",
    "Anuradhapura",
    "Badulla",
    "Batticaloa",
    "Colombo",
    "Galle",
    "Gampaha",
    "Hambantota",
    "Jaffna",
    "Kalutara",
    "Kandy",
    "Kegalle",
    "Kilinochchi",
    "Kurunegala",
    "Mannar",
    "Matale",
    "Matara",
    "Monaragala",
    "Mullaitivu",
    "Nuwara Eliya",
    "Polonnaruwa",
    "Puttalam",
    "Ratnapura",
    "Trincomalee",
    "Vavuniya"
  ];

  static const Map<String, List<String>> provinceToDistricts = {
    "Western Province": ["Colombo", "Gampaha", "Kalutara"],
    "Central Province": ["Kandy", "Matale", "Nuwara Eliya"],
    "Southern Province": ["Galle", "Matara", "Hambantota"],
    "Northern Province": [
      "Jaffna",
      "Kilinochchi",
      "Mannar",
      "Vavuniya",
      "Mullaitivu"
    ],
    "Eastern Province": ["Trincomalee", "Batticaloa", "Ampara"],
    "North Western Province": ["Kurunegala", "Puttalam"],
    "North Central Province": ["Anuradhapura", "Polonnaruwa"],
    "Uva Province": ["Badulla", "Monaragala"],
    "Sabaragamuwa Province": ["Ratnapura", "Kegalle"],
  };

  @override
  void initState() {
    super.initState();
    _getCurrentDistrict();
  }

  @override
  Widget build(BuildContext context) {
    FireStoreService fireStoreService = FireStoreService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: currentDistrict == null
          ? Center(
              child: Text('Just a moment...',
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.normal)))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Welcome to ${currentDistrict ?? currentDif}",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Popular Places",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to the "View All" page when the button is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewAllPlaces(
                                    currentDistrict ?? currentDif)),
                          );
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(fontSize: 16.0),
                        ),
                        child: Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: fireStoreService.getPlaces(currentDistrict ??
                        currentDif), // Pass district name here
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading places'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No data available'));
                      } else {
                        var places = snapshot.data as List;
                        return Expanded(
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: places.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, // 2 columns
                              childAspectRatio: 5 / 3.2,
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
                                            currentDistrict ?? currentDif,
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Popular Activities",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to the "View All" page when the button is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewAllActivities(
                                    currentDistrict ?? currentDif)),
                          );
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(fontSize: 16.0),
                        ),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: fireStoreService
                        .getPopularActivities(), // Similar function for activities
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading activities'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No data available'));
                      } else {
                        var activities = snapshot.data as List;
                        return Expanded(
                          child: GridView.builder(
                            itemCount: activities.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 columns
                              childAspectRatio: 12 / 4,
                              crossAxisSpacing: 5, // Space between columns
                              mainAxisSpacing: 5, // Space between rows
                            ),
                            itemBuilder: (context, index) {
                              var activity = activities[index];
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DescriptionActivities(
                                                  activity['id'])),
                                    );
                                  },
                                  child: ActivityCard(name: activity['name']));
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _getCurrentDistrict() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw Exception("Location permission denied");
        }
      }

      // Get current location
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      );

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      // Get address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Match district or show province selection dialog
      if (placemarks.isNotEmpty) {
        String? areaName = placemarks[0].administrativeArea?.trim();
        if (provinceToDistricts.containsKey(areaName)) {
          // Show district selection dialog if province is identified
          List<String> districts = provinceToDistricts[areaName]!;
          _showDistrictSelectionDialog(districts);
        } else {
          // Match district directly if found
          String? matchedDistrict = sriLankaDistricts.firstWhere(
              (district) => district.toLowerCase() == areaName?.toLowerCase(),
              orElse: () => "District not recognized");

          setState(() {
            currentDistrict = matchedDistrict;
          });
        }
      }
    } catch (e) {
      // print("Error: $e");
      setState(() {
        currentDistrict = "Error: ${e.toString()}";
      });
    }
  }

  void _showDistrictSelectionDialog(List<String> districts) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Text("Where are you now?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: districts
                .map((district) => ListTile(
                      title: Text(district),
                      onTap: () {
                        setState(() {
                          currentDistrict = district;
                        });
                        Navigator.of(context).pop();
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
