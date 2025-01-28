import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;

  // Constructor to accept data for each activity
  const PlaceCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            12.0), // Optional: round corners of the image as well
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 100.0 / 100.0,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(imageUrl))),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  color: Colors.black
                      .withAlpha(150), // Background color with opacity
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Padding inside the card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating text
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Padding inside the card
              child: // Star Rating Section
                  Row(
                children: List.generate(5, (index) {
                  if (index < rating) {
                    // Filled star (using Icons.star)
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    );
                  } else if (index < rating && index + 0.5 == rating) {
                    // Half star (using Icons.star_half)
                    return Icon(
                      Icons.star_half,
                      color: Colors.amber,
                      size: 18,
                    );
                  } else {
                    // Empty star (using Icons.star_border)
                    return Icon(
                      Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
