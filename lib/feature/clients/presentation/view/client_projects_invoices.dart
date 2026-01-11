import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/feature/clients/presentation/vm/client_project_invoice_vm.dart';
import 'package:project_management/feature/project/model/get_project_list_response_model.dart';
import 'package:project_management/feature/project/presentation/view/project_screen.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class ClientProjectsInvoices extends StatelessWidget {
  const ClientProjectsInvoices({
    super.key,
    this.clientID,
    required this.isProject,
  });

  final String? clientID;
  final bool isProject;

  @override
  Widget build(BuildContext context) {
    if (isProject) {
      return ChangeNotifierProvider(
        create: (_) => ClientProjectInvoiceVm()
          ..setUserId(clientID)
          ..loadProjects(),
        child: const _ProjectsInvoicesContent(),
      );
    }

    // Placeholder for Invoices screen
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Invoices',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: const Center(child: Text('Invoices will be displayed here')),
    );
  }
}

class _ProjectsInvoicesContent extends StatefulWidget {
  const _ProjectsInvoicesContent();

  @override
  State<_ProjectsInvoicesContent> createState() =>
      _ProjectsInvoicesContentState();
}

class _ProjectsInvoicesContentState extends State<_ProjectsInvoicesContent> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _selectedStatus = 'All';
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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
    final provider = Provider.of<ClientProjectInvoiceVm>(
      context,
      listen: false,
    );
    if (!provider.isLoading && provider.hasMore) {
      provider.loadNextPage();
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final provider = Provider.of<ClientProjectInvoiceVm>(
        context,
        listen: false,
      );
      if (query.isEmpty) {
        provider.clear();
        provider.loadProjects();
      } else {
        provider.searchProjects(query);
      }
    });
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    final provider = Provider.of<ClientProjectInvoiceVm>(
      context,
      listen: false,
    );
    await provider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProjectInvoiceVm>(
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
                title: provider.isLoading && provider.projects.isEmpty
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
              body: provider.isLoading && provider.projects.isEmpty
                  ? _buildInitialLoadingState(themeProv)
                  : provider.error.isNotEmpty && provider.projects.isEmpty
                  ? _buildErrorState(provider.error, themeProv)
                  : RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollEndNotification &&
                              _scrollController.position.extentAfter == 0 &&
                              provider.hasMore &&
                              !provider.isLoading) {
                            _loadMoreProjects();
                          }
                          return false;
                        },
                        child: Column(
                          children: [
                            // Search & Status Filters
                            Container(
                              padding: const EdgeInsets.all(16),
                              color: themeProv.isDarkMode
                                  ? AppColors.backgroundDark
                                  : AppColors.backgroundColor,
                              child: Column(
                                children: [
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
                                                provider.clear();
                                                provider.loadProjects();
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

                            // Projects List
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
                                        if (index == filteredProjects.length) {
                                          return _buildLoadMoreWidget(
                                            provider,
                                            themeProv,
                                          );
                                        }

                                        final project = filteredProjects[index];
                                        return ProjectCard(project: project);
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  // ================================
  // Helper Widgets
  // ================================

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
      child: CircularProgressIndicator(
        color: themeProv.isDarkMode
            ? AppColors.primaryColor
            : AppColors.primaryColor,
      ),
    );
  }

  Widget _buildErrorState(String error, ThemeProvider themeProv) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<ClientProjectInvoiceVm>(
                context,
                listen: false,
              );
              provider.loadProjects();
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
    );
  }

  List<Item> _getFilteredProjects(List<Item> projects) {
    var filtered = projects;

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

  Widget _buildFilterChip(
    String label,
    ThemeProvider themeProv,
    ClientProjectInvoiceVm provider,
  ) {
    bool isSelected = _selectedStatus == label;
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
              provider.filterByStatus('active');
              break;
            case 'Inactive':
              provider.filterByStatus('inactive');
              break;
            case 'Paid':
              // Add payment filter logic if needed
              break;
            case 'Unpaid':
              // Add payment filter logic if needed
              break;
            default:
              provider.filterByStatus("");
          }
        },
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        checkmarkColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildEmptyState(ThemeProvider themeProv, [String? customMessage]) {
    return Center(child: Text(customMessage ?? 'No projects found'));
  }

  Widget _buildLoadMoreWidget(
    ClientProjectInvoiceVm provider,
    ThemeProvider themeProv,
  ) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (!provider.hasMore) {
      return const SizedBox.shrink();
    } else {
      return Center(
        child: ElevatedButton(
          onPressed: _loadMoreProjects,
          child: const Text('Load More'),
        ),
      );
    }
  }

  void _showAdvancedFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          const SizedBox(height: 300, child: Center(child: Text('Filters'))),
    );
  }
}
