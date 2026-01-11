// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ClientDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> client;

//   const ClientDetailsScreen({super.key, required this.client});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Client Details'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit_outlined),
//             onPressed: () async {
//               HapticFeedback.lightImpact();
//               // final result = await Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (_) => EditClientScreen(client: client),
//               //   ),
//               // );
//               // if (result == true && mounted) {
//               //   Navigator.pop(context, true);
//               // }
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
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Client Header Card
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Theme.of(
//                         context,
//                       ).colorScheme.primary.withOpacity(0.1),
//                       child: Text(
//                         client['name'].substring(0, 1).toUpperCase(),
//                         style: TextStyle(
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       client['name'],
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Theme.of(
//                           context,
//                         ).colorScheme.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         'Code: ${client['code']}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildStatusBadge(client['status']),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Contact Information
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Contact Information',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildInfoRow(Icons.email, 'Email', client['email']),
//                     _buildInfoRow(Icons.phone, 'Phone', client['phone']),
//                     _buildInfoRow(Icons.chat, 'WhatsApp', client['whatsapp']),
//                     if (client['website'] != null)
//                       _buildInfoRow(
//                         Icons.language,
//                         'Website',
//                         client['website'],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Company Information
//             if (client['companyName'] != null)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Company Information',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildInfoRow(
//                         Icons.business,
//                         'Company',
//                         client['companyName'],
//                       ),
//                       if (client['address'] != null)
//                         _buildInfoRow(
//                           Icons.location_on,
//                           'Address',
//                           client['address'],
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusBadge(String status) {
//     final isActive = status == 'Active';
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: isActive
//             ? Colors.green.withOpacity(0.1)
//             : Colors.red.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: isActive ? Colors.green : Colors.red,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             status,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: isActive ? Colors.green : Colors.red,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 20, color: Colors.grey[600]),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
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
//               title: const Text('Edit Client'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (_) => EditClientScreen(client: client),
//                 //   ),
//                 // );
//               },
//             ),
//             ListTile(
//               leading: Icon(
//                 client['status'] == 'Active' ? Icons.block : Icons.check_circle,
//                 color: client['status'] == 'Active'
//                     ? Colors.orange
//                     : Colors.green,
//               ),
//               title: Text(
//                 client['status'] == 'Active' ? 'Deactivate' : 'Activate',
//                 style: TextStyle(
//                   color: client['status'] == 'Active'
//                       ? Colors.orange
//                       : Colors.green,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 HapticFeedback.lightImpact();
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text(
//                 'Delete Client',
//                 style: TextStyle(color: Colors.red),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 HapticFeedback.lightImpact();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/feature/clients/presentation/view/client_invoice.dart';
import 'package:project_management/feature/clients/presentation/view/client_projects_invoices.dart';
import 'package:project_management/feature/clients/presentation/vm/client_details_vm.dart';
import 'package:project_management/utils/ui_helpers.dart';
import 'package:provider/provider.dart';

class ClientDetailsScreen extends StatelessWidget {
  final String? clientId;

  const ClientDetailsScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientDetailsVM()..fetchClientDetails(clientId),
      child: Consumer<ClientDetailsVM>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Client Details'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: vm.client == null
                      ? null
                      : () async {
                          HapticFeedback.lightImpact();
                          // TODO: Navigate to EditClientScreen
                        },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: vm.client == null
                      ? null
                      : () => _showOptionsMenu(context, vm),
                ),
              ],
            ),
            body: _buildBody(vm, context),
          );
        },
      ),
    );
  }

  Widget _buildBody(ClientDetailsVM vm, context) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.errorMessage != null) {
      return Center(child: Text(vm.errorMessage!));
    }

    if (vm.client == null) {
      return const Center(child: Text('No client details available'));
    }

    final client = vm.client!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client Header Card
          SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Text(
                        client.userName != null
                            ? client.userName!.substring(0, 1).toUpperCase()
                            : '',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      client.userName ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Code: ${client.userCode ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatusBadge(client.isActive ?? false),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientProjectsInvoices(
                          clientID: client.id,
                          isProject: true,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.folder_outlined, size: 18),
                  label: const Text('Projects'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    log("message");
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientInvoicesScreen(
                          clientId: client.id,
                          clientName: "",
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt_long_outlined, size: 18),
                  label: const Text('Invoices'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Contact Information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  if (client.email != null)
                    _buildInfoRow(Icons.email, 'Email', client.email!),
                  if (client.phone != null)
                    _buildInfoRow(Icons.phone, 'Phone', client.phone!),
                  if (client.whatsapp != null)
                    _buildInfoRow(Icons.chat, 'WhatsApp', client.whatsapp!),
                  if (client.website != null)
                    _buildInfoRow(Icons.language, 'Website', client.website!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Address Information
          if (client.address != null && client.address!.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...client.address!.map(
                      (addr) => _buildInfoRow(
                        Icons.location_on,
                        addr.name ?? 'Address',
                        addr.where ?? '',
                      ),
                    ),
                  ],
                ),
              ),
            ),

          UIHelper.verticalSpaceMedium,
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, ClientDetailsVM vm) {
    if (vm.client == null) return;

    final isActive = vm.client!.isActive ?? false;

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
              title: const Text('Edit Client'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                // TODO: Navigate to EditClientScreen
              },
            ),
            ListTile(
              leading: Icon(
                isActive ? Icons.block : Icons.check_circle,
                color: isActive ? Colors.orange : Colors.green,
              ),
              title: Text(
                isActive ? 'Deactivate' : 'Activate',
                style: TextStyle(
                  color: isActive ? Colors.orange : Colors.green,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                // TODO: Toggle status API call
              },
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
                HapticFeedback.lightImpact();
                // TODO: Delete client API call
              },
            ),
          ],
        ),
      ),
    );
  }
}
