import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/exercise.dart';

class ExerciseFormScreen extends StatefulWidget {
  final Exercise? exercise;

  const ExerciseFormScreen({super.key, this.exercise});

  @override
  State<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedCategory;

  final List<String> _categories = ['筋力', '有酸素', '柔軟性', 'その他'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exercise?.name ?? '');
    _selectedCategory = widget.exercise?.category ?? '筋力';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveExercise() async {
    if (!_formKey.currentState!.validate()) return;

    final exercise = Exercise(
      id: widget.exercise?.id,
      name: _nameController.text.trim(),
      category: _selectedCategory,
      createdAt: widget.exercise?.createdAt ?? DateTime.now(),
    );

    if (widget.exercise == null) {
      await DatabaseHelper.instance.createExercise(exercise);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('トレーニングを追加しました')));
      }
    } else {
      await DatabaseHelper.instance.updateExercise(exercise);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('トレーニングを更新しました')));
      }
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '筋力':
        return Colors.deepPurple;
      case '有酸素':
        return Colors.orange;
      case '柔軟性':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.exercise != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'トレーニング編集' : '新規トレーニング'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade400, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'トレーニング名',
                hintText: '例: 腕立て伏せ',
                prefixIcon: const Icon(Icons.fitness_center),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'トレーニング名を入力してください';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 24),

            // Category selection
            const Text(
              'カテゴリー',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                final color = _getCategoryColor(category);

                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  selectedColor: color,
                  backgroundColor: color.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  elevation: isSelected ? 4 : 0,
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            // Save button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _saveExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check),
                    const SizedBox(width: 8),
                    Text(
                      isEditing ? '更新' : '追加',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Cancel button
            SizedBox(
              height: 56,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'キャンセル',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
