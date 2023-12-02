import 'package:flutter/material.dart';
import 'add_food_screen.dart';
import 'food_list_screen.dart';
import 'meal_plan_screen.dart'; 
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _calorieController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Calories',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(_selectedDate == null
                  ? 'Select Date'
                  : 'Selected Date: ${_selectedDate!.toIso8601String().split('T')[0]}'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFoodScreen()),
                );
              },
              child: const Text('Add Food Item'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FoodListScreen()),
                );
              },
              child: const Text('View Food List'),
            ),
            ElevatedButton(
              onPressed: _navigateToMealPlan,
              child: const Text('Manage Meal Plans'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _navigateToMealPlan() {
    if (_selectedDate != null && _calorieController.text.isNotEmpty) {
      int? targetCalories = int.tryParse(_calorieController.text);
      if (targetCalories != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealPlanScreen(
              selectedItems: const [], 
              selectedDate: _selectedDate!,
              targetCalories: targetCalories,
            ),
          ),
        );
      } else {
        _showErrorSnackBar('Invalid calorie input');
      }
    } else {
      _showErrorSnackBar('Please select a date and enter target calories');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _calorieController.dispose();
    super.dispose();
  }
}



