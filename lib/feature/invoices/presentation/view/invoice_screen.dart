import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/feature/invoices/model/invoice_list_response_model.dart';
import 'package:project_management/feature/invoices/presentation/view_model/invoice_vm.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoiceVm(),
      child: const _InvoicesContent(),
    );
  }
}

class _InvoicesContent extends StatefulWidget {
  const _InvoicesContent();

  @override
  State<_InvoicesContent> createState() => _InvoicesContentState();
}

class _InvoicesContentState extends State<_InvoicesContent> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvoiceVm>().fetchInvoices();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreInvoices();
    }
  }

  Future<void> _loadMoreInvoices() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);
    await context.read<InvoiceVm>().loadMoreInvoices();
    setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InvoiceVm>();
    final filteredInvoices = _getFilteredInvoices(provider.invoices);

    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return Scaffold(
          backgroundColor: themeProv.isDarkMode
              ? AppColors.backgroundDark
              : AppColors.backgroundColor,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Icon(
                Icons.menu,
                color: themeProv.isDarkMode
                    ? AppColors.iconDark
                    : AppColors.iconColor,
              ),
            ),
            backgroundColor: themeProv.isDarkMode
                ? AppColors.backgroundDark
                : AppColors.backgroundColor,
            title: Text(
              'Invoices',
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
                  _showFilterSheet(context, provider);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              HapticFeedback.mediumImpact();
              await provider.refreshInvoices();
            },
            child: Column(
              children: [
                // Search and Stats Section
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
                          hintText: 'Search invoice number or client',
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
                                    setState(() {
                                      _searchController.clear();
                                      provider.clearFilters();
                                    });
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
                        onChanged: (value) {
                          if (value.isEmpty) {
                            provider.clearFilters();
                          } else {
                            provider.searchInvoices(value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Stats Cards
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: _buildStatCard(
                      //         context,
                      //         'Total',
                      //         provider.totalInvoices.toString(),
                      //         Icons.receipt_long,
                      //         Colors.blue,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 12),
                      //     Expanded(
                      //       child: _buildStatCard(
                      //         context,
                      //         'Unpaid',
                      //         provider.unpaidCount.toString(),
                      //         Icons.schedule,
                      //         Colors.orange,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 12),
                      //     Expanded(
                      //       child: _buildStatCard(
                      //         context,
                      //         'Paid',
                      //         provider.paidCount.toString(),
                      //         Icons.check_circle,
                      //         Colors.green,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 12),

                      // Status Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('All', themeProv, provider),
                            _buildFilterChip('Paid', themeProv, provider),
                            _buildFilterChip('Unpaid', themeProv, provider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Error Message
                if (provider.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: Colors.red.withOpacity(0.1),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () {
                            provider.clearData();
                          },
                        ),
                      ],
                    ),
                  ),

                // Loading Indicator
                if (provider.isLoading && provider.invoices.isEmpty)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                // Invoices List
                else if (filteredInvoices.isEmpty)
                  Expanded(child: _buildEmptyState())
                else
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredInvoices.length + 1,
                      itemBuilder: (context, index) {
                        if (index == filteredInvoices.length) {
                          return _buildLoadMoreIndicator(provider);
                        }
                        final invoice = filteredInvoices[index];
                        return _InvoiceCard(invoice: invoice);
                      },
                    ),
                  ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () {
          //     HapticFeedback.mediumImpact();
          //     // TODO: Navigate to create invoice screen
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(
          //         content: const Text('Create invoice feature coming soon'),
          //         behavior: SnackBarBehavior.floating,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //       ),
          //     );
          //   },
          //   icon: Icon(Icons.add, color: AppColors.textPrimaryDark),
          //   label: Text(
          //     'New Invoice',
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
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    ThemeProvider themeProv,
    InvoiceVm provider,
  ) {
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
          if (label == 'All') {
            provider.clearFilters();
          } else {
            provider.filterByStatus(label);
          }
        },
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
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

  List<InvoiceItem> _getFilteredInvoices(List<InvoiceItem> invoices) {
    var filtered = invoices;

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((invoice) {
        final query = _searchController.text.toLowerCase();
        return invoice.invoiceNumber?.toLowerCase().contains(query) ??
            false || invoice.clientId!.userName!.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by status
    if (_selectedStatus != 'All') {
      filtered = filtered.where((invoice) {
        return invoice.status?.toLowerCase() == _selectedStatus.toLowerCase();
      }).toList();
    }

    return filtered;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No invoices found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator(InvoiceVm provider) {
    if (!provider.hasMore) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text(
          'No more invoices',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  void _showFilterSheet(BuildContext context, InvoiceVm provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Invoices',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            const Text(
              'Date Range',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('This Month'),
                  selected: true,
                  onSelected: (_) {
                    final now = DateTime.now();
                    final firstDayOfMonth = DateTime(now.year, now.month, 1);
                    provider.fetchInvoices(
                      startDate: firstDayOfMonth,
                      endDate: now,
                    );
                    Navigator.pop(context);
                  },
                ),
                ChoiceChip(
                  label: const Text('Last Month'),
                  selected: false,
                  onSelected: (_) {
                    final now = DateTime.now();
                    final lastMonth = DateTime(now.year, now.month - 1, 1);
                    final firstDayOfThisMonth = DateTime(
                      now.year,
                      now.month,
                      1,
                    );
                    provider.fetchInvoices(
                      startDate: lastMonth,
                      endDate: firstDayOfThisMonth,
                    );
                    Navigator.pop(context);
                  },
                ),
                ChoiceChip(
                  label: const Text('This Year'),
                  selected: false,
                  onSelected: (_) {
                    final now = DateTime.now();
                    final firstDayOfYear = DateTime(now.year, 1, 1);
                    provider.fetchInvoices(
                      startDate: firstDayOfYear,
                      endDate: now,
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  provider.clearFilters();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[800],
                ),
                child: const Text('Clear Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final InvoiceItem invoice;

  const _InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<InvoiceVm>();

    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        final clientName = invoice.clientId?.userName ?? 'Unknown Client';
        final amount = invoice.totalAmount ?? 0;
        final status = invoice.status ?? 'unpaid';
        final invoiceNumber = invoice.invoiceNumber ?? '';
        final issueDate = invoice.issueDate;
        final createdAt = invoice.createdAt;

        return Card(
          color: themeProv.isDarkMode
              ? AppColors.cardDark
              : AppColors.cardColor,
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              _showInvoiceDetails(context, invoice);
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              invoiceNumber,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: themeProv.isDarkMode
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (issueDate != null)
                              Text(
                                'Issued: ${_formatDate(issueDate)}',
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
                          _showInvoiceMenu(context, invoice, provider);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Client Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primaryColor.withOpacity(
                          themeProv.isDarkMode ? .3 : .2,
                        ),
                        child: Text(
                          clientName.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: themeProv.isDarkMode
                                ? AppColors.primaryColor
                                : AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Client',
                              style: TextStyle(
                                fontSize: 11,
                                color: themeProv.isDarkMode
                                    ? AppColors.textHint
                                    : AppColors.textHintDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              clientName,
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Amount and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 11,
                              color: themeProv.isDarkMode
                                  ? AppColors.textHint
                                  : AppColors.textHintDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: themeProv.isDarkMode
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      _buildStatusChip(context, status),
                    ],
                  ),

                  // Created at info
                  if (createdAt != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: themeProv.isDarkMode
                              ? AppColors.textHint
                              : AppColors.textHintDark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Created: ${_formatDate(createdAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: themeProv.isDarkMode
                                ? AppColors.textHint
                                : AppColors.textHintDark,
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
      },
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color color;
    IconData icon;
    String displayStatus;

    switch (status.toLowerCase()) {
      case 'paid':
        color = Colors.green;
        icon = Icons.check_circle;
        displayStatus = 'Paid';
        break;
      case 'unpaid':
        color = Colors.orange;
        icon = Icons.pending;
        displayStatus = 'Unpaid';
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
        displayStatus = status;
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
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            displayStatus,
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

  void _showInvoiceDetails(BuildContext context, InvoiceItem invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          final clientName = invoice.clientId?.userName ?? 'Unknown Client';
          final email = invoice.clientId?.email ?? 'No email';
          final phone = invoice.clientId?.phone ?? 'No phone';
          final amount = invoice.totalAmount ?? 0;
          final status = invoice.status ?? 'unpaid';
          final invoiceNumber = invoice.invoiceNumber ?? '';
          final issueDate = invoice.issueDate;
          final notes = invoice.notes ?? 'No notes';
          final discount = invoice.discount ?? 0;
          final tax = invoice.tax ?? 0;

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
              initialChildSize: 0.75,
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
                                ? Colors.grey[700]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Invoice Details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: themeProv.isDarkMode
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                          _buildStatusChip(context, status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        invoiceNumber,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeProv.isDarkMode
                              ? AppColors.textHint
                              : AppColors.textHintDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildDetailRow('Client', clientName, themeProv),
                      _buildDetailRow('Email', email, themeProv),
                      _buildDetailRow('Phone', phone, themeProv),
                      if (issueDate != null)
                        _buildDetailRow(
                          'Issue Date',
                          _formatDate(issueDate),
                          themeProv,
                        ),
                      _buildDetailRow(
                        'Amount',
                        '\$${amount.toStringAsFixed(2)}',
                        themeProv,
                      ),
                      if (discount > 0)
                        _buildDetailRow(
                          'Discount',
                          '\$${discount.toStringAsFixed(2)}',
                          themeProv,
                        ),
                      if (tax > 0)
                        _buildDetailRow(
                          'Tax',
                          '\$${tax.toStringAsFixed(2)}',
                          themeProv,
                        ),
                      _buildDetailRow('Status', status, themeProv),
                      if (notes.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Notes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: themeProv.isDarkMode
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notes,
                          style: TextStyle(
                            fontSize: 14,
                            color: themeProv.isDarkMode
                                ? AppColors.textHint
                                : AppColors.textHintDark,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text(
                        'Projects',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: themeProv.isDarkMode
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (invoice.projects?.isNotEmpty == true)
                        ...invoice.projects!.map<Widget>((project) {
                          final projectName =
                              project.projectId?.name ?? 'Unknown Project';
                          final projectAmount = project.amount ?? 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        projectName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: themeProv.isDarkMode
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Amount: \$${projectAmount.toStringAsFixed(2)}',
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
                                  '\$${projectAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: themeProv.isDarkMode
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                      else
                        const Text('No projects'),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: themeProv.isDarkMode
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '\$${amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: themeProv.isDarkMode
                                  ? AppColors.primaryColor
                                  : AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                context.read<InvoiceVm>().downloadInvoicePDF(
                                  invoice.id!,
                                );
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.download,
                                color: themeProv.isDarkMode
                                    ? AppColors.iconDark
                                    : AppColors.iconColor,
                              ),
                              label: Text(
                                'Download',
                                style: TextStyle(
                                  color: themeProv.isDarkMode
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimary,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: themeProv.isDarkMode
                                      ? Colors.grey[700]!
                                      : Colors.grey[300]!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
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
                      if (status.toLowerCase() == 'unpaid') ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              // context.read<InvoiceVm>().updateInvoiceStatus(
                              //   invoice.id!,
                              //   'paid',
                              // );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Invoice marked as paid'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle),
                            label: const Text('Mark as Paid'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

  void _showInvoiceMenu(
    BuildContext context,
    InvoiceItem invoice,
    InvoiceVm provider,
  ) {
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
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                // TODO: Navigate to edit invoice screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Edit invoice feature coming soon'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Download PDF'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                provider.downloadInvoicePDF(invoice.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Downloading invoice PDF...'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                // TODO: Implement share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Share feature coming soon'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
            if (invoice.status?.toLowerCase() == 'unpaid')
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text(
                  'Mark as Paid',
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () {
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                  provider.updateInvoiceStatusLocally(invoice.id!, 'paid');
                  // Or use API method when available:
                  // provider.updateInvoiceStatusApi(invoice.id!, 'paid');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Invoice marked as paid'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Invoice'),
                    content: const Text(
                      'Are you sure you want to delete this invoice? This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          provider.deleteInvoiceLocally(invoice.id!);
                          // Or use API method when available:
                          // provider.deleteInvoiceApi(invoice.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Invoice deleted'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
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
}
