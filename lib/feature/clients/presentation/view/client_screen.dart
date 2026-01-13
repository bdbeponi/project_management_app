import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/feature/clients/model/client_list_response_model.dart';
import 'package:project_management/feature/clients/presentation/view/client_details.dart';
import 'package:project_management/feature/clients/presentation/vm/client_vm.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:project_management/shared/networks/endpoints.dart';
import 'package:provider/provider.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientsProvider(),
      child: const _ClientsContent(),
    );
  }
}

class _ClientsContent extends StatefulWidget {
  const _ClientsContent();

  @override
  State<_ClientsContent> createState() => _ClientsContentState();
}

class _ClientsContentState extends State<_ClientsContent> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'All';
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce; // <<-- add this

  @override
  void initState() {
    super.initState();

    // Fetch initial clients
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientsProvider>().fetchClients();
    });

    // Pagination listener
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 100), () {
      // Call API with the new search query
      context.read<ClientsProvider>().searchClients(_searchController.text);
    });
  }

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   _scrollController.dispose();
  //   super.dispose();
  // }
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<ClientsProvider>();

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        provider.hasMore &&
        !provider.isLoadingMore) {
      provider.loadMore();
    }
  }

  List<Item> _filterClients(List<Item> clients) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return clients;

    return clients
        .where(
          (c) =>
              (c.userName ?? '').toLowerCase().contains(query) ||
              (c.userCode ?? '').toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClientsProvider>();
    final clients = _filterClients(provider.clients);
    final themeProv = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProv.isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProv.isDarkMode
            ? AppColors.backgroundDark
            : AppColors.backgroundColor,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: themeProv.isDarkMode
              ? AppColors.iconDark
              : AppColors.iconColor,
        ),
        title: Text(
          'Clients',
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
            onPressed: () => _showFilterSheet(context, themeProv),
          ),
        ],
      ),
      body: Column(
        children: [
          _HeaderSection(
            controller: _searchController,
            selectedStatus: _selectedStatus,
            onStatusChanged: (status) {
              HapticFeedback.selectionClick();
              setState(() => _selectedStatus = status);
            },
            onSearchChanged: (_) {}, // Leave empty, debounce handles API
            themeProv: themeProv,
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Clear search text
                _searchController.clear();
                // Reset provider and fetch initial data
                await provider.fetchClients(refresh: true);
              },
              child: provider.isLoading && clients.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : clients.isEmpty
                  ? _EmptyState(themeProv: themeProv)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: clients.length + (provider.hasMore ? 1 : 0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        if (index < clients.length) {
                          return _ClientCard(
                            client: clients[index],
                            themeProv: themeProv,
                          );
                        } else {
                          // Show loading indicator at bottom
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => HapticFeedback.mediumImpact(),
      //   icon: const Icon(Icons.add),
      //   label: const Text('New Client'),
      // ),
    );
  }
}

void _showFilterSheet(BuildContext context, ThemeProvider themeProv) {
  showModalBottomSheet(
    context: context,
    backgroundColor: themeProv.isDarkMode
        ? AppColors.cardDark
        : AppColors.cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Clients',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: themeProv.isDarkMode
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          // Filter chips currently commented out
        ],
      ),
    ),
  );
}

/* ========================== HEADER ========================== */

class _HeaderSection extends StatelessWidget {
  final TextEditingController controller;
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onSearchChanged;
  final ThemeProvider themeProv;

  const _HeaderSection({
    required this.controller,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onSearchChanged,
    required this.themeProv,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      color: themeProv.isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundColor,
      child: Column(
        children: [
          TextField(
            controller: controller,
            style: TextStyle(
              color: themeProv.isDarkMode
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Search clients',
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
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close,
                        color: themeProv.isDarkMode
                            ? AppColors.iconDark
                            : AppColors.iconColor,
                      ),
                      onPressed: () {
                        controller.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: themeProv.isDarkMode
                  ? AppColors.cardDark
                  : AppColors.buttonSecondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: onSearchChanged,
          ),
        ],
      ),
    );
  }
}

/* ========================== CLIENT CARD ========================== */

class _ClientCard extends StatelessWidget {
  final Item client;
  final ThemeProvider themeProv;

