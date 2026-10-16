import 'package:flutter/material.dart';
import 'dart:async';
import '../models/workout_model.dart';
import '../models/timer_model.dart';
import '../services/sound_service.dart';

class TimerExecutionPage extends StatefulWidget {
  final WorkoutModel workout;

  const TimerExecutionPage({super.key, required this.workout});

  @override
  State<TimerExecutionPage> createState() => _TimerExecutionPageState();
}

class _TimerExecutionPageState extends State<TimerExecutionPage> {
  Timer? _timer;
  late int _remainingSeconds;
  int _currentTimerIndex = 0;
  int _currentSet = 1;
  bool _isRunning = false;
  bool _isSetPhase = true;
  final SoundService _soundService = SoundService();

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    if (widget.workout.timers.isEmpty) return;
    final currentTimer = widget.workout.timers[_currentTimerIndex];
    _remainingSeconds =
        currentTimer.setDurationMinutes * 60 + currentTimer.setDurationSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _soundService.dispose();
    super.dispose();
  }

  TimerModel get _currentTimer => widget.workout.timers[_currentTimerIndex];

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    // Play bell sound at start
    _soundService.playBellSound();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remainingSeconds--;

        // Play beep for last 5 seconds
        if (_remainingSeconds > 0 && _remainingSeconds <= 5) {
          _soundService.playBeepSound();
        }

        // Phase complete
        if (_remainingSeconds <= 0) {
          _timer?.cancel();
          _soundService.playBellSound();

          if (_isSetPhase) {
            // Just finished a set
            if (_currentSet < _currentTimer.sets) {
              // Move to rest and continue automatically
              _isSetPhase = false;
              _remainingSeconds =
                  _currentTimer.restDurationMinutes * 60 +
                  _currentTimer.restDurationSeconds;
              _isRunning = false;
              // Auto-continue after a brief moment
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) _startTimer();
              });
            } else {
              // Finished all sets for this timer, move to next timer
              _moveToNextTimer();
            }
          } else {
            // Just finished rest, next set - continue automatically
            _currentSet++;
            _isSetPhase = true;
            _remainingSeconds =
                _currentTimer.setDurationMinutes * 60 +
                _currentTimer.setDurationSeconds;
            _isRunning = false;
            // Auto-continue after a brief moment
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) _startTimer();
            });
          }
        }
      });
    });
  }

  void _moveToNextTimer() {
    if (_currentTimerIndex < widget.workout.timers.length - 1) {
      // Move to next timer and continue automatically
      setState(() {
        _currentTimerIndex++;
        _currentSet = 1;
        _isSetPhase = true;
        _remainingSeconds =
            _currentTimer.setDurationMinutes * 60 +
            _currentTimer.setDurationSeconds;
        _isRunning = false;
      });
      // Auto-continue after a brief moment
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _startTimer();
      });
    } else {
      // All timers complete
      setState(() {
        _isRunning = false;
      });
      _showWorkoutComplete();
    }
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _currentTimerIndex = 0;
      _currentSet = 1;
      _isSetPhase = true;
      _initializeTimer();
    });
  }

  void _showWorkoutComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations! 🎉'),
        content: const Text(
          'You completed the entire workout!\nGreat job staying strong!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.workout.timers.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.workout.name)),
        body: const Center(child: Text('No timers in this workout')),
      );
    }

    final totalTimers = widget.workout.timers.length;
    final progress = (_currentTimerIndex + 1) / totalTimers;

    return Scaffold(
      appBar: AppBar(title: Text(widget.workout.name)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Control buttons at top
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isRunning ? null : _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    icon: const Icon(Icons.play_arrow, size: 24),
                    label: const Text('Start', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _isRunning ? _pauseTimer : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    icon: const Icon(Icons.pause, size: 24),
                    label: const Text('Pause', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.restart_alt, size: 24),
                    label: const Text('Reset', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Timer name
            Text(
              _currentTimer.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Set/Rest indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _isSetPhase ? Colors.blue[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _isSetPhase
                    ? 'Set $_currentSet of ${_currentTimer.sets}'
                    : 'Rest',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _isSetPhase ? Colors.blue[900] : Colors.orange[900],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Countdown display
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            // Progress indicator at bottom
            Text(
              'Timer ${_currentTimerIndex + 1} of $totalTimers',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
