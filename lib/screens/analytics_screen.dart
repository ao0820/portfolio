import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

enum DateRangeFilter { week, month, all }

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateRangeFilter _selectedRange = DateRangeFilter.week;
  Map<DateTime, int> _dailyVolume = {};
  Map<String, int> _exerciseDistribution = {};
  int _totalWorkouts = 0;
  int _totalExercises = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);

    final endDate = DateTime.now();
    DateTime startDate;

    switch (_selectedRange) {
      case DateRangeFilter.week:
        startDate = endDate.subtract(const Duration(days: 7));
        break;
      case DateRangeFilter.month:
        startDate = endDate.subtract(const Duration(days: 30));
        break;
      case DateRangeFilter.all:
        startDate = DateTime(2020);
        break;
    }

    final dailyVolume = await DatabaseHelper.instance.getDailyVolume(
      startDate,
      endDate,
    );
    final distribution = await DatabaseHelper.instance
        .getExerciseDistribution();
    final totalWorkouts = await DatabaseHelper.instance.getTotalWorkoutCount();
    final totalExercises = await DatabaseHelper.instance
        .getTotalExerciseCount();

    setState(() {
      _dailyVolume = dailyVolume;
      _exerciseDistribution = distribution;
      _totalWorkouts = totalWorkouts;
      _totalExercises = totalExercises;
      _isLoading = false;
    });
  }

  List<FlSpot> _getLineChartSpots() {
    if (_dailyVolume.isEmpty) return [];

    final sortedEntries = _dailyVolume.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sortedEntries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
    }).toList();
  }

  List<PieChartSectionData> _getPieChartSections() {
    if (_exerciseDistribution.isEmpty) return [];

    final total = _exerciseDistribution.values.reduce((a, b) => a + b);
    final colors = [
      Colors.deepPurple,
      Colors.orange,
      Colors.teal,
      Colors.blue,
      Colors.pink,
      Colors.green,
    ];

    return _exerciseDistribution.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final percentage = (item.value / total * 100).toStringAsFixed(1);
      final color = colors[index % colors.length];

      return PieChartSectionData(
        value: item.value.toDouble(),
        title: '$percentage%',
        color: color,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('進捗分析'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade400, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAnalytics,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Statistics cards
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade50, Colors.blue.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              '総ワークアウト',
                              _totalWorkouts.toString(),
                              Icons.fitness_center,
                              Colors.teal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              '総エクササイズ',
                              _totalExercises.toString(),
                              Icons.list,
                              Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Date range filter
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SegmentedButton<DateRangeFilter>(
                        segments: const [
                          ButtonSegment(
                            value: DateRangeFilter.week,
                            label: Text('7日'),
                            icon: Icon(Icons.calendar_today),
                          ),
                          ButtonSegment(
                            value: DateRangeFilter.month,
                            label: Text('30日'),
                            icon: Icon(Icons.calendar_month),
                          ),
                          ButtonSegment(
                            value: DateRangeFilter.all,
                            label: Text('全期間'),
                            icon: Icon(Icons.all_inclusive),
                          ),
                        ],
                        selected: {_selectedRange},
                        onSelectionChanged:
                            (Set<DateRangeFilter> newSelection) {
                              setState(() {
                                _selectedRange = newSelection.first;
                              });
                              _loadAnalytics();
                            },
                      ),
                    ),

                    // Line chart
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ワークアウト量の推移',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 200,
                                child: _dailyVolume.isEmpty
                                    ? Center(
                                        child: Text(
                                          'データがありません',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      )
                                    : LineChart(
                                        LineChartData(
                                          gridData: FlGridData(
                                            show: true,
                                            drawVerticalLine: false,
                                            horizontalInterval: 50,
                                            getDrawingHorizontalLine: (value) {
                                              return FlLine(
                                                color: Colors.grey.shade200,
                                                strokeWidth: 1,
                                              );
                                            },
                                          ),
                                          titlesData: FlTitlesData(
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 40,
                                                getTitlesWidget: (value, meta) {
                                                  return Text(
                                                    value.toInt().toString(),
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 30,
                                                getTitlesWidget: (value, meta) {
                                                  if (value.toInt() >=
                                                      _dailyVolume.length) {
                                                    return const SizedBox();
                                                  }
                                                  final sortedDates =
                                                      _dailyVolume.keys.toList()
                                                        ..sort();
                                                  final date = sortedDates
                                                      .elementAt(value.toInt());
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 8,
                                                        ),
                                                    child: Text(
                                                      DateFormat(
                                                        'M/d',
                                                      ).format(date),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey
                                                            .shade600,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                            ),
                                            topTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: false,
                                              ),
                                            ),
                                          ),
                                          borderData: FlBorderData(show: false),
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots: _getLineChartSpots(),
                                              isCurved: true,
                                              color: Colors.teal,
                                              barWidth: 3,
                                              dotData: const FlDotData(
                                                show: true,
                                              ),
                                              belowBarData: BarAreaData(
                                                show: true,
                                                color: Colors.teal.withOpacity(
                                                  0.2,
                                                ),
                                              ),
                                            ),
                                          ],
                                          minY: 0,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Pie chart
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'エクササイズ分布',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _exerciseDistribution.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Text(
                                          'データがありません',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: 200,
                                          child: PieChart(
                                            PieChartData(
                                              sections: _getPieChartSections(),
                                              sectionsSpace: 2,
                                              centerSpaceRadius: 0,
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        // Legend
                                        Wrap(
                                          spacing: 16,
                                          runSpacing: 8,
                                          children: _exerciseDistribution
                                              .entries
                                              .toList()
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                                final index = entry.key;
                                                final item = entry.value;
                                                final colors = [
                                                  Colors.deepPurple,
                                                  Colors.orange,
                                                  Colors.teal,
                                                  Colors.blue,
                                                  Colors.pink,
                                                  Colors.green,
                                                ];
                                                final color =
                                                    colors[index %
                                                        colors.length];

                                                return Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration: BoxDecoration(
                                                        color: color,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      '${item.key} (${item.value})',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              })
                                              .toList(),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