  const _ClientCard({required this.client, required this.themeProv});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      elevation: themeProv.isDarkMode ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: themeProv.isDarkMode
            ? BorderSide(color: AppColors.borderDark, width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClientDetailsScreen(clientId: client.id),
            ),
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
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryColor.withOpacity(
                      themeProv.isDarkMode ? 0.3 : 0.1,
                    ),
                    backgroundImage: client.image != null
                        ? NetworkImage(imageUrl + client.image!)
                        : null,
                    child: client.image == null
                        ? Text(
                            (client.userName ?? "-")
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 24,
                              color: themeProv.isDarkMode
                                  ? AppColors.primaryLight
                                  : AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.userName ?? "N/A",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: themeProv.isDarkMode
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(
                              themeProv.isDarkMode ? 0.3 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '#${client.userCode}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: themeProv.isDarkMode
                                  ? AppColors.primaryLight
                                  : AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
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
                      // _showClientMenu(context, client);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: client.email ?? "N/A",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: client.phone ?? "N/A",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.chat_outlined,
                      label: 'WhatsApp',
                      value: client.whatsapp ?? "N/A",
                    ),
                  ),
                ],
              ),
              if (client.address != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 16,
                      color: themeProv.isDarkMode
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      client.address?.first.name ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        color: themeProv.isDarkMode
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
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
              ? AppColors.iconSecondaryDark
              : AppColors.iconSecondary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: themeProv.isDarkMode
                      ? AppColors.textHint
                      : AppColors.textHintDark,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: themeProv.isDarkMode
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showClientMenu(BuildContext context, Item client) {
    final themeProv = context.read<ThemeProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: themeProv.isDarkMode
          ? AppColors.cardDark
          : AppColors.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.visibility,
                color: themeProv.isDarkMode
                    ? AppColors.iconDark
                    : AppColors.iconColor,
              ),
              title: Text(
                'View Details',
                style: TextStyle(
                  color: themeProv.isDarkMode
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: themeProv.isDarkMode
                    ? AppColors.iconDark
                    : AppColors.iconColor,
              ),
              title: Text(
                'Edit Client',
                style: TextStyle(
                  color: themeProv.isDarkMode
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                client.isActive == true ? Icons.block : Icons.check_circle,
                color: client.isActive == true
                    ? AppColors.warningColor
                    : AppColors.successColor,
              ),
              title: Text(
                client.isActive == true ? 'Deactivate' : 'Activate',
                style: TextStyle(
                  color: client.isActive == true
                      ? AppColors.warningColor
                      : AppColors.successColor,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            Divider(
              color: themeProv.isDarkMode
                  ? AppColors.dividerDark
                  : AppColors.dividerColor,
            ),
            ListTile(
              leading: Icon(Icons.delete, color: AppColors.errorColor),
              title: Text(
                'Delete Client',
                style: TextStyle(color: AppColors.errorColor),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, client);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Item client) {
    final themeProv = context.read<ThemeProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProv.isDarkMode
            ? AppColors.cardDark
            : AppColors.cardColor,
        title: Text(
          'Delete Client',
          style: TextStyle(
            color: themeProv.isDarkMode
                ? AppColors.textPrimaryDark
                : AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${client.userName}? This action cannot be undone.',
          style: TextStyle(
            color: themeProv.isDarkMode
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: themeProv.isDarkMode
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Client deleted successfully'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/* ========================== EMPTY STATE ========================== */

class _EmptyState extends StatelessWidget {
  final ThemeProvider themeProv;

  const _EmptyState({required this.themeProv});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: themeProv.isDarkMode
                ? AppColors.iconSecondaryDark
                : AppColors.iconSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No clients found',
            style: TextStyle(
              fontSize: 18,
              color: themeProv.isDarkMode
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: themeProv.isDarkMode
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
