// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:project_management/feature/project/presentation/view_model/project_edit_vm.dart';
// import 'package:project_management/utils/ui_helpers.dart';
// import 'package:provider/provider.dart';

// class EditProjectScreen extends StatefulWidget {
//   final Map<String, dynamic>? project; // null for create new

//   const EditProjectScreen({super.key, this.project});

//   @override
//   State<EditProjectScreen> createState() => _EditProjectScreenState();
// }

// class _EditProjectScreenState extends State<EditProjectScreen> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) {
//         final vm = EditProjectViewModel();
//         vm.initialize(widget.project);
//         return vm;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Consumer<EditProjectViewModel>(
//             builder: (context, vm, child) {
//               return Text(
//                 vm.isCreateMode ? 'Create Project' : 'Update Project',
//               );
//             },
//           ),
//         ),
//         body: Consumer<EditProjectViewModel>(
//           builder: (context, vm, child) {
//             return Form(
//               key: _formKey,
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   // Document Upload Section
//                   _buildDocumentUploads(context),
//                   const SizedBox(height: 24),

//                   // Basic Information
//                   _buildBasicInformation(context),
//                   const SizedBox(height: 24),

//                   // Social Media Section
//                   _buildSocialMediaSection(context),
//                   const SizedBox(height: 24),

//                   // Work Sheet Section
//                   _buildWorkSheetSection(context),
//                   const SizedBox(height: 24),

//                   // Assigned By
//                   _buildAssignedBySection(context),
//                   const SizedBox(height: 32),

//                   // Action Buttons
//                   _buildActionButtons(context),
//                   const SizedBox(height: 32),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildDocumentUploads(BuildContext context) {
//     final vm = Provider.of<EditProjectViewModel>(context, listen: false);

//     return Column(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Agreement paper',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),

//             InkWell(
//               onTap: () {
//                 HapticFeedback.lightImpact();
//                 vm.uploadAgreementPaper();
//               },
//               borderRadius: BorderRadius.circular(12),
//               child: Container(
//                 width: double.infinity,
//                 height: 130,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.upload_file, size: 40, color: Colors.grey),
//                     UIHelper.verticalSpaceMedium,
//                     Text(
//                       'Tap to upload a file',
//                       style: TextStyle(color: Colors.grey),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),

//         UIHelper.verticalSpaceMedium,
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'SRS',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),

//             InkWell(
//               onTap: () {
//                 HapticFeedback.lightImpact();
//                 vm.uploadSRS();
//               },
//               borderRadius: BorderRadius.circular(12),
//               child: Container(
//                 width: double.infinity,
//                 height: 130,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.upload_file, size: 40, color: Colors.grey),
//                     UIHelper.verticalSpaceMedium,
//                     Text(
//                       'Tap to upload a file',
//                       style: TextStyle(color: Colors.grey),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildBasicInformation(BuildContext context) {
//     final vm = Provider.of<EditProjectViewModel>(context);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Row 1: Project Name, Status, Project Type
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: vm.projectNameController,
//               decoration: InputDecoration(
//                 labelText: 'Project Name *',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Required';
//                 }
//                 return null;
//               },
//             ),

//             UIHelper.verticalSpaceMedium,
//             DropdownButtonFormField<String>(
//               value: vm.selectedStatus,
//               decoration: InputDecoration(
//                 labelText: 'Status *',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               items: ['Running', 'Completed', 'On Hold', 'Cancelled', 'Stopped']
//                   .map(
//                     (status) =>
//                         DropdownMenuItem(value: status, child: Text(status)),
//                   )
//                   .toList(),
//               onChanged: (value) {
//                 vm.selectedStatus = value!;
//               },
//             ),
//             UIHelper.verticalSpaceMedium,
//             DropdownButtonFormField<String>(
//               value: vm.selectedProjectType,
//               decoration: InputDecoration(
//                 labelText: 'Project Type *',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               items: ['project based', 'hourly based', 'monthly']
//                   .map(
//                     (type) => DropdownMenuItem(value: type, child: Text(type)),
//                   )
//                   .toList(),
//               onChanged: (value) {
//                 vm.selectedProjectType = value!;
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),

//         // Row 2: Start Date, End Date, Billing Date, Price, Payment Status
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: vm.startDateController,
//               decoration: InputDecoration(
//                 labelText: 'Start Date',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 suffixIcon: const Icon(Icons.calendar_today),
//               ),
//               readOnly: true,
//               onTap: () => vm.selectDate(context, vm.startDateController),
//             ),
//             UIHelper.verticalSpaceMedium,
//             TextFormField(
//               controller: vm.endDateController,
//               decoration: InputDecoration(
//                 labelText: 'End Date',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 suffixIcon: const Icon(Icons.calendar_today),
//               ),
//               readOnly: true,
//               onTap: () => vm.selectDate(context, vm.endDateController),
//             ),
//             UIHelper.verticalSpaceMedium,
//             TextFormField(
//               controller: vm.billingDateController,
//               decoration: InputDecoration(
//                 labelText: 'Billing Date',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 suffixIcon: const Icon(Icons.calendar_today),
//               ),
//               readOnly: true,
//               onTap: () => vm.selectDate(context, vm.billingDateController),
//             ),
//             UIHelper.verticalSpaceMedium,
//             TextFormField(
//               controller: vm.projectPriceController,
//               decoration: InputDecoration(
//                 labelText: 'Project Price *',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Required';
//                 }
//                 return null;
//               },
//             ),
//             UIHelper.verticalSpaceMedium,
//             DropdownButtonFormField<String>(
//               value: vm.selectedPaymentStatus,
//               decoration: InputDecoration(
//                 labelText: 'Client Payment Status *',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               items: ['Paid', 'Unpaid', 'Partial']
//                   .map(
//                     (status) =>
//                         DropdownMenuItem(value: status, child: Text(status)),
//                   )
//                   .toList(),
//               onChanged: (value) {
//                 vm.selectedPaymentStatus = value!;
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildSocialMediaSection(BuildContext context) {
//     final vm = Provider.of<EditProjectViewModel>(context);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Text(
//               'Social Media',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.red,
//               ),
//             ),
//             const Spacer(),
//             IconButton(
//               icon: const Icon(Icons.add_circle_outline),
//               onPressed: () {
//                 HapticFeedback.lightImpact();
//                 // TODO: Add multiple social media accounts functionality
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: const Text('Multiple social accounts coming soon'),
//                     behavior: SnackBarBehavior.floating,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 );
//               },
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Column(
//           children: [
//             TextFormField(
//               controller: vm.socialNameController,
//               decoration: InputDecoration(
//                 labelText: 'Social Name',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             UIHelper.verticalSpaceMedium,
//             TextFormField(
//               controller: vm.socialLinkController,
//               decoration: InputDecoration(
//                 labelText: 'Social Link',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             UIHelper.verticalSpaceMedium,
//             TextFormField(
//               controller: vm.socialUsernameController,
//               decoration: InputDecoration(
//                 labelText: 'User Name',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             UIHelper.verticalSpaceMedium,
//             TextFormField(
//               controller: vm.socialPasswordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               obscureText: true,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildWorkSheetSection(BuildContext context) {
//     final vm = Provider.of<EditProjectViewModel>(context);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Text(
//               'Work Sheet',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.red,
//               ),
//             ),
//             const Spacer(),
//             IconButton(
//               icon: const Icon(Icons.add_circle_outline),
//               onPressed: () {
//                 HapticFeedback.lightImpact();
//                 vm.addWorkSheet();
//               },
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ...vm.workSheets.asMap().entries.map((entry) {
//           final index = entry.key;
//           final sheet = entry.value;

//           return Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: TextFormField(
//                     controller: sheet['name'],
//                     decoration: InputDecoration(
//                       labelText: 'Name',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 UIHelper.horizontalSpaceSmall,
//                 Expanded(
//                   flex: 3,
//                   child: TextFormField(
//                     controller: sheet['link'],
//                     decoration: InputDecoration(
//                       labelText: 'Link',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (vm.workSheets.length > 1) ...[
//                   const SizedBox(width: 8),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.remove_circle_outline,
//                       color: Colors.red,
//                     ),
//                     onPressed: () {
//                       HapticFeedback.lightImpact();
//                       vm.removeWorkSheet(index);
//                     },
//                   ),
//                 ],
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildAssignedBySection(BuildContext context) {
//     final vm = Provider.of<EditProjectViewModel>(context);

//     // TODO: Replace with actual users from API
//     final users = [
//       'anik dutta - 34269',
//       'john doe - 12345',
//       'jane smith - 67890',
//     ];

//     return DropdownButtonFormField<String>(
//       value: vm.selectedAssignee,
//       decoration: InputDecoration(
//         labelText: 'Assigned By *',
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       items: users
//           .map((user) => DropdownMenuItem(value: user, child: Text(user)))
//           .toList(),
//       onChanged: (value) {
//         vm.selectedAssignee = value;
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please select assignee';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     final vm = Provider.of<EditProjectViewModel>(context);

//     return ElevatedButton.icon(
//       onPressed: vm.isLoading ? null : () => _handleSubmit(context),
//       icon: vm.isLoading
//           ? const SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//           : const Icon(Icons.arrow_forward),
//       label: Text(vm.isLoading ? 'SUBMITTING...' : 'SUBMIT'),
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size(double.infinity, 54),
//         backgroundColor: Colors.deepOrange,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   Future<void> _handleSubmit(BuildContext context) async {
//     final vm = Provider.of<EditProjectViewModel>(context, listen: false);

//     if (_formKey.currentState!.validate()) {
//       HapticFeedback.mediumImpact();

//       final success = await vm.submitForm();

//       if (success && context.mounted) {
//         HapticFeedback.heavyImpact();
//         Navigator.pop(context, true);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               vm.isCreateMode
//                   ? 'Project created successfully'
//                   : 'Project updated successfully',
//             ),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     // The ViewModel's dispose will be called by Provider
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/feature/project/presentation/view_model/project_edit_vm.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:project_management/utils/ui_helpers.dart';
import 'package:provider/provider.dart';

class EditProjectScreen extends StatefulWidget {
  final Map<String, dynamic>? project;

  const EditProjectScreen({super.key, this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProv, _) {
        return ChangeNotifierProvider(
          create: (_) => EditProjectViewModel()..initialize(widget.project),
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
              title: Selector<EditProjectViewModel, bool>(
                selector: (_, vm) => vm.isCreateMode,
                builder: (_, isCreate, __) => Text(
                  isCreate ? 'Create Project' : 'Update Project',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: themeProv.isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    _DocumentUploadSection(),
                    SizedBox(height: 24),
                    _BasicInformationSection(),
                    SizedBox(height: 24),
                    _SocialMediaSection(),
                    SizedBox(height: 24),
                    _WorkSheetSection(),
                    SizedBox(height: 24),
                    _AssignedBySection(),
                    SizedBox(height: 32),
                    _SubmitButton(),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/* ----------------------------- DOCUMENT UPLOAD ----------------------------- */

class _DocumentUploadSection extends StatelessWidget {
  const _DocumentUploadSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<EditProjectViewModel>();

    return Column(
      children: [
        UploadCard(
          title: 'Agreement Paper',
          onTap: () {
            HapticFeedback.lightImpact();
            vm.uploadAgreementPaper();
          },
        ),
        UIHelper.verticalSpaceMedium,
        UploadCard(
          title: 'SRS',
          onTap: () {
            HapticFeedback.lightImpact();
            vm.uploadSRS();
          },
        ),
      ],
    );
  }
}

class UploadCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const UploadCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: themeProv.isDarkMode
                ? AppColors.textPrimaryDark
                : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: themeProv.isDarkMode
                  ? AppColors.cardDark
                  : AppColors.cardColor,
              border: Border.all(
                color: themeProv.isDarkMode
                    ? AppColors.borderDark
                    : AppColors.borderColor,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file,
                  size: 40,
                  color: themeProv.isDarkMode
                      ? AppColors.iconSecondaryDark
                      : AppColors.iconSecondary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Tap to upload a file',
                  style: TextStyle(
                    color: themeProv.isDarkMode
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/* --------------------------- BASIC INFORMATION --------------------------- */

class _BasicInformationSection extends StatelessWidget {
  const _BasicInformationSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditProjectViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textField(
          controller: vm.projectNameController,
          label: 'Project Name *',
          validator: _required,
        ),
        UIHelper.verticalSpaceMedium,
        _dropdown(
          label: 'Status *',
          value: vm.selectedStatus,
          items: const [
            'Running',
            'Completed',
            'On Hold',
            'Cancelled',
            'Stopped',
          ],
          onChanged: (v) => vm.selectedStatus = v!,
        ),
        UIHelper.verticalSpaceMedium,
        _dropdown(
          label: 'Project Type *',
          value: vm.selectedProjectType,
          items: const ['project based', 'hourly based', 'monthly'],
          onChanged: (v) => vm.selectedProjectType = v!,
        ),
        UIHelper.verticalSpaceMedium,
        _dateField(context, vm.startDateController, 'Start Date'),
        UIHelper.verticalSpaceMedium,
        _dateField(context, vm.endDateController, 'End Date'),
        UIHelper.verticalSpaceMedium,
        _dateField(context, vm.billingDateController, 'Billing Date'),
        UIHelper.verticalSpaceMedium,
        _textField(
          controller: vm.projectPriceController,
          label: 'Project Price *',
          keyboard: TextInputType.number,
          validator: _required,
        ),
        UIHelper.verticalSpaceMedium,
        _dropdown(
          label: 'Client Payment Status *',
          value: vm.selectedPaymentStatus,
          items: const ['Paid', 'Unpaid', 'Partial'],
          onChanged: (v) => vm.selectedPaymentStatus = v!,
        ),
      ],
    );
  }
}

/* --------------------------- SOCIAL MEDIA --------------------------- */

class _SocialMediaSection extends StatelessWidget {
  const _SocialMediaSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditProjectViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Social Media'),
        _textField(controller: vm.socialNameController, label: 'Social Name'),
        UIHelper.verticalSpaceMedium,
        _textField(controller: vm.socialLinkController, label: 'Social Link'),
        UIHelper.verticalSpaceMedium,
        _textField(controller: vm.socialUsernameController, label: 'User Name'),
        UIHelper.verticalSpaceMedium,
        _textField(
          controller: vm.socialPasswordController,
          label: 'Password',
          obscure: true,
        ),
      ],
    );
  }
}

/* ----------------------------- WORK SHEET ----------------------------- */

class _WorkSheetSection extends StatelessWidget {
  const _WorkSheetSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditProjectViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'Work Sheet',
          action: IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: vm.addWorkSheet,
          ),
        ),
        ...vm.workSheets.asMap().entries.map((entry) {
          final index = entry.key;
          final sheet = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: _textField(controller: sheet['name']!, label: 'Name'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _textField(controller: sheet['link']!, label: 'Link'),
                ),
                if (vm.workSheets.length > 1)
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: () => vm.removeWorkSheet(index),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

/* ----------------------------- ASSIGNED BY ----------------------------- */

class _AssignedBySection extends StatelessWidget {
  const _AssignedBySection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditProjectViewModel>();

    final users = const [
      'anik dutta - 34269',
      'john doe - 12345',
      'jane smith - 67890',
    ];

    return _dropdown(
      label: 'Assigned By *',
      value: vm.selectedAssignee,
      items: users,
      validator: _required,
      onChanged: (v) => vm.selectedAssignee = v,
    );
  }
}

/* ----------------------------- SUBMIT ----------------------------- */

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return Selector<EditProjectViewModel, bool>(
      selector: (_, vm) => vm.isLoading,
      builder: (_, isLoading, __) {
        return ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  final form = Form.of(context);
                  if (!form.validate()) return;

                  final vm = context.read<EditProjectViewModel>();
                  HapticFeedback.mediumImpact();

                  final success = await vm.submitForm();
                  if (!context.mounted || !success) return;

                  Navigator.pop(context, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        vm.isCreateMode
                            ? 'Project created successfully'
                            : 'Project updated successfully',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            backgroundColor: Colors.deepOrange,
          ),
          child: isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : const Text('SUBMIT'),
        );
      },
    );
  }
}

/* ----------------------------- HELPERS ----------------------------- */

Widget _sectionHeader(String title, {Widget? action}) {
  return Builder(
    builder: (context) {
      final themeProv = Provider.of<ThemeProvider>(context, listen: false);
      return Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: themeProv.isDarkMode
                  ? AppColors.errorLight
                  : AppColors.errorColor,
            ),
          ),
          const Spacer(),
          if (action != null) action,
        ],
      );
    },
  );
}

