import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/database_helper.dart';
import 'meal_plan_screen.dart'; 

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({Key? key}) : super(key: key);

  @override
  FoodListScreenState createState() => FoodListScreenState();
}

class FoodListScreenState extends State<FoodListScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final List<FoodItem> _selectedItems = [];
  DateTime? _selectedDate;
  final TextEditingController _calorieController = TextEditingController();

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

  void _navigateToMealPlan(BuildContext context) {
    if (_selectedItems.isNotEmpty && _selectedDate != null && _calorieController.text.isNotEmpty) {
      int? targetCalories = int.tryParse(_calorieController.text);
      if (targetCalories != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealPlanScreen(
              selectedItems: _selectedItems,
              selectedDate: _selectedDate!,
              targetCalories: targetCalories,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid calorie amount')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one food item and a date')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Calories',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<FoodItem>>(
              future: dbHelper.getAllFoodItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.data?.isEmpty ?? true) {
                  return const Center(child: Text("No food items found"));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      FoodItem item = snapshot.data![index];
                      return ListTile(
                        title: Text(item.foodItem),
                        subtitle: Text('${item.calories} calories'),
                        trailing: Icon(
                          _selectedItems.contains(item) ? Icons.check_box : Icons.check_box_outline_blank,
                        ),
                        onTap: () {
                          setState(() {
                            if (_selectedItems.contains(item)) {
                              _selectedItems.remove(item);
                            } else {
                              _selectedItems.add(item);
                            }
                          });
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToMealPlan(context),
        tooltip: 'Add to Meal Plan',
        child: const Icon(Icons.add),
      ),
    );
  }
}




