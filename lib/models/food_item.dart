
class FoodItem {
  int? id;
  String foodItem;
  int calories;

  FoodItem({this.id, required this.foodItem, required this.calories});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodItem': foodItem,
      'calories': calories,
    };
  }

  static FoodItem fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      foodItem: map['foodItem'],
      calories: map['calories'],
    );
  }
}