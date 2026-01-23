import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:local_reviewer/model/restaurant.dart';
import 'package:local_reviewer/screens/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({super.key, required this.restaurant, required this.index, required this.prefs, required this.refresh});

  final Restaurant restaurant;
  final int index;
  final SharedPreferences prefs;
  
  final Function refresh;

  void viewDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => DetailsPage(
        restaurant: restaurant,
        prefs: prefs,
        index: index,
      ))
    ).then((_) => {
      refresh()
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          viewDetails(context);
        },
        child: Column(
          children: [
            Image.file(
              File(restaurant.restaurantImage),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
           Container(
                color: Theme.of(context).colorScheme.inversePrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 44,
                ),
                child: Column(
                  children: [
                    Text(
                      restaurant.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis, // Very long text ...
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StarRating(rating: restaurant.rating, color: Theme.of(context).colorScheme.primary, borderColor: Theme.of(context).colorScheme.primary,),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  
}