import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/app/router/config/route_extention.dart';
import 'package:project_management/feature/project/model/get_project_list_response_model.dart';
import 'package:project_management/feature/project/presentation/view_model/project_vm.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProjectVm(),
      child: const _ProjectsContent(),
    );
  }
}

class _ProjectsContent extends StatefulWidget {
  const _ProjectsContent();

  @override
  State<_ProjectsContent> createState() => _ProjectsContentState();
}

class _ProjectsContentState extends State<_ProjectsContent> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _selectedStatus = 'All';
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProjectVm>(context, listen: false);
      provider.loadInitialProjects();
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProjects();
    }
  }

  void _loadMoreProjects() {
    final provider = Provider.of<ProjectVm>(context, listen: false);
    if (!provider.isLoadingMore && provider.hasMore) {
      provider.loadMoreProjects();
    }
  }

  void _onSearchChanged(String query) {
    // Cancel previous debounce timer
    _searchDebounce?.cancel();

    // Start a new debounce timer
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final provider = Provider.of<ProjectVm>(context, listen: false);
      if (query.isEmpty) {
        provider.clearSearch();
      } else {
        provider.searchProjects(query: query);
      }
    });
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    final provider = Provider.of<ProjectVm>(context, listen: false);
    await provider.refreshProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectVm>(
      builder: (context, provider, _) {
        final filteredProjects = _getFilteredProjects(provider.projects);
        final isSearching = _searchController.text.isNotEmpty;

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
                title: provider.isLoading && provider.isInitialLoad
                    ? _buildLoadingAppBarTitle(themeProv)
                    : Text(
                        'Projects (${provider.projects.length})',
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
                      _showAdvancedFilterSheet(context);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: provider.isLoading && provider.isInitialLoad
                  ? _buildInitialLoadingState(themeProv)
                  : provider.errorMessage != null && provider.projects.isEmpty
                  ? _buildErrorState(provider.errorMessage!, themeProv)
                  : RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollEndNotification &&
                              _scrollController.position.extentAfter == 0 &&
                              provider.hasMore &&
                              !provider.isLoadingMore) {
                            _loadMoreProjects();
                          }
                          return false;
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
                                      hintText: 'Search projects...',
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
                                      suffixIcon:
                                          _searchController.text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                _searchController.clear();
                                                provider.clearSearch();
                                              },
                                            )
                                          : null,
                                      filled: true,
                                      fillColor: themeProv.isDarkMode
                                          ? AppColors.cardDark
                                          : const Color.fromARGB(
                                              255,
                                              242,
                                              242,
                                              242,
                                            ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onChanged: _onSearchChanged,
                                  ),
                                  const SizedBox(height: 12),

                                  // Status Filter Chips
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        _buildFilterChip(
                                          'All',
                                          themeProv,
                                          provider,
                                        ),
                                        _buildFilterChip(
                                          'Active',
                                          themeProv,
                                          provider,
                                        ),
                                        _buildFilterChip(
                                          'Inactive',
                                          themeProv,
                                          provider,
                                        ),
                                        _buildFilterChip(
                                          'Paid',
                                          themeProv,
                                          provider,
                                        ),
                                        _buildFilterChip(
                                          'Unpaid',
                                          themeProv,
                                          provider,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Stats Overview
                            // if (provider.projects.isNotEmpty && !isSearching)
                            //   Container(
                            //     padding: const EdgeInsets.symmetric(
                            //       horizontal: 16,
                            //       vertical: 12,
                            //     ),
                            //     color: themeProv.isDarkMode
                            //         ? AppColors.cardDark.withOpacity(0.5)
                            //         : Colors.grey[50],
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         _buildStatItem(
                            //           context,
                            //           'Total',
                            //           provider.projects.length.toString(),
                            //           themeProv,
                            //         ),
                            //         _buildStatItem(
                            //           context,
                            //           'Active',
                            //           provider.projects
                            //               .where((p) => p.isActive == true)
                            //               .length
                            //               .toString(),
                            //           themeProv,
                            //         ),
                            //         _buildStatItem(
                            //           context,
                            //           'Monthly',
                            //           provider.projects
                            //               .where(
                            //                 (p) =>
                            //                     p.projectType ==
                            //                     ProjectType.MONTHLY,
                            //               )
                            //               .length
                            //               .toString(),
                            //           themeProv,
                            //         ),
                            //         _buildStatItem(
                            //           context,
                            //           'Paid',
                            //           provider.projects
                            //               .where(
                            //                 (p) =>
                            //                     p.cPaymentStatus ==
                            //                     PaymentStatus.PAID,
                            //               )
                            //               .length
                            //               .toString(),
                            //           themeProv,
                            //         ),
                            //       ],
                            //     ),
                            //   ),

                            // Projects List with Load More
                            Expanded(
                              child: provider.projects.isEmpty
                                  ? _buildEmptyState(
                                      themeProv,
                                      isSearching
                                          ? 'No projects found for "${_searchController.text}"'
                                          : null,
                                    )
                                  : ListView.builder(
                                      controller: _scrollController,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(16),
                                      itemCount:
                                          filteredProjects.length +
                                          (provider.hasMore ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        // Load more indicator
                                        if (index == filteredProjects.length) {
                                          return _buildLoadMoreWidget(
                                            provider,
                                            themeProv,
                                          );
                                        }

                                        final project = filteredProjects[index];
                                        return _ProjectCard(project: project);
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
              // floatingActionButton: FloatingActionButton.extended(
              //   onPressed: () {
              //     HapticFeedback.mediumImpact();
              //     // TODO: Navigate to create project screen
              //   },
              //   icon: Icon(Icons.add, color: AppColors.textPrimaryDark),
              //   label: Text(
              //     'New Project',
              //     style: TextStyle(
              //       color: AppColors.textPrimaryDark,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              //   backgroundColor: themeProv.isDarkMode
              //       ? AppColors.buttonSecondaryDark
              //       : AppColors.primaryColor,
              //   foregroundColor: themeProv.isDarkMode
              //       ? AppColors.textPrimaryDark
              //       : AppColors.textPrimary,
              // ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingAppBarTitle(ThemeProvider themeProv) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: themeProv.isDarkMode
                ? AppColors.textPrimaryDark
                : AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Loading...',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: themeProv.isDarkMode
                ? AppColors.textPrimaryDark
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInitialLoadingState(ThemeProvider themeProv) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: themeProv.isDarkMode
                ? AppColors.primaryColor
                : AppColors.primaryColor,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading projects...',
            style: TextStyle(
              fontSize: 16,
              color: themeProv.isDarkMode
                  ? AppColors.textHint
                  : AppColors.textHintDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, ThemeProvider themeProv) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error.length > 100 ? '${error.substring(0, 100)}...' : error,
              style: TextStyle(
                fontSize: 14,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final provider = Provider.of<ProjectVm>(context, listen: false);
                provider.loadInitialProjects();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProv.isDarkMode
                    ? AppColors.buttonSecondaryDark
                    : AppColors.primaryColor,
                foregroundColor: AppColors.textPrimaryDark,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreWidget(ProjectVm provider, ThemeProvider themeProv) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          if (provider.isLoadingMore)
            CircularProgressIndicator(
              strokeWidth: 2,
              color: themeProv.isDarkMode
                  ? AppColors.primaryColor
                  : AppColors.primaryColor,
            )
          else if (provider.hasMore)
            ElevatedButton(
              onPressed: () => _loadMoreProjects(),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProv.isDarkMode
                    ? AppColors.cardDark
                    : Colors.grey[200],
                foregroundColor: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Load More'),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No more projects',
                style: TextStyle(
                  color: themeProv.isDarkMode
                      ? AppColors.textHint
                      : AppColors.textHintDark,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    ThemeProvider themeProv,
    ProjectVm provider,
  ) {
    bool isSelected = _selectedStatus == label;

    if (label == 'All' && _selectedStatus.isEmpty) {
      isSelected = true;
    }

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
          setState(() => _selectedStatus = selected ? label : 'All');

          switch (label) {
            case 'Active':
              provider.filterByStatus(status: 'active');
              break;
            case 'Inactive':
              provider.filterByStatus(status: 'inactive');
              break;
            case 'Paid':
              // You might need to implement payment status filter
              break;
            case 'Unpaid':
              // You might need to implement payment status filter
              break;
            default:
              provider.filterByStatus(status: null);
          }
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

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    ThemeProvider themeProv,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: themeProv.isDarkMode
                ? AppColors.textPrimaryDark
                : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: themeProv.isDarkMode
                ? AppColors.textHint
                : AppColors.textHintDark,
          ),
        ),
      ],
    );
  }

  List<Item> _getFilteredProjects(List<Item> projects) {
    var filtered = projects;

    // Filter by status chip selection
    if (_selectedStatus != 'All') {
      filtered = filtered.where((project) {
        switch (_selectedStatus) {
          case 'Active':
            return project.isActive == true;
          case 'Inactive':
            return project.isActive == false;
          case 'Paid':
            return project.cPaymentStatus == PaymentStatus.PAID;
          case 'Unpaid':
            return project.cPaymentStatus == PaymentStatus.UNPAID;
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  Widget _buildEmptyState(ThemeProvider themeProv, [String? customMessage]) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 20),
            Text(
              customMessage ?? 'No projects found',
              style: TextStyle(
                fontSize: 18,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (customMessage == null)
              Text(
                'Create your first project to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: themeProv.isDarkMode
                      ? AppColors.textHint
                      : AppColors.textHintDark,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  void _showAdvancedFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AdvancedFilterSheet(
        onApplyFilters: (filters) {
          final provider = Provider.of<ProjectVm>(context, listen: false);
          if (filters['status'] != null) {
            provider.filterByStatus(status: filters['status']);
          }
          if (filters['role'] != null) {
            provider.filterByRole(role: filters['role']);
          }
          if (filters['orderBy'] != null) {
            provider.sortProjects(orderBy: filters['orderBy']!);
          }
        },
      ),
    );
  }
}

class _AdvancedFilterSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const _AdvancedFilterSheet({required this.onApplyFilters});

  @override
  State<_AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<_AdvancedFilterSheet> {
  String? _selectedProjectType;
  String? _selectedPaymentStatus;
  String _selectedSortOrder = 'desc';
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: themeProv.isDarkMode
                ? AppColors.backgroundDark
                : AppColors.backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Advanced Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: themeProv.isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Project Type
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
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _selectedProjectType == null,
                    onSelected: (_) =>
                        setState(() => _selectedProjectType = null),
                  ),
                  ChoiceChip(
                    label: const Text('Project Based'),
                    selected: _selectedProjectType == 'project_based',
                    onSelected: (_) =>
                        setState(() => _selectedProjectType = 'project_based'),
                  ),
                  ChoiceChip(
                    label: const Text('Monthly'),
                    selected: _selectedProjectType == 'monthly',
                    onSelected: (_) =>
                        setState(() => _selectedProjectType = 'monthly'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Payment Status
              Text(
                'Payment Status',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: themeProv.isDarkMode
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _selectedPaymentStatus == null,
                    onSelected: (_) =>
                        setState(() => _selectedPaymentStatus = null),
                  ),
                  ChoiceChip(
                    label: const Text('Paid'),
                    selected: _selectedPaymentStatus == 'paid',
                    onSelected: (_) =>
                        setState(() => _selectedPaymentStatus = 'paid'),
                  ),
                  ChoiceChip(
                    label: const Text('Unpaid'),
                    selected: _selectedPaymentStatus == 'unpaid',
                    onSelected: (_) =>
                        setState(() => _selectedPaymentStatus = 'unpaid'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sort Order
              Text(
                'Sort Order',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: themeProv.isDarkMode
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Newest First'),
                    selected: _selectedSortOrder == 'desc',
                    onSelected: (_) =>
                        setState(() => _selectedSortOrder = 'desc'),
                  ),
                  ChoiceChip(
                    label: const Text('Oldest First'),
                    selected: _selectedSortOrder == 'asc',
                    onSelected: (_) =>
                        setState(() => _selectedSortOrder = 'asc'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final filters = {
                      'status': _selectedProjectType,
                      'role': _selectedRole,
                      'orderBy': _selectedSortOrder,
                    };
                    widget.onApplyFilters(filters);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProv.isDarkMode
                        ? AppColors.buttonSecondaryDark
                        : AppColors.primaryColor,
                    foregroundColor: AppColors.textPrimaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
              const SizedBox(height: 16),

              // Reset Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedProjectType = null;
                      _selectedPaymentStatus = null;
                      _selectedSortOrder = 'desc';
                      _selectedRole = null;
                    });
                  },
                  child: const Text('Reset Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Keep the _ProjectCard class as it is (from previous code)
class _ProjectCard extends StatelessWidget {
  final Item project;

  const _ProjectCard({required this.project});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatString(String? text) {
    return text ?? 'N/A';
  }

  Color _getStatusColor(bool? isActive) {
    if (isActive == true) return Colors.green;
    if (isActive == false) return Colors.red;
    return Colors.grey;
  }

  String _getStatusText(bool? isActive) {
    if (isActive == true) return 'Active';
    if (isActive == false) return 'Inactive';
    return 'Unknown';
  }

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
            onTap: () async {
              HapticFeedback.lightImpact();
              // _showProjectDetails(context, themeProv);


              nav.toProjectDetails(
                projectId: project.id,
                projectName: project.name,
              );
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
                          '#${_formatString(project.code)}',
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
                    _formatString(project.name),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: themeProv.isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                        project.projectType?.name.toUpperCase() ?? 'N/A',
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
                          value: _formatDate(project.startDate),
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          context,
                          themeProv,
                          icon: Icons.event_outlined,
                          label: 'End',
                          value: _formatString(project.endDate),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status and Payment Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusChip(
                        context,
                        _getStatusText(project.isActive),
                        _getStatusColor(project.isActive),
                      ),
                      _buildPaymentChip(
                        context,
                        project.cPaymentStatus?.name ?? 'Unknown',
                      ),
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

  Widget _buildStatusChip(BuildContext context, String status, Color color) {
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
    final isPaid = payment.toLowerCase() == 'paid';
    final color = isPaid ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        payment.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
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
                        _formatString(project.name),
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
                        'Project #${_formatString(project.code)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeProv.isDarkMode
                              ? AppColors.textHint
                              : AppColors.textHintDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildDetailRow(
                        'Project Type',
                        project.projectType?.name.toUpperCase() ?? 'N/A',
                        themeProv,
                      ),
                      _buildDetailRow(
                        'Start Date',
                        _formatDate(project.startDate),
                        themeProv,
                      ),
                      _buildDetailRow(
                        'End Date',
                        _formatString(project.endDate),
                        themeProv,
                      ),
                      _buildDetailRow(
                        'Billing Date',
                        _formatDate(project.billingDate),
                        themeProv,
                      ),
                      _buildDetailRow(
                        'Status',
                        _getStatusText(project.isActive),
                        themeProv,
                      ),
                      _buildDetailRow(
                        'Payment Status',
                        project.cPaymentStatus?.name.toUpperCase() ?? 'N/A',
                        themeProv,
                      ),
                      _buildDetailRow(
                        'Cost',
                        _formatString(project.cost),
                        themeProv,
                      ),
                      _buildDetailRow(
                        'Price',
                        _formatString(project.price),
                        themeProv,
                      ),
                      if (project.note != null && project.note!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Note',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: themeProv.isDarkMode
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              project.note!,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeProv.isDarkMode
                                    ? AppColors.textHint
                                    : AppColors.textHintDark,
                              ),
                            ),
                          ],
                        ),
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
