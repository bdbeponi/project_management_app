import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const PerformanceChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Performance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, size: 20, color: Colors.grey[400]),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend('Income', const Color(0xFF6C63FF)),
                const SizedBox(width: 24),
                _buildLegend('Net Worth', const Color(0xFF00BFFF)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: RadarChart(
                RadarChartData(
                  radarBackgroundColor: Colors.transparent,
                  radarBorderData: BorderSide(color: Colors.grey[300]!, width: 1),
                  tickBorderData: BorderSide(color: Colors.grey[200]!, width: 1),
                  gridBorderData: BorderSide(color: Colors.grey[200]!, width: 1),
                  tickCount: 4,
                  ticksTextStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                  radarShape: RadarShape.polygon,
                  dataSets: [
                    RadarDataSet(
                      fillColor: const Color(0xFF6C63FF).withOpacity(0.2),
                      borderColor: const Color(0xFF6C63FF),
                      borderWidth: 2,
                      entryRadius: 3,
                      dataEntries: data.map((item) {
                        return RadarEntry(value: item['income'] / 1000);
                      }).toList(),
                    ),
                    RadarDataSet(
                      fillColor: const Color(0xFF00BFFF).withOpacity(0.2),
                      borderColor: const Color(0xFF00BFFF),
                      borderWidth: 2,
                      entryRadius: 3,
                      dataEntries: data.map((item) {
                        return RadarEntry(value: item['netWorth'] / 1000);
                      }).toList(),
                    ),
                  ],
                  getTitle: (index, angle) {
                    if (index >= 0 && index < data.length) {
                      return RadarChartTitle(
                        text: data[index]['month'],
                        angle: angle,
                      );
                    }
                    return const RadarChartTitle(text: '');
                  },
                  titleTextStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  titlePositionPercentageOffset: 0.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}