import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/database_helper.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  AddFoodScreenState createState() => AddFoodScreenState();
}

class AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Food')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: caloriesController,
              decoration: const InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () => _addFoodItem(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addFoodItem(BuildContext context) async {
    final String foodName = nameController.text.trim();
    final String calories = caloriesController.text.trim();

    if (foodName.isEmpty || calories.isEmpty) {
      _showSnackBar(context, 'Please fill in all fields');
      return;
    }

    final int? calValue = int.tryParse(calories);
    if (calValue == null) {
      _showSnackBar(context, 'Please enter a valid calorie amount');
      return;
    }

    final foodItem = FoodItem(foodItem: foodName, calories: calValue);
    await dbHelper.insertFoodItem(foodItem);

    if (!mounted) return;
    _showSnackBar(context, 'Food Item Added');
    Navigator.of(context).pop();
  }

  void _showSnackBar(BuildContext context, String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    caloriesController.dispose();
    super.dispose();
  }
}





