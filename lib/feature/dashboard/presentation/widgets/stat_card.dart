import 'package:flutter/material.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool showChart;
  final List<int>? chartData;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.showChart = false,
    this.chartData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return Card(
          color: themeProv.isDarkMode
              ? AppColors.cardDark
              : AppColors.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: iconColor, size: 24),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        size: 20,
                        color: themeProv.isDarkMode
                            ? AppColors.iconDark
                            : AppColors.iconColor,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: themeProv.isDarkMode
                        ? AppColors.textHint
                        : AppColors.textHintDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: themeProv.isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                if (showChart && chartData != null)
                  _buildMiniChart()
                else
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: themeProv.isDarkMode
                          ? AppColors.textHint
                          : AppColors.textHintDark,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniChart() {
    if (chartData == null || chartData!.isEmpty) return const SizedBox();

    final maxValue = chartData!.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: chartData!.map((value) {
          final height = (value / maxValue) * 40;
          return Container(
            width: 3,
            height: height,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }).toList(),
      ),
    );
  }
}
