import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/feature/project/presentation/view_model/project_vm.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   create: (_) => ProjectVm(),
    //   child: const _ProjectsContent(),
    // );
    return _ProjectsContent();
  }
}

class _ProjectsContent extends StatefulWidget {
  const _ProjectsContent();

  @override
  State<_ProjectsContent> createState() => _ProjectsContentState();
}

class _ProjectsContentState extends State<_ProjectsContent> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectVm>(context);
    final filteredProjects = _getFilteredProjects(provider.projects);

    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return Scaffold(
          backgroundColor: themeProv.isDarkMode
              ? AppColors.backgroundDark
              : AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: themeProv.isDarkMode
                ? AppColors.backgroundDark
                : AppColors.backgroundColor,
            title: Text(
              'Projects',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.filter_list_rounded,
                  color: themeProv.isDarkMode
                      ? AppColors.iconDark
                      : AppColors.iconColor,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showFilterSheet(context);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              HapticFeedback.mediumImpact();
              await Future.delayed(const Duration(seconds: 1));
              // TODO: Refresh projects from API
            },
            child: Column(
              children: [

                // Search and Filter Section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: themeProv.isDarkMode
                      ? AppColors.backgroundDark
                      : AppColors.backgroundColor,
                  child: Column(
                    children: [
                      // Search Bar
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for code or name',
                          hintStyle: TextStyle(
                            color: themeProv.isDarkMode
                                ? AppColors.textHint
                                : AppColors.textHintDark,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: themeProv.isDarkMode
                                ? AppColors.iconDark
                                : AppColors.iconColor,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() => _searchController.clear());
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: themeProv.isDarkMode
                              ? AppColors.cardDark
                              : const Color.fromARGB(255, 242, 242, 242),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                      const SizedBox(height: 12),

                      // Status Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('All', themeProv),
                            _buildFilterChip('Running', themeProv),
                            _buildFilterChip('Completed', themeProv),
                            _buildFilterChip('On Hold', themeProv),
                            _buildFilterChip('Cancelled', themeProv),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Projects List
                Expanded(
                  child: filteredProjects.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredProjects.length,
                          itemBuilder: (context, index) {
                            final project = filteredProjects[index];
                            return _ProjectCard(project: project);
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              HapticFeedback.mediumImpact();
              // TODO: Navigate to create project screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Create project feature coming soon'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            icon: Icon(Icons.add, color: AppColors.textPrimaryDark),
            label: Text(
              'New Project',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: themeProv.isDarkMode
                ? AppColors.buttonSecondaryDark
                : AppColors.primaryColor,
            foregroundColor: themeProv.isDarkMode
                ? AppColors.textPrimaryDark
                : AppColors.textPrimary,
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, ThemeProvider themeProv) {
    final isSelected = _selectedStatus == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        backgroundColor: themeProv.isDarkMode
            ? AppColors.buttonSecondaryDark
            : AppColors.buttonSecondary,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          HapticFeedback.selectionClick();
          setState(() => _selectedStatus = label);
        },
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        checkmarkColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : (themeProv.isDarkMode ? Colors.grey[300] : Colors.grey[700]),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredProjects(
    List<Map<String, dynamic>> projects,
  ) {
    var filtered = projects;

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((project) {
        final query = _searchController.text.toLowerCase();
        return project['code'].toString().toLowerCase().contains(query) ||
            project['name'].toString().toLowerCase().contains(query);
      }).toList();
    }

    // Filter by status
    if (_selectedStatus != 'All') {
      filtered = filtered.where((project) {
        return project['status'] == _selectedStatus;
      }).toList();
    }

    return filtered;
  }

  Widget _buildEmptyState() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open_rounded,
                size: 80,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No projects found',
                style: TextStyle(
                  fontSize: 18,
                  color: themeProv.isDarkMode
                      ? AppColors.textHint
                      : AppColors.textHintDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your filters',
                style: TextStyle(
                  fontSize: 14,
                  color: themeProv.isDarkMode
                      ? AppColors.textHint
                      : AppColors.textHintDark,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: themeProv.isDarkMode
                  ? AppColors.backgroundDark
                  : AppColors.backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Projects',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: themeProv.isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Project Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: themeProv.isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: true,
                      onSelected: (_) {},
                    ),
                    ChoiceChip(
                      label: const Text('Project Based'),
                      selected: false,
                      onSelected: (_) {},
                    ),
                    ChoiceChip(
                      label: const Text('Hourly'),
                      selected: false,
                      onSelected: (_) {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProv.isDarkMode
                          ? AppColors.buttonSecondaryDark
                          : AppColors.primaryColor,
                      foregroundColor: AppColors.textPrimaryDark,
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: themeProv.isDarkMode
              ? AppColors.cardDark
              : AppColors.cardColor,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              _showProjectDetails(context, themeProv);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '#${project['code']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          size: 20,
                          color: themeProv.isDarkMode
                              ? AppColors.iconDark
                              : AppColors.iconColor,
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _showProjectMenu(context, themeProv);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Project Name
                  Text(
                    project['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: themeProv.isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Project Type
                  Row(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 16,
                        color: themeProv.isDarkMode
                            ? AppColors.textHint
                            : AppColors.textHintDark,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        project['type'],
                        style: TextStyle(
                          fontSize: 13,
                          color: themeProv.isDarkMode
                              ? AppColors.textHint
                              : AppColors.textHintDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dates Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          context,
                          themeProv,
                          icon: Icons.calendar_today_outlined,
                          label: 'Start',
                          value: project['startDate'],
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          context,
                          themeProv,
                          icon: Icons.event_outlined,
                          label: 'End',
                          value: project['endDate'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status and Payment Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusChip(context, project['status']),
                      _buildPaymentChip(context, project['payment']),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    ThemeProvider themeProv, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: themeProv.isDarkMode
              ? AppColors.textHint
              : AppColors.textHintDark,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color color;
    switch (status) {
      case 'Running':
        color = Colors.green;
        break;
      case 'Completed':
        color = Colors.blue;
        break;
      case 'On Hold':
        color = Colors.orange;
        break;
      case 'Cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentChip(BuildContext context, String payment) {
    final isPaid = payment == 'Paid';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPaid
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        payment,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isPaid ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  void _showProjectDetails(BuildContext context, ThemeProvider themeProv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          return Container(
            decoration: BoxDecoration(
              color: themeProv.isDarkMode
                  ? AppColors.backgroundDark
                  : AppColors.backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: themeProv.isDarkMode
                                ? AppColors.textHint
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        project['name'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: themeProv.isDarkMode
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Project #${project['code']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeProv.isDarkMode
                              ? AppColors.textHint
                              : AppColors.textHintDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildDetailRow('Type', project['type'], themeProv),
                      _buildDetailRow(
                        'Start Date',
                        project['startDate'],
                        themeProv,
                      ),
                      _buildDetailRow(
                        'End Date',
                        project['endDate'],
                        themeProv,
                      ),
                      _buildDetailRow('Status', project['status'], themeProv),
                      _buildDetailRow('Payment', project['payment'], themeProv),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Edit project feature coming soon',
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Project'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeProv.isDarkMode
                                ? AppColors.buttonSecondaryDark
                                : AppColors.primaryColor,
                            foregroundColor: AppColors.textPrimaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeProvider themeProv) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: themeProv.isDarkMode
                  ? AppColors.textHint
                  : AppColors.textHintDark,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: themeProv.isDarkMode
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showProjectMenu(BuildContext context, ThemeProvider themeProv) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          return Container(
            decoration: BoxDecoration(
              color: themeProv.isDarkMode
                  ? AppColors.backgroundDark
                  : AppColors.backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: themeProv.isDarkMode
                          ? AppColors.iconDark
                          : AppColors.iconColor,
                    ),
                    title: Text(
                      'Edit',
                      style: TextStyle(
                        color: themeProv.isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      HapticFeedback.lightImpact();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: themeProv.isDarkMode
                          ? AppColors.iconDark
                          : AppColors.iconColor,
                    ),
                    title: Text(
                      'Share',
                      style: TextStyle(
                        color: themeProv.isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      HapticFeedback.lightImpact();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      HapticFeedback.lightImpact();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
