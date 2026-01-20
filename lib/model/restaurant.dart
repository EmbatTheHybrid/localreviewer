
import 'package:home_assignment/model/review.dart';

class Restaurant {

  final String name;
  final String restaurantImage;
  final double rating;
  final Review review;

  const Restaurant({
    required this.name,
    required this.restaurantImage,
    required this.rating,
    required this.review
  });

  @override
  String toString() {
    return "$name--$restaurantImage--$rating--$review";
  }
}