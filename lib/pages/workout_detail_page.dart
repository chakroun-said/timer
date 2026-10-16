import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import 'timer_execution_page.dart';

class WorkoutDetailPage extends StatefulWidget {
  final WorkoutModel workout;
  final VoidCallback onChanged;

  const WorkoutDetailPage({
    super.key,
    required this.workout,
    required this.onChanged,
  });

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TimerExecutionPage(workout: widget.workout),
                ),
              );
            },
            tooltip: 'Run entire workout',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.workout.timers.length,
        itemBuilder: (context, index) {
          final timer = widget.workout.timers[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(timer.name),
              subtitle: Text(
                '${timer.sets} sets - Set: ${timer.setDurationMinutes}m${timer.setDurationSeconds}s, Rest: ${timer.restDurationMinutes}m${timer.restDurationSeconds}s',
              ),
            ),
          );
        },
      ),
    );
  }
}
