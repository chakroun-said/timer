import 'timer_model.dart';

class WorkoutModel {
  final String id;
  final String name;
  final List<TimerModel> timers;

  WorkoutModel({required this.id, required this.name, required this.timers});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'timers': timers.map((e) => e.toJson()).toList(),
    };
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      name: json['name'] as String,
      timers: (json['timers'] as List)
          .map((e) => TimerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  WorkoutModel copyWith({String? id, String? name, List<TimerModel>? timers}) {
    return WorkoutModel(
      id: id ?? this.id,
      name: name ?? this.name,
      timers: timers ?? this.timers,
    );
  }
}
