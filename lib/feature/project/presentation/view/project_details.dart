// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ProjectDetailsScreen extends StatefulWidget {
//   final Map<String, dynamic> project;

//   const ProjectDetailsScreen({super.key, required this.project});

//   @override
//   State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
// }

// class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Project Details'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit_outlined),
//             onPressed: () {
//               HapticFeedback.lightImpact();
//               // TODO: Navigate to edit screen
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Edit feature coming soon'),
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               HapticFeedback.lightImpact();
//               _showOptionsMenu(context);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Project Header Card
//             _buildProjectHeader(),

//             const SizedBox(height: 16),

//             // Documents Section
//             _buildDocumentsSection(),

//             const SizedBox(height: 16),

//             // Social Accounts Section
//             _buildSocialAccountsSection(),

//             const SizedBox(height: 16),

//             // Work Sheets Section
//             _buildWorkSheetsSection(),

//             const SizedBox(height: 80),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProjectHeader() {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Project Name
//             Row(
//               children: [
//                 Text(
//                   'Project Name : ',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     widget.project['name'] ?? 'Llc Formation',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Project Info Grid
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildInfoItem(
//                         label: 'Type',
//                         value: widget.project['type'] ?? 'Monthly',
//                         color: Colors.black87,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildInfoItem(
//                         label: 'Billing Date',
//                         value: widget.project['billingDate'] ?? '2025-11-20',
//                         color: Colors.black87,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildInfoItem(
//                         label: 'Price',
//                         value: widget.project['price'] ?? '34,387 ৳',
//                         color: Colors.black87,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildInfoItem(
//                         label: 'Start Date',
//                         value: widget.project['startDate'] ?? '2025-10-20',
//                         color: Colors.black87,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildInfoItem(
//                         label: 'Cost',
//                         value: widget.project['cost'] ?? '0 ৳',
//                         color: Colors.black87,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildInfoItem(
//                         label: 'End Date',
//                         value: widget.project['endDate'] ?? '--',
//                         color: Colors.black87,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoItem({
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDocumentsSection() {
//     // TODO: Replace with actual documents from API
//     final documents = [
//       {
//         'name': 'Agreement',
//         'subtitle': 'Click to view document',
//         'url': 'https://example.com/agreement.pdf',
//       },
//       {
//         'name': 'SRS',
//         'subtitle': 'Click to view document',
//         'url': 'https://example.com/srs.pdf',
//       },
//     ];

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Documents',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: documents.map((doc) {
//                 return Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: _buildDocumentCard(doc),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDocumentCard(Map<String, dynamic> document) {
//     return InkWell(
//       onTap: () {
//         HapticFeedback.lightImpact();
//         // TODO: Open document
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Opening ${document['name']}...'),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Column(
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Colors.red.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.picture_as_pdf,
//               size: 40,
//               color: Colors.red,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             document['name'],
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             document['subtitle'],
//             style: TextStyle(fontSize: 11, color: Colors.grey[600]),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSocialAccountsSection() {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Social Accounts',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//             ),
//             const SizedBox(height: 20),

//             // Link Field
//             _buildSocialField(
//               label: 'Link :',
//               value: widget.project['socialLink'] ?? '',
//               hasExternalLink: true,
//             ),
//             const SizedBox(height: 16),

//             // Username Field
//             _buildSocialField(
//               label: 'Username :',
//               value: widget.project['socialUsername'] ?? '',
//               hasExternalLink: false,
//             ),
//             const SizedBox(height: 16),

//             // Password Field
//             _buildSocialField(
//               label: 'Password :',
//               value: widget.project['socialPassword'] ?? '',
//               hasExternalLink: false,
//               isPassword: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialField({
//     required String label,
//     required String value,
//     required bool hasExternalLink,
//     bool isPassword = false,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               color: Theme.of(context).colorScheme.primary,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value.isEmpty ? '' : (isPassword ? '••••••••' : value),
//               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//             ),
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.copy, size: 18, color: Colors.grey[600]),
//                 onPressed: value.isEmpty
//                     ? null
//                     : () {
//                         HapticFeedback.lightImpact();
//                         Clipboard.setData(ClipboardData(text: value));
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: const Text('Copied to clipboard'),
//                             behavior: SnackBarBehavior.floating,
//                             duration: const Duration(seconds: 1),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         );
//                       },
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//               if (hasExternalLink) ...[
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: Icon(
//                     Icons.open_in_new,
//                     size: 18,
//                     color: Colors.grey[600],
//                   ),
//                   onPressed: value.isEmpty
//                       ? null
//                       : () {
//                           HapticFeedback.lightImpact();
//                           // TODO: Open link in browser
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: const Text('Opening link...'),
//                               behavior: SnackBarBehavior.floating,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           );
//                         },
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//               ],
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWorkSheetsSection() {
//     // TODO: Replace with actual worksheets from API
//     final worksheets = [
//       {'name': 'Worksheet 1 :', 'link': 'No Link', 'hasLink': false},
//     ];

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Work Sheets',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//             ),
//             const SizedBox(height: 20),
//             ...worksheets.map((worksheet) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       worksheet['name'] as String,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                     Text(
//                       worksheet['link'] as String,
//                       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showOptionsMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.edit),
//               title: const Text('Edit Project'),
//               onTap: () {
//                 Navigator.pop(context);
//                 HapticFeedback.lightImpact();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.file_upload),
//               title: const Text('Upload Document'),
//               onTap: () {
//                 Navigator.pop(context);
//                 HapticFeedback.lightImpact();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.share),
//               title: const Text('Share Project'),
//               onTap: () {
//                 Navigator.pop(context);
//                 HapticFeedback.lightImpact();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.archive),
//               title: const Text('Archive Project'),
//               onTap: () {
//                 Navigator.pop(context);
//                 HapticFeedback.lightImpact();
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text(
//                 'Delete Project',
//                 style: TextStyle(color: Colors.red),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 HapticFeedback.lightImpact();
//                 _showDeleteConfirmation();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDeleteConfirmation() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Project'),
//         content: const Text(
//           'Are you sure you want to delete this project? This action cannot be undone.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               HapticFeedback.mediumImpact();
//               Navigator.pop(context);
//               Navigator.pop(context); // Go back to projects list
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Project deleted successfully'),
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/app/router/config/route_extention.dart';
import 'package:project_management/feature/project/presentation/view_model/project_details_vm.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:project_management/utils/ui_helpers.dart';
import 'package:provider/provider.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;
  final String? projectName; // Optional for immediate display

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
    this.projectName,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late ProjectDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProjectDetailsViewModel(projectId: widget.projectId);
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    await _viewModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return ChangeNotifierProvider.value(
          value: _viewModel,
          child: Scaffold(
            backgroundColor: themeProv.isDarkMode
                ? AppColors.backgroundDark
                : AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: themeProv.isDarkMode
                  ? AppColors.backgroundDark
                  : AppColors.backgroundColor,
              iconTheme: IconThemeData(
                color: themeProv.isDarkMode
                    ? AppColors.iconDark
                    : AppColors.iconColor,
              ),
              title: Consumer<ProjectDetailsViewModel>(
                builder: (context, vm, child) {
                  return Text(
                    vm.projectName.isNotEmpty
                        ? vm.projectName
                        : widget.projectName ?? 'Project Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: themeProv.isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  );
                },
              ),
              actions: [
                Consumer<ProjectDetailsViewModel>(
                  builder: (context, vm, child) {
                    if (vm.isRefreshing) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: themeProv.isDarkMode
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
                          ),
                        ),
                      );
                    }

                    return IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: themeProv.isDarkMode
                            ? AppColors.iconDark
                            : AppColors.iconColor,
                      ),
                      onPressed: vm.isLoading
                          ? null
                          : () => vm.refreshProjectDetails(),
                      tooltip: 'Refresh',
                    );
                  },
                ),

                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 24,
                    color: themeProv.isDarkMode
                        ? AppColors.iconDark
                        : AppColors.iconColor,
                  ),
                  onPressed: () => nav.toEditProject(),
                  tooltip: 'Edit',
                ),
                UIHelper.horizontalSpaceSmall,

                // PopupMenuButton<String>(
                //   onSelected: (value) => _handleMenuAction(value),
                //   itemBuilder: (context) => [
                //     const PopupMenuItem(
                //       value: 'edit',
                //       child: Row(
                //         children: [
                //           Icon(Icons.edit, size: 20),
                //           SizedBox(width: 8),
                //           Text('Edit Project'),
                //         ],
                //       ),
                //     ),
                //     const PopupMenuItem(
                //       value: 'upload',
                //       child: Row(
                //         children: [
                //           Icon(Icons.file_upload, size: 20),
                //           SizedBox(width: 8),
                //           Text('Upload Document'),
                //         ],
                //       ),
                //     ),
                //     const PopupMenuItem(
                //       value: 'share',
                //       child: Row(
                //         children: [
                //           Icon(Icons.share, size: 20),
                //           SizedBox(width: 8),
                //           Text('Share'),
                //         ],
                //       ),
                //     ),
                //     const PopupMenuItem(
                //       value: 'archive',
                //       child: Row(
                //         children: [
                //           Icon(Icons.archive, size: 20),
                //           SizedBox(width: 8),
                //           Text('Archive'),
                //         ],
                //       ),
                //     ),
                //     const PopupMenuDivider(),
                //     const PopupMenuItem(
                //       value: 'delete',
                //       child: Row(
                //         children: [
                //           Icon(Icons.delete, color: Colors.red, size: 20),
                //           SizedBox(width: 8),
                //           Text('Delete', style: TextStyle(color: Colors.red)),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
            body: Consumer<ProjectDetailsViewModel>(
              builder: (context, vm, child) {
                if (vm.isLoading && vm.projectDetails == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.hasError && vm.projectDetails == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          vm.errorMessage ?? 'Failed to load project',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => vm.loadProjectDetails(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return _buildContent(context, vm);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ProjectDetailsViewModel vm) {
    return RefreshIndicator(
      onRefresh: () => vm.refreshProjectDetails(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Header
            _buildProjectHeader(vm),

            const SizedBox(height: 16),

            // Status Indicator
            if (vm.projectDetails != null) _buildStatusIndicator(vm),

            // Documents Section
            if (vm.hasDocuments) _buildDocumentsSection(vm),

            const SizedBox(height: 16),

            // Social Accounts Section
            if (vm.hasSocialAccounts) _buildSocialAccountsSection(vm),

            const SizedBox(height: 16),

            // Work Sheets Section
            if (vm.hasWorkSheets) _buildWorkSheetsSection(vm),
            const SizedBox(height: 16),
            // Notes Section
            if (vm.note?.isNotEmpty == true) _buildNotesSection(vm),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectHeader(ProjectDetailsViewModel vm) {
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    return Card(
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Name
            Row(
              children: [
                Text(
                  'Project Name : ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: Text(
                    vm.projectName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: themeProv.isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Project Info Grid
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem(
                        label: 'Type',
                        value: vm.projectType,
                        color: themeProv.isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        themeProv: themeProv,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoItem(
                        label: 'Billing Date',
                        value: vm.billingDate ?? '--',
                        color: vm.isBillingDue
                            ? Colors.red
                            : (themeProv.isDarkMode
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary),
                        themeProv: themeProv,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem(
                        label: 'Price',
                        value: vm.formatCurrency(vm.price),
                        color: themeProv.isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        themeProv: themeProv,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoItem(
                        label: 'Start Date',
                        value: vm.startDate ?? '--',
                        color: themeProv.isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        themeProv: themeProv,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem(
                        label: 'Cost',
                        value: vm.formatCurrency(vm.cost),
                        color: themeProv.isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        themeProv: themeProv,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoItem(
                        label: 'End Date',
                        value: vm.formatDateString(vm.endDate),
                        color: vm.isOverdue
                            ? Colors.red
                            : (themeProv.isDarkMode
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary),
                        themeProv: themeProv,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Payment Status
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(vm.getStatusColor()),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Payment Status: ${vm.getStatusText()}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(vm.getStatusColor()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(ProjectDetailsViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (vm.isOverdue) _buildStatusChip('Overdue', Colors.red),
          if (vm.isBillingDue) _buildStatusChip('Billing Due', Colors.orange),
          if (!vm.isActive) _buildStatusChip('Inactive', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    required Color color,
    required ThemeProvider themeProv,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: themeProv.isDarkMode
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection(ProjectDetailsViewModel vm) {
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    final documents = [
      if (vm.agreementUrl?.isNotEmpty == true)
        {'name': 'Agreement', 'url': vm.agreementUrl!},
      if (vm.srsUrl?.isNotEmpty == true) {'name': 'SRS', 'url': vm.srsUrl!},
    ];

    if (documents.isEmpty) return const SizedBox();

    return Card(
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Documents',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: documents.map((doc) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildDocumentCard(doc['name']!, doc['url']!, vm),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(
    String name,
    String url,
    ProjectDetailsViewModel vm,
  ) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        // TODO: Open document
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening $name...'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        vm.toggleDocumentSelection(url);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: vm.isDocumentSelected(url)
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                size: 40,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Consumer<ThemeProvider>(
              builder: (context, themeProv, _) {
                return Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Click to view document',
                      style: TextStyle(
                        fontSize: 11,
                        color: themeProv.isDarkMode
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialAccountsSection(ProjectDetailsViewModel vm) {
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    return Card(
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Social Accounts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            ...List.generate(vm.socialAccountCount, (index) {
              final social = vm.getSocialAccount(index);
              if (social == null) return const SizedBox();

              return Column(
                children: [
                  if (index > 0) const SizedBox(height: 16),
                  Text(
                    '${social.name} Account',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSocialField(
                    label: 'Link :',
                    value: social.link ?? '',
                    hasExternalLink: true,
                    onCopy: () => _copyText(social.link ?? ''),
                    onOpen: () => _openLink(social.link ?? ''),
                  ),
                  const SizedBox(height: 12),
                  _buildSocialField(
                    label: 'Username :',
                    value: social.username ?? '',
                    hasExternalLink: false,
                    onCopy: () => _copyText(social.username ?? ''),
                  ),
                  const SizedBox(height: 12),
                  _buildSocialField(
                    label: 'Password :',
                    value: social.password ?? '',
                    hasExternalLink: false,
                    isPassword: true,
                    showPassword: vm.showPassword,
                    onTogglePassword: vm.togglePasswordVisibility,
                    onCopy: () => _copyText(social.password ?? ''),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialField({
    required String label,
    required String value,
    required bool hasExternalLink,
    bool isPassword = false,
    bool showPassword = false,
    VoidCallback? onTogglePassword,
    VoidCallback? onCopy,
    VoidCallback? onOpen,
  }) {
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    final displayValue = value.isEmpty
        ? ''
        : isPassword
        ? (showPassword ? value : '••••••••')
        : value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: themeProv.isDarkMode
            ? AppColors.inputBackgroundDark
            : AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: themeProv.isDarkMode
              ? AppColors.inputBorderDark
              : AppColors.inputBorder,
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayValue,
              style: TextStyle(
                fontSize: 14,
                color: value.isEmpty
                    ? (themeProv.isDarkMode
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary)
                    : (themeProv.isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPassword && value.isNotEmpty)
                IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: themeProv.isDarkMode
                        ? AppColors.iconSecondaryDark
                        : AppColors.iconSecondary,
                  ),
                  onPressed: onTogglePassword,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (value.isNotEmpty) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    size: 18,
                    color: themeProv.isDarkMode
                        ? AppColors.iconSecondaryDark
                        : AppColors.iconSecondary,
                  ),
                  onPressed: onCopy,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
              if (hasExternalLink && value.isNotEmpty) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    Icons.open_in_new,
                    size: 18,
                    color: themeProv.isDarkMode
                        ? AppColors.iconSecondaryDark
                        : AppColors.iconSecondary,
                  ),
                  onPressed: onOpen,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkSheetsSection(ProjectDetailsViewModel vm) {
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    return Card(
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Work Sheets',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            ...List.generate(vm.worksheetCount, (index) {
              final worksheet = vm.getWorksheet(index);
              if (worksheet == null) return const SizedBox();

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${worksheet.name} :',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          worksheet.link?.isEmpty == true
                              ? 'No Link'
                              : worksheet.link!,
                          style: TextStyle(
                            fontSize: 14,
                            color: themeProv.isDarkMode
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                        if (worksheet.link?.isNotEmpty == true) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.open_in_new,
                              size: 16,
                              color: Colors.blue,
                            ),
                            onPressed: () => _openLink(worksheet.link!),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(ProjectDetailsViewModel vm) {
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: themeProv.isDarkMode
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeProv.isDarkMode
                      ? AppColors.inputBackgroundDark
                      : AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: themeProv.isDarkMode
                        ? AppColors.inputBorderDark
                        : AppColors.inputBorder,
                  ),
                ),
                child: Text(
                  vm.note!,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: themeProv.isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _handleMenuAction(String action) {
  //   HapticFeedback.lightImpact();

  //   switch (action) {
  //     case 'edit':
  //       _editProject();
  //       break;
  //     case 'upload':
  //       _uploadDocument();
  //       break;
  //     case 'share':
  //       _shareProject();
  //       break;
  //     case 'archive':
  //       _archiveProject();
  //       break;
  //     case 'delete':
  //       _deleteProject();
  //       break;
  //   }
  // }

  Future<void> _copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Copied to clipboard'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _openLink(String url) async {
    // TODO: Implement URL launcher
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening $url...'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _editProject() {
    // // TODO: Navigate to edit screen
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: const Text('Edit feature coming soon'),
    //     behavior: SnackBarBehavior.floating,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //   ),
    // );
    nav.toEditProject();
  }

  void _uploadDocument() {
    // TODO: Implement document upload
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Upload feature coming soon'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _shareProject() {
    // TODO: Implement share
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share feature coming soon'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _archiveProject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Project'),
        content: const Text('Are you sure you want to archive this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement archive logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Project archived'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  void _deleteProject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text(
          'Are you sure you want to delete this project? This action cannot be undone.',
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
              Navigator.pop(context); // Go back
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Project deleted'),
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

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
