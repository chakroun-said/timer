import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/workout_model.dart';
import '../models/timer_model.dart';
import '../services/storage_service.dart';

class AddEditWorkoutPage extends StatefulWidget {
  final WorkoutModel? workout;
  final VoidCallback onSaved;

  const AddEditWorkoutPage({super.key, this.workout, required this.onSaved});

  @override
  State<AddEditWorkoutPage> createState() => _AddEditWorkoutPageState();
}

class _AddEditWorkoutPageState extends State<AddEditWorkoutPage> {
  late TextEditingController _nameController;
  late List<TimerModel> _timers;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workout?.name ?? '');
    _timers = widget.workout?.timers ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkout() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a workout name')),
      );
      return;
    }

    if (_timers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one timer')),
      );
      return;
    }

    final workout = WorkoutModel(
      id: widget.workout?.id ?? const Uuid().v4(),
      name: _nameController.text,
      timers: _timers,
    );

    await StorageService.saveWorkout(workout);
    widget.onSaved();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout == null ? 'Add Workout' : 'Edit Workout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Timers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditTimerPage(
                          onSaved: (timer) {
                            setState(() {
                              _timers.add(timer);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Timer'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_timers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('No timers added yet'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _timers.length,
                itemBuilder: (context, index) {
                  final timer = _timers[index];
                  return Card(
                    child: ListTile(
                      title: Text(timer.name),
                      subtitle: Text(
                        '${timer.sets} sets - ${timer.setDurationMinutes}m${timer.setDurationSeconds}s / ${timer.restDurationMinutes}m${timer.restDurationSeconds}s',
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('Edit'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEditTimerPage(
                                    timer: timer,
                                    onSaved: (updatedTimer) {
                                      setState(() {
                                        _timers[index] = updatedTimer;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          PopupMenuItem(
                            child: const Text('Delete'),
                            onTap: () {
                              setState(() {
                                _timers.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveWorkout,
                child: const Text('Save Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddEditTimerPage extends StatefulWidget {
  final TimerModel? timer;
  final Function(TimerModel) onSaved;

  const AddEditTimerPage({super.key, this.timer, required this.onSaved});

  @override
  State<AddEditTimerPage> createState() => _AddEditTimerPageState();
}

class _AddEditTimerPageState extends State<AddEditTimerPage> {
  late TextEditingController _nameController;
  late TextEditingController _setsController;
  late TextEditingController _setMinutesController;
  late TextEditingController _setSecondsController;
  late TextEditingController _restMinutesController;
  late TextEditingController _restSecondsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.timer?.name ?? '');
    _setsController = TextEditingController(
      text: (widget.timer?.sets ?? 1).toString(),
    );
    _setMinutesController = TextEditingController(
      text: (widget.timer?.setDurationMinutes ?? 1).toString(),
    );
    _setSecondsController = TextEditingController(
      text: (widget.timer?.setDurationSeconds ?? 0).toString(),
    );
    _restMinutesController = TextEditingController(
      text: (widget.timer?.restDurationMinutes ?? 0).toString(),
    );
    _restSecondsController = TextEditingController(
      text: (widget.timer?.restDurationSeconds ?? 30).toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _setMinutesController.dispose();
    _setSecondsController.dispose();
    _restMinutesController.dispose();
    _restSecondsController.dispose();
    super.dispose();
  }

  void _saveTimer() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a timer name')),
      );
      return;
    }

    final timer = TimerModel(
      id: widget.timer?.id ?? const Uuid().v4(),
      name: _nameController.text,
      sets: int.tryParse(_setsController.text) ?? 1,
      setDurationMinutes: int.tryParse(_setMinutesController.text) ?? 0,
      setDurationSeconds: int.tryParse(_setSecondsController.text) ?? 0,
      restDurationMinutes: int.tryParse(_restMinutesController.text) ?? 0,
      restDurationSeconds: int.tryParse(_restSecondsController.text) ?? 0,
    );

    widget.onSaved(timer);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.timer == null ? 'Add Timer' : 'Edit Timer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Timer Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _setsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Sets',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Set Duration',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _setMinutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _setSecondsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Seconds',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Rest Duration',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _restMinutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _restSecondsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Seconds',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTimer,
                child: const Text('Save Timer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
