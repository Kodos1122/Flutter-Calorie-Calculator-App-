import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_item.dart';
import '../models/meal_plan.dart';

class DatabaseHelper {
  static const _databaseName = "FoodDatabase.db";
  static const _databaseVersion = 2;
  static const tableFoodItems = 'food_items';
  static const tableMealPlans = 'meal_plans';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableFoodItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        foodItem TEXT NOT NULL,
        calories INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableMealPlans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        targetCalories INTEGER NOT NULL,
        foodItems TEXT NOT NULL
      )
    ''');
    await _insertInitialData(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrade if needed
  }

  Future _insertInitialData(Database db) async {
    var batch = db.batch();
    var foods = _getInitialFoodData();
    for (var food in foods) {
      batch.insert(tableFoodItems, food.toMap());
    }
    await batch.commit(noResult: true);
  }

  List<FoodItem> _getInitialFoodData() {
    return [
      FoodItem(foodItem: 'Apple', calories: 95),
      FoodItem(foodItem: 'Banana', calories: 105),
      FoodItem(foodItem: 'Chicken Breast', calories: 165),
      FoodItem(foodItem: 'Brown Rice', calories: 218),
      FoodItem(foodItem: 'Broccoli', calories: 55),
      FoodItem(foodItem: 'Almonds', calories: 161),
      FoodItem(foodItem: 'Salmon', calories: 182),
      FoodItem(foodItem: 'Egg', calories: 72),
      FoodItem(foodItem: 'Avocado', calories: 227),
      FoodItem(foodItem: 'Sweet Potato', calories: 180),
      FoodItem(foodItem: 'Spinach', calories: 7),
      FoodItem(foodItem: 'Greek Yogurt', calories: 100),
      FoodItem(foodItem: 'Quinoa', calories: 222),
      FoodItem(foodItem: 'Oatmeal', calories: 158),
      FoodItem(foodItem: 'Tomato', calories: 22),
      FoodItem(foodItem: 'Carrot', calories: 25),
      FoodItem(foodItem: 'Cheddar Cheese', calories: 113),
      FoodItem(foodItem: 'Whole Wheat Bread', calories: 69),
      FoodItem(foodItem: 'Beef Steak', calories: 213),
      FoodItem(foodItem: 'Tofu', calories: 94)
    ];
  }

  Future<void> insertFoodItem(FoodItem foodItem) async {
    Database db = await database;
    await db.insert(
      tableFoodItems,
      foodItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<FoodItem>> getAllFoodItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableFoodItems);

    return List.generate(maps.length, (i) {
      return FoodItem.fromMap(maps[i]);
    });
  }

  Future<void> insertMealPlan(MealPlan mealPlan) async {
    Database db = await database;
    await db.insert(
      tableMealPlans,
      mealPlan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<MealPlan>> getMealPlansByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> mealPlanMaps = await db.query(
      tableMealPlans,
      where: 'date = ?',
      whereArgs: [date],
    );

    final allFoodItems = await getAllFoodItems();

    return List.generate(mealPlanMaps.length, (i) {
      return MealPlan.fromMap(mealPlanMaps[i], allFoodItems);
    });
  }
}



