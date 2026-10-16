import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../services/storage_service.dart';
import 'add_edit_workout_page.dart';
import 'timer_execution_page.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<WorkoutModel>> _workoutsFuture;

  @override
  void initState() {
    super.initState();
    _workoutsFuture = StorageService.getWorkouts();
  }

  void _refreshWorkouts() {
    setState(() {
      _workoutsFuture = StorageService.getWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
            tooltip: 'About',
          ),
        ],
      ),
      body: FutureBuilder<List<WorkoutModel>>(
        future: _workoutsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final workouts = snapshot.data ?? [];

          if (workouts.isEmpty) {
            return const Center(
              child: Text('No workouts yet. Add one to get started!'),
            );
          }

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(workout.name),
                  subtitle: Text('${workout.timers.length} timers'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TimerExecutionPage(workout: workout),
                            ),
                          );
                        },
                        tooltip: 'Play workout',
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditWorkoutPage(
                                workout: workout,
                                onSaved: _refreshWorkouts,
                              ),
                            ),
                          );
                        },
                        tooltip: 'Edit workout',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmation(workout.id, workout.name);
                        },
                        tooltip: 'Delete workout',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddEditWorkoutPage(onSaved: _refreshWorkouts),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(String workoutId, String workoutName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: Text('Are you sure you want to delete "$workoutName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              StorageService.deleteWorkout(workoutId);
              Navigator.pop(context);
              _refreshWorkouts();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
