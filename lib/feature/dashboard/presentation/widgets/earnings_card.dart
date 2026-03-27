import 'package:flutter/material.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class EarningsCard extends StatelessWidget {
  final Map<String, dynamic> earnings;

  const EarningsCard({Key? key, required this.earnings}) : super(key: key);

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Total Earning',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: themeProv.isDarkMode
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: themeProv.isDarkMode
                                    ? AppColors.textHint.withOpacity(0.2)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Total Projects: ${earnings['projects'].length}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: themeProv.isDarkMode
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${earnings['totalEarning'].toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: themeProv.isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${earnings['growthPercentage']}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Compared to \$${earnings['comparisonAmount'].toStringAsFixed(0)} last year',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProv.isDarkMode
                        ? AppColors.textHint
                        : AppColors.textHintDark,
                  ),
                ),
                const SizedBox(height: 24),
                // Projects List
                ...earnings['projects'].map<Widget>((project) {
                  return _ProjectItem(
                    name: project['name'],
                    tech: project['tech'],
                    amount: project['amount'],
                    progress: project['progress'],
                    icon: project['icon'],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProjectItem extends StatelessWidget {
  final String name;
  final String tech;
  final double amount;
  final double progress;
  final String icon;

  const _ProjectItem({
    required this.name,
    required this.tech,
    required this.amount,
    required this.progress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: themeProv.isDarkMode
                          ? AppColors.textHint.withOpacity(0.2)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: themeProv.isDarkMode
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tech,
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
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: themeProv.isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: themeProv.isDarkMode
                      ? AppColors.textHint.withOpacity(0.2)
                      : Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(progress),
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 11,
                      color: themeProv.isDarkMode
                          ? AppColors.textHint
                          : AppColors.textHintDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.7) return const Color(0xFF6C63FF);
    if (progress >= 0.4) return const Color(0xFF00BFFF);
    return Colors.grey;
  }
}
