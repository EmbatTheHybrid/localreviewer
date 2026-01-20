import 'package:flutter/material.dart';
import 'package:home_assignment/model/restaurant.dart';
import 'package:home_assignment/model/review.dart';
import 'package:home_assignment/screens/form.dart';
import 'package:home_assignment/widgets/restaurant_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title, required this.prefs});

  final String title;
  final SharedPreferences prefs;

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _counter = 0;

  List<Restaurant> restaurants = [];

  void _addRestaurant() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => FormPage(prefs: widget.prefs,))
    ).then((_) {
      setState(() {});
    });

    
  }

  List<Restaurant> convertToRestaurant() {
    if (widget.prefs.getStringList("restaurants") == null ) {
      return [];
    }
    List<String> list = widget.prefs.getStringList("restaurants")!;

    List<Restaurant> tbl = [];

    for (var restaurantStr in list) {
      var split = restaurantStr.split("--");
      Review review = Review(title: split[3], content: split[4], reviewImage: split[5]);
      Restaurant restaurant = Restaurant(name: split[0], restaurantImage: split[1], rating: double.parse(split[2]), review: review);

      tbl.add(restaurant);
    }

    return tbl;
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   widget.prefs.setStringList("restaurants", []);
  // }

  @override
  Widget build(BuildContext context) {
    restaurants = convertToRestaurant();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            shrinkWrap: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: restaurants.length,
            itemBuilder: (_, int index) {
              return RestaurantCard(restaurant: restaurants[index], index: index, prefs: widget.prefs,);
            },
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRestaurant,
        tooltip: 'Add a Restaruant',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
