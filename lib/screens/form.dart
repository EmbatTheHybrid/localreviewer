import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_assignment/model/restaurant.dart';
import 'package:home_assignment/model/review.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormPage extends StatefulWidget {
  final Restaurant? restaurant;
  final int? index;

  final SharedPreferences prefs;

  const FormPage({super.key, this.restaurant, required this.prefs, this.index});

  @override
  State<StatefulWidget> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  String _restaurantName = '';
  String _restaurantImage = '';
  double _rating = 0.0;
  String _reviewTitle = '';
  String _reviewContent = '';
  String _reviewImage = '';

  final TextEditingController _restaurantImageController =
      TextEditingController();
  final TextEditingController _reviewImageController = TextEditingController();

  Future _pickImageFromCamera(controller) async {
    final returnImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (returnImage != null) {
      setState(() {
        controller.text = returnImage.path;
      });
    }
  }

  Future _pickImageFromGallery(controller) async {
    final returnImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (returnImage != null) {
      setState(() {
        controller.text = returnImage.path;
      });
    }
  }

  void _addToList(restaurant) {
    var list = widget.prefs.getStringList("restaurants") ?? [];

    if (widget.index != null) {
      // we're editting
      list[widget.index ?? 0] = restaurant.toString();
    } else {
      list.add(restaurant.toString());
    }

    widget.prefs.setStringList("restaurants", list);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.restaurant == null) {
      return;
    }

    _restaurantImageController.text = widget.restaurant!.restaurantImage;
    _reviewImageController.text = widget.restaurant!.review.reviewImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.restaurant != null
              ? "Editting ${widget.restaurant!.name}"
              : "Create new restaurant",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Restaurant Name"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field must have a value';
                    }
                    return null;
                  },
                  initialValue: widget.restaurant != null ? widget.restaurant!.name : '',
                  onSaved: (newValue) {
                    _restaurantName = newValue!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Restaurant Image"),
                  ),
                  controller: _restaurantImageController,
                  enabled: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field must have a value';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _restaurantImage = newValue!;
                  },
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => {
                        _pickImageFromGallery(_restaurantImageController),
                      },
                      child: Text("From Gallery"),
                    ),
                    TextButton(
                      onPressed: () => {
                        _pickImageFromCamera(_restaurantImageController),
                      },
                      child: Text("From Camera"),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Rating (0-5)"),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final text = newValue.text;
                      return text.isEmpty
                          ? newValue
                          : double.tryParse(text) == null
                          ? oldValue
                          : newValue;
                    }),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  initialValue: widget.restaurant != null ? widget.restaurant!.rating.toString() : '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field must have a value';
                    }

                    double doubleValue = double.parse(value);

                    if (doubleValue > 5 || doubleValue < 0) {
                      return 'Rating must be better 0-5';
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    _rating = double.parse(newValue!);
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Review Title"),
                  ),
                  initialValue: widget.restaurant != null ? widget.restaurant!.review.title : '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field must have a value';
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    _reviewTitle = newValue!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Review Content"),
                  ),
                  maxLines: 3,
                  initialValue: widget.restaurant != null ? widget.restaurant!.review.content : '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field must have a value';
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    _reviewContent = newValue!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Review Image"),
                  ),
                  controller: _reviewImageController,
                  enabled: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field must have a value';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _reviewImage = newValue!;
                  },
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => {
                        _pickImageFromGallery(_reviewImageController),
                      },
                      child: Text("From Gallery"),
                    ),
                    TextButton(
                      onPressed: () => {
                        _pickImageFromCamera(_reviewImageController),
                      },
                      child: Text("From Camera"),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      Review review = Review(
                        title: _reviewTitle,
                        content: _reviewContent,
                        reviewImage: _reviewImage,
                      );
                      Restaurant restaurant = Restaurant(
                        name: _restaurantName,
                        restaurantImage: _restaurantImage,
                        rating: _rating,
                        review: review,
                      );

                      _addToList(restaurant);

                      _formKey.currentState!.reset();
                      Navigator.pop(context, restaurant);
                    }
                  },
                  child: Text("Submit"),
                ),
                // Add TextFormFields and ElevatedButton here.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
