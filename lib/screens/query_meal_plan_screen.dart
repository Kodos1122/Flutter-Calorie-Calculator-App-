import 'package:flutter/material.dart';
import '../models/meal_plan.dart';
import '../services/database_helper.dart';

class QueryMealPlanScreen extends StatefulWidget {
  const QueryMealPlanScreen({Key? key}) : super(key: key);

  @override
  QueryMealPlanScreenState createState() => QueryMealPlanScreenState();
}

class QueryMealPlanScreenState extends State<QueryMealPlanScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  DateTime? _selectedDate;
  MealPlan? _mealPlan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Meal Plan'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(
              _selectedDate == null ? 'Select Date' : 'Selected Date: ${_selectedDate!.toIso8601String().split('T')[0]}',
            ),
          ),
          const SizedBox(height: 20),
          if (_mealPlan != null) _buildMealPlanView(),
        ],
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
      _queryMealPlan();
    }
  }

  Future<void> _queryMealPlan() async {
    if (_selectedDate == null) return;
    final List<MealPlan> mealPlans = await _dbHelper.getMealPlansByDate(_selectedDate! as String);
    setState(() {
      _mealPlan = mealPlans.isNotEmpty ? mealPlans.first : null;
    });
  }

  Widget _buildMealPlanView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Date: ${_mealPlan!.date.toIso8601String().split('T')[0]}', style: const TextStyle(fontSize: 18)),
        Text('Target Calories: ${_mealPlan!.targetCalories}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        const Text('Food Items:', style: TextStyle(fontSize: 18)),
        ..._mealPlan!.foodItems.map((item) => ListTile(
          title: Text(item.foodItem),
          trailing: Text('${item.calories} kcal'),
        )),
      ],
    );
  }
}

