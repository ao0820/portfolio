import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/exercise.dart';
import '../models/workout_record.dart';

class WorkoutRecordingScreen extends StatefulWidget {
  const WorkoutRecordingScreen({super.key});

  @override
  State<WorkoutRecordingScreen> createState() => _WorkoutRecordingScreenState();
}

class _WorkoutRecordingScreenState extends State<WorkoutRecordingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _durationController = TextEditingController();

  List<Exercise> _exercises = [];
  List<WorkoutRecord> _recentRecords = [];
  Exercise? _selectedExercise;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final exercises = await DatabaseHelper.instance.readAllExercises();
    final records = await DatabaseHelper.instance.readAllWorkoutRecords();
    setState(() {
      _exercises = exercises;
      _recentRecords = records.take(10).toList();
      _isLoading = false;
    });
  }

  Future<void> _saveWorkoutRecord() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedExercise == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('トレーニングを選択してください')));
      return;
    }

    final record = WorkoutRecord(
      exerciseId: _selectedExercise!.id!,
      sets: int.parse(_setsController.text),
      reps: int.parse(_repsController.text),
      durationMinutes: int.parse(_durationController.text),
      recordedAt: _selectedDate,
    );

    await DatabaseHelper.instance.createWorkoutRecord(record);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('記録を保存しました')));
      _clearForm();
      _loadData();
    }
  }

  void _clearForm() {
    _setsController.clear();
    _repsController.clear();
    _durationController.clear();
    setState(() {
      _selectedExercise = null;
      _selectedDate = DateTime.now();
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  String _getExerciseName(int exerciseId) {
    final exercise = _exercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () =>
          Exercise(name: '不明', category: '', createdAt: DateTime.now()),
    );
    return exercise.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ワークアウト記録'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.pink.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Input Form
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade50, Colors.pink.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Exercise dropdown
                          DropdownButtonFormField<Exercise>(
                            value: _selectedExercise,
                            decoration: InputDecoration(
                              labelText: 'トレーニング',
                              prefixIcon: const Icon(Icons.fitness_center),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: _exercises.map((exercise) {
                              return DropdownMenuItem(
                                value: exercise,
                                child: Text(exercise.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _selectedExercise = value);
                            },
                            validator: (value) {
                              if (value == null) return 'トレーニングを選択してください';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Sets, Reps, Duration in a row
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _setsController,
                                  decoration: InputDecoration(
                                    labelText: 'セット',
                                    prefixIcon: const Icon(Icons.repeat),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '必須';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return '数値';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _repsController,
                                  decoration: InputDecoration(
                                    labelText: '回数',
                                    prefixIcon: const Icon(
                                      Icons.format_list_numbered,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '必須';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return '数値';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Duration
                          TextFormField(
                            controller: _durationController,
                            decoration: InputDecoration(
                              labelText: '時間（分）',
                              prefixIcon: const Icon(Icons.timer),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '時間を入力してください';
                              }
                              if (int.tryParse(value) == null) {
                                return '数値を入力してください';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Date picker
                          InkWell(
                            onTap: _selectDate,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    DateFormat(
                                      'yyyy/MM/dd HH:mm',
                                    ).format(_selectedDate),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Save button
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _saveWorkoutRecord,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save),
                                  SizedBox(width: 8),
                                  Text(
                                    '記録を保存',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Recent records
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '最近の記録',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _recentRecords.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Text(
                                    '記録がありません',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _recentRecords.length,
                                itemBuilder: (context, index) {
                                  final record = _recentRecords[index];
                                  final exerciseName = _getExerciseName(
                                    record.exerciseId,
                                  );

                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.orange.withOpacity(0.1),
                                            Colors.pink.withOpacity(0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.orange.shade400,
                                                  Colors.pink.shade400,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.orange
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.fitness_center,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  exerciseName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${record.sets}セット × ${record.reps}回 • ${record.durationMinutes}分',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  DateFormat(
                                                    'yyyy/MM/dd HH:mm',
                                                  ).format(record.recordedAt),
                                                  style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
