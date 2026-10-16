class TimerModel {
  final String id;
  final String name;
  final int sets;
  final int setDurationMinutes;
  final int setDurationSeconds;
  final int restDurationMinutes;
  final int restDurationSeconds;

  TimerModel({
    required this.id,
    required this.name,
    required this.sets,
    required this.setDurationMinutes,
    required this.setDurationSeconds,
    required this.restDurationMinutes,
    required this.restDurationSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'setDurationMinutes': setDurationMinutes,
      'setDurationSeconds': setDurationSeconds,
      'restDurationMinutes': restDurationMinutes,
      'restDurationSeconds': restDurationSeconds,
    };
  }

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sets: json['sets'] as int,
      setDurationMinutes: json['setDurationMinutes'] as int,
      setDurationSeconds: json['setDurationSeconds'] as int,
      restDurationMinutes: json['restDurationMinutes'] as int,
      restDurationSeconds: json['restDurationSeconds'] as int,
    );
  }

  TimerModel copyWith({
    String? id,
    String? name,
    int? sets,
    int? setDurationMinutes,
    int? setDurationSeconds,
    int? restDurationMinutes,
    int? restDurationSeconds,
  }) {
    return TimerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      setDurationMinutes: setDurationMinutes ?? this.setDurationMinutes,
      setDurationSeconds: setDurationSeconds ?? this.setDurationSeconds,
      restDurationMinutes: restDurationMinutes ?? this.restDurationMinutes,
      restDurationSeconds: restDurationSeconds ?? this.restDurationSeconds,
    );
  }
}
