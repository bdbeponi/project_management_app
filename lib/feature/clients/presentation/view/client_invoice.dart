import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/feature/clients/presentation/vm/client_invoice_vm.dart';
import 'package:project_management/feature/invoices/model/invoice_list_response_model.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class ClientInvoicesScreen extends StatelessWidget {
  final String? clientId;
  final String clientName;

  const ClientInvoicesScreen({
    super.key,
    required this.clientId,
    required this.clientName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientInvoiceVm()
        ..setClientId(clientId)
        ..loadInvoices(),
      child: _ClientInvoicesContent(clientName: clientName),
    );
  }
}

class _ClientInvoicesContent extends StatefulWidget {
  final String clientName;
  const _ClientInvoicesContent({required this.clientName});

  @override
  State<_ClientInvoicesContent> createState() => _ClientInvoicesContentState();
}

class _ClientInvoicesContentState extends State<_ClientInvoicesContent> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final vm = context.read<ClientInvoiceVm>();
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        vm.hasMore) {
      vm.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ClientInvoiceVm, ThemeProvider>(
      builder: (context, vm, themeProv, _) {
        final filteredInvoices = _getFilteredInvoices(vm.invoices);

        return Scaffold(
          backgroundColor: themeProv.isDarkMode
              ? AppColors.backgroundDark
              : AppColors.backgroundColor,
          appBar: AppBar(
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
          ),
          body: RefreshIndicator(
            onRefresh: vm.refreshInvoices,
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search invoice number',
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
                                _searchController.clear();
                                vm.loadInvoices();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: themeProv.isDarkMode
                          ? AppColors.cardDark
                          : const Color(0xFFF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      vm.searchInvoices(value);
                    },
                  ),
                ),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildFilterChip('All', themeProv, vm),
                      _buildFilterChip('Paid', themeProv, vm),
                      _buildFilterChip('Unpaid', themeProv, vm),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Invoice List
                if (vm.isLoading && vm.invoices.isEmpty)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
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
                          return vm.hasMore
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox(height: 24);
                        }
                        final invoice = filteredInvoices[index];
                        return _InvoiceCard(invoice: invoice);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<InvoiceItem> _getFilteredInvoices(List<InvoiceItem> invoices) {
    var filtered = invoices;
    if (_selectedStatus != 'All') {
      filtered = filtered
          .where(
            (inv) => inv.status?.toLowerCase() == _selectedStatus.toLowerCase(),
          )
          .toList();
    }
    return filtered;
  }

  Widget _buildFilterChip(
    String label,
    ThemeProvider themeProv,
    ClientInvoiceVm vm,
  ) {
    final isSelected = _selectedStatus == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedStatus = label;
          });
          if (label == 'All') {
            vm.loadInvoices();
          } else {
            vm.filterByStatus(label);
          }
        },
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        checkmarkColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : (themeProv.isDarkMode ? Colors.grey[300] : Colors.grey[700]),
        ),
        backgroundColor: themeProv.isDarkMode
            ? AppColors.buttonSecondaryDark
            : AppColors.buttonSecondary,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('No invoices found', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

/// Invoice card widget reused from your main screen
class _InvoiceCard extends StatelessWidget {
  final InvoiceItem invoice;
  const _InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    final status = invoice.status ?? 'unpaid';
    final amount = invoice.totalAmount ?? 0;
    final invoiceNumber = invoice.invoiceNumber ?? '';
    final issueDate = invoice.issueDate;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          // TODO: Show invoice details bottom sheet
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoiceNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: themeProv.isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (issueDate != null)
                    Text(
                      'Issued: ${DateFormat('MMM dd, yyyy').format(issueDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeProv.isDarkMode
                            ? AppColors.textHint
                            : AppColors.textHintDark,
                      ),
                    ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      (status.toLowerCase() == 'paid'
                              ? Colors.green
                              : Colors.orange)
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: status.toLowerCase() == 'paid'
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
