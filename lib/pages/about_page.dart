import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workouts Timer',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your personal workout companion',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            const Text(
              'What is this app?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Workouts Timer is a comprehensive fitness application designed to help you manage and execute structured workout sessions with precision timing.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'How it works',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.fitness_center,
              color: Colors.blue,
              title: 'Workouts',
              description:
                  'Create custom workouts that contain multiple phases to organize your training sessions.',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.layers,
              color: Colors.orange,
              title: 'Phases',
              description:
                  'Each workout consists of multiple phases, such as warm-up, working out, and cool-down phases.',
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              icon: Icons.timer,
              color: Colors.green,
              title: 'Timers',
              description:
                  'Each phase contains a timer that defines the number of sets, workout duration, and rest duration.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Example Workout Structure',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Full Body Workout',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildPhaseExample(
                    phase: 'Phase 1: Warm-up',
                    timer: 'Jumping Jacks',
                    sets: '1 set',
                    duration: '5 minutes workout',
                    rest: 'No rest',
                  ),
                  const Divider(height: 24),
                  _buildPhaseExample(
                    phase: 'Phase 2: Working Out',
                    timer: 'Biking',
                    sets: '5 sets',
                    duration: '1 minute biking',
                    rest: '30 seconds rest',
                  ),
                  const Divider(height: 24),
                  _buildPhaseExample(
                    phase: 'Phase 3: Cool-down',
                    timer: 'stretching',
                    sets: '1 set',
                    duration: '5 minutes',
                    rest: 'No rest',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Key Features',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBulletPoint('Automatic progression through all timers'),
            _buildBulletPoint('Audio cues with bell and beep sounds'),
            _buildBulletPoint('Visual progress tracking'),
            _buildBulletPoint('Pause and resume functionality'),
            _buildBulletPoint('Persistent data storage'),
            _buildBulletPoint('Customizable workout phases'),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Stay focused. Stay strong. 💪',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseExample({
    required String phase,
    required String timer,
    required String sets,
    required String duration,
    required String rest,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          phase,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text('  Timer: $timer'),
        Text('  • $sets'),
        Text('  • $duration'),
        Text('  • $rest'),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
