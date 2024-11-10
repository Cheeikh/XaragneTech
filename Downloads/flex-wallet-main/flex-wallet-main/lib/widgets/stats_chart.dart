import 'package:flutter/material.dart';
import '../services/stats_service.dart';

class StatsChart extends StatefulWidget {
  final double height;
  final Color color;

  const StatsChart({
    Key? key,
    this.height = 200,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  _StatsChartState createState() => _StatsChartState();
}

class _StatsChartState extends State<StatsChart> {
  List<DailyStats> _stats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final stats = await StatsService.getWeeklyStats();
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Gérer l'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_stats.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('Aucune donnée disponible')),
      );
    }

    final maxAmount = _stats.fold<double>(
      0,
      (max, stat) => stat.expenses > max ? stat.expenses : max,
    );

    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _stats.map((stat) {
                final height =
                    (stat.expenses / maxAmount) * (widget.height - 50);
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: height,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.7),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stat.formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
