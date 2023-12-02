import 'food_item.dart';  // Import the FoodItem model

class MealPlan {
  int? id;
  DateTime date;
  int targetCalories;
  List<FoodItem> foodItems;

  MealPlan({
    this.id,
    required this.date,
    required this.targetCalories,
    required this.foodItems,
  });

  // Convert a MealPlan instance into a Map.
  // The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(), // Storing the date as a String
      'targetCalories': targetCalories,
      // Convert the list of FoodItem objects to a list of their IDs, then to a comma-separated String
      'foodItems': foodItems.map((item) => item.id.toString()).join(','),
    };
  }

  // Convert a Map into a MealPlan instance
  static MealPlan fromMap(Map<String, dynamic> map, List<FoodItem> allFoodItems) {
    var selectedFoodItemIds = map['foodItems']
        .split(',')
        .map((idString) => int.parse(idString))
        .toList();

    // Find FoodItem objects in allFoodItems that match the IDs
    var selectedFoodItems = allFoodItems.where((item) => selectedFoodItemIds.contains(item.id)).toList();

    return MealPlan(
      id: map['id'],
      date: DateTime.parse(map['date']),
      targetCalories: map['targetCalories'],
      foodItems: selectedFoodItems,
    );
  }
}
