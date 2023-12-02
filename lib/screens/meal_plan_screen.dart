import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/meal_plan.dart';
import '../services/database_helper.dart';

class MealPlanScreen extends StatefulWidget {
  final List<FoodItem> selectedItems;
  final DateTime selectedDate;
  final int targetCalories;

  const MealPlanScreen({
    Key? key,
    required this.selectedItems,
    required this.selectedDate,
    required this.targetCalories,
  }) : super(key: key);

  @override
  MealPlanScreenState createState() => MealPlanScreenState();
}

class MealPlanScreenState extends State<MealPlanScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  late List<FoodItem> _selectedFoodItems;
  late int _totalCalories;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedFoodItems = widget.selectedItems;
    _selectedDate = widget.selectedDate; // Use the date passed from HomeScreen
    _calculateTotalCalories();
  }

  void _calculateTotalCalories() {
    _totalCalories = widget.targetCalories; // Use the target calories passed from HomeScreen
  }

  void _saveMealPlan() async {
    MealPlan newMealPlan = MealPlan(
      date: _selectedDate,
      targetCalories: _totalCalories,
      foodItems: _selectedFoodItems,
    );
    await _dbHelper.insertMealPlan(newMealPlan);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal Plan Saved')),
      );
      Navigator.pop(context); // Optionally pop the screen after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _selectedFoodItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_selectedFoodItems[index].foodItem),
                  trailing: Text('${_selectedFoodItems[index].calories} kcal'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total Calories: $_totalCalories'),
          ),
          ElevatedButton(
            onPressed: _saveMealPlan,
            child: const Text('Save Meal Plan'),
          ),
        ],
      ),
    );
  }
}


