import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:home_assignment/model/restaurant.dart';
import 'package:home_assignment/screens/form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  final Restaurant restaurant;
  final SharedPreferences prefs;
  final int index;

  const DetailsPage({super.key, required this.restaurant, required this.prefs, required this.index});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Restaurant rest = widget.restaurant;
  void _edit(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => FormPage(prefs: widget.prefs, restaurant: widget.restaurant, index: widget.index,))
    ).then((result) {
      setState(() {
        if(result is Restaurant) {
          rest = result;
        }
      });
    });
  }

  void _delete(context) {
    List<String> list = widget.prefs.getStringList("restaurants")!;

    list.removeAt(widget.index);

    widget.prefs.setStringList("restaurants", list);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(rest.name,),
      ),

      body: PopScope(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: false,
              physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Image.file(
                File(rest.review.reviewImage), 
                fit: BoxFit.cover, 
                height: 200, 
                width: double.infinity,
              ),
              SizedBox(height: 16),
              StarRating(rating: rest.rating),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer
                ),
                child: ListTile(
                  title: Text(rest.review.title),
                  subtitle: Text(rest.review.content),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        distance: 50,
        children: [
        FloatingActionButton.small(heroTag: null, onPressed: () => { _edit(context)}, child: const Icon(Icons.edit)),
        FloatingActionButton.small(heroTag: null, onPressed: () => { _delete(context)}, child: const Icon(Icons.delete)),
      ]), // T
    );
  }
}