Widget _textField({
  required TextEditingController controller,
  required String label,
  bool obscure = false,
  TextInputType? keyboard,
  String? Function(String?)? validator,
}) {
  return Builder(
    builder: (context) {
      final themeProv = Provider.of<ThemeProvider>(context, listen: false);
      return TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        validator: validator,
        style: TextStyle(
          color: themeProv.isDarkMode
              ? AppColors.textPrimaryDark
              : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: themeProv.isDarkMode
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
          filled: true,
          fillColor: themeProv.isDarkMode
              ? AppColors.inputBackgroundDark
              : AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: themeProv.isDarkMode
                  ? AppColors.inputBorderDark
                  : AppColors.inputBorder,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: themeProv.isDarkMode
                  ? AppColors.inputBorderDark
                  : AppColors.inputBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
        ),
      );
    },
  );
}

Widget _dropdown({
  required String label,
  required List<String> items,
  String? value,
  String? Function(String?)? validator,
  required ValueChanged<String?> onChanged,
}) {
  return Builder(
    builder: (context) {
      final themeProv = Provider.of<ThemeProvider>(context, listen: false);
      return DropdownButtonFormField<String>(
        value: value,
        validator: validator,
        dropdownColor: themeProv.isDarkMode
            ? AppColors.cardDark
            : AppColors.cardColor,
        style: TextStyle(
          color: themeProv.isDarkMode
              ? AppColors.textPrimaryDark
              : AppColors.textPrimary,
        ),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: TextStyle(
                    color: themeProv.isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: themeProv.isDarkMode
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
          filled: true,
          fillColor: themeProv.isDarkMode
              ? AppColors.inputBackgroundDark
              : AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: themeProv.isDarkMode
                  ? AppColors.inputBorderDark
                  : AppColors.inputBorder,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: themeProv.isDarkMode
                  ? AppColors.inputBorderDark
                  : AppColors.inputBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
        ),
      );
    },
  );
}

Widget _dateField(
  BuildContext context,
  TextEditingController controller,
  String label,
) {
  final vm = context.read<EditProjectViewModel>();
  final themeProv = Provider.of<ThemeProvider>(context, listen: false);

  return TextFormField(
    controller: controller,
    readOnly: true,
    onTap: () => vm.selectDate(context, controller),
    style: TextStyle(
      color: themeProv.isDarkMode
          ? AppColors.textPrimaryDark
          : AppColors.textPrimary,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: themeProv.isDarkMode
            ? AppColors.textSecondaryDark
            : AppColors.textSecondary,
      ),
      suffixIcon: Icon(
        Icons.calendar_today,
        color: themeProv.isDarkMode
            ? AppColors.iconSecondaryDark
            : AppColors.iconSecondary,
      ),
      filled: true,
      fillColor: themeProv.isDarkMode
          ? AppColors.inputBackgroundDark
          : AppColors.inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: themeProv.isDarkMode
              ? AppColors.inputBorderDark
              : AppColors.inputBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: themeProv.isDarkMode
              ? AppColors.inputBorderDark
              : AppColors.inputBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
    ),
  );
}

String? _required(String? v) => v == null || v.isEmpty ? 'Required' : null;
