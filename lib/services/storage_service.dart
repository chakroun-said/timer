import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/workout_model.dart';

class StorageService {
  static const String _workoutsKey = 'workouts';

  static Future<void> saveWorkout(WorkoutModel workout) async {
    final prefs = await SharedPreferences.getInstance();
    final workouts = await getWorkouts();

    final index = workouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      workouts[index] = workout;
    } else {
      workouts.add(workout);
    }

    final workoutsJson = jsonEncode(workouts.map((w) => w.toJson()).toList());
    await prefs.setString(_workoutsKey, workoutsJson);
  }

  static Future<List<WorkoutModel>> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutsJson = prefs.getString(_workoutsKey);

    if (workoutsJson == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(workoutsJson);
    return decoded
        .map((w) => WorkoutModel.fromJson(w as Map<String, dynamic>))
        .toList();
  }

  static Future<void> deleteWorkout(String workoutId) async {
    final prefs = await SharedPreferences.getInstance();
    final workouts = await getWorkouts();

    workouts.removeWhere((w) => w.id == workoutId);

    final workoutsJson = jsonEncode(workouts.map((w) => w.toJson()).toList());
    await prefs.setString(_workoutsKey, workoutsJson);
  }
}
