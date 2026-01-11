
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/feature/clients/model/client_list_response_model.dart';
import 'package:project_management/feature/clients/presentation/vm/client_vm.dart';
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

  @override
  void initState() {
    super.initState();
    // Fetch clients once the frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientsProvider>().fetchClients();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Item> _filterClients(List<Item> clients) {
    var filtered = clients;

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where(
            (c) =>
                (c.userName ?? '').toLowerCase().contains(query) ||
                (c.userCode ?? '').toLowerCase().contains(query),
          )
          .toList();
    }

    // Status filtering commented out for now
    // if (_selectedStatus != 'All') { ... }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClientsProvider>();
    final clients = _filterClients(provider.clients);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clients',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterSheet(context),
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
            onSearchChanged: (_) => setState(() {}),
          ),
          Expanded(
            child: clients.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: clients.length,
                    itemBuilder: (_, i) => _ClientCard(client: clients[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => HapticFeedback.mediumImpact(),
        icon: const Icon(Icons.add),
        label: const Text('New Client'),
      ),
    );
  }
}

void _showFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Clients',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20),
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

  const _HeaderSection({
    required this.controller,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Search clients',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['All', 'Active', 'Inactive']
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(e),
                        selected: selectedStatus == e,
                        onSelected: (_) => onStatusChanged(e),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/* ========================== CLIENT CARD ========================== */

class _ClientCard extends StatelessWidget {
  final Item client;

  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => HapticFeedback.lightImpact(),
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
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
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
                              color: Theme.of(context).colorScheme.primary,
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '#${client.userCode}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _showClientMenu(context, client);
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
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      client.address?.first.name ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
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
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Details'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Client'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                client.isActive == true ? Icons.block : Icons.check_circle,
                color: client.isActive == true ? Colors.orange : Colors.green,
              ),
              title: Text(
                client.isActive == true ? 'Deactivate' : 'Activate',
                style: TextStyle(
                  color: client.isActive == true ? Colors.orange : Colors.green,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Client',
                style: TextStyle(color: Colors.red),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Client'),
        content: Text(
          'Are you sure you want to delete ${client.userName}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/* ========================== EMPTY STATE ========================== */

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No clients found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
