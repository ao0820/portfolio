class WorkoutRecord {
  final int? id;
  final int exerciseId;
  final int sets;
  final int reps;
  final int durationMinutes;
  final DateTime recordedAt;

  WorkoutRecord({
    this.id,
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.durationMinutes,
    required this.recordedAt,
  });

  // Convert WorkoutRecord to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'sets': sets,
      'reps': reps,
      'durationMinutes': durationMinutes,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }

  // Create WorkoutRecord from Map (database query result)
  factory WorkoutRecord.fromMap(Map<String, dynamic> map) {
    return WorkoutRecord(
      id: map['id'] as int?,
      exerciseId: map['exerciseId'] as int,
      sets: map['sets'] as int,
      reps: map['reps'] as int,
      durationMinutes: map['durationMinutes'] as int,
      recordedAt: DateTime.parse(map['recordedAt'] as String),
    );
  }

  // Create a copy with updated fields
  WorkoutRecord copyWith({
    int? id,
    int? exerciseId,
    int? sets,
    int? reps,
    int? durationMinutes,
    DateTime? recordedAt,
  }) {
    return WorkoutRecord(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  // Calculate total volume (sets × reps)
  int get totalVolume => sets * reps;

  @override
  String toString() {
    return 'WorkoutRecord{id: $id, exerciseId: $exerciseId, sets: $sets, reps: $reps, duration: $durationMinutes min, recordedAt: $recordedAt}';
  }
}
