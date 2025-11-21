class Exercise {
  final int? id;
  final String name;
  final String category;
  final DateTime createdAt;

  Exercise({
    this.id,
    required this.name,
    required this.category,
    required this.createdAt,
  });

  // Convert Exercise to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Exercise from Map (database query result)
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Create a copy with updated fields
  Exercise copyWith({
    int? id,
    String? name,
    String? category,
    DateTime? createdAt,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Exercise{id: $id, name: $name, category: $category, createdAt: $createdAt}';
  }
}
