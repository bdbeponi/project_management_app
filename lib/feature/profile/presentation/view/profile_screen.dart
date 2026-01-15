// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:project_management/app/provider/theme_provider.dart';
// import 'package:project_management/app/router/config/route_extention.dart';
// import 'package:project_management/db/service/login/login_local_service.dart';
// import 'package:project_management/gen/colors.gen.dart';
// import 'package:provider/provider.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProv, _) {
//         return Scaffold(
//           backgroundColor: themeProv.isDarkMode
//               ? AppColors.backgroundDark
//               : AppColors.backgroundColor,
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Profile Header with gradient
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: !(themeProv.isDarkMode)
//                           ? [AppColors.containerColor, AppColors.primaryLight]
//                           : [
//                               AppColors.containerColor,
//                               AppColors.backgroundDark,
//                             ],
//                     ),
//                   ),
//                   child: SafeArea(
//                     child: Padding(
//                       padding: const EdgeInsets.all(24),
//                       child: Column(
//                         children: [
//                           // Profile Avatar
//                           Container(
//                             width: 120,
//                             height: 120,
//                             decoration: BoxDecoration(
//                               color: themeProv.isDarkMode
//                                   ? AppColors.backgroundColor
//                                   : AppColors.backgroundDark,
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.white, width: 4),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   blurRadius: 20,
//                                   offset: const Offset(0, 10),
//                                 ),
//                               ],
//                             ),
//                             child: CircleAvatar(
//                               backgroundColor: Colors.white,
//                               child: Text(
//                                 'S',
//                                 style: TextStyle(
//                                   fontSize: 48,
//                                   fontWeight: FontWeight.bold,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'User Name',
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'email@example.com',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white.withOpacity(0.9),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               '#000000',
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Profile Content
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Social Links Section
//                       Text(
//                         'Social Links',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: themeProv.isDarkMode
//                               ? AppColors.backgroundColor
//                               : AppColors.backgroundDark,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Card(
//                         color: themeProv.isDarkMode
//                             ? AppColors.cardDark
//                             : AppColors.cardColor,
//                         child: ListTile(
//                           leading: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: themeProv.isDarkMode
//                                   ? const Color(0xFF1877F2).withOpacity(0.3)
//                                   : const Color(0xFF1877F2).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.facebook,
//                               color: Color(0xFF1877F2),
//                             ),
//                           ),
//                           title: Text(
//                             'Facebook',
//                             style: TextStyle(
//                               color: themeProv.isDarkMode
//                                   ? AppColors.backgroundColor
//                                   : AppColors.backgroundDark,
//                             ),
//                           ),
//                           trailing: const Icon(Icons.chevron_right),
//                           onTap: () {
//                             HapticFeedback.lightImpact();
//                             // TODO: Open Facebook profile
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       // Account Information
//                       Text(
//                         'Account Information',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: themeProv.isDarkMode
//                               ? AppColors.backgroundColor
//                               : AppColors.backgroundDark,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       _buildInfoCard(
//                         context,
//                         themeProv: themeProv,
//                         icon: Icons.person_outline,
//                         title: 'Full Name',
//                         value: 'N/A',
//                         onTap: () => _showEditDialog(context, 'name', ""),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildInfoCard(
//                         context,
//                         themeProv: themeProv,
//                         icon: Icons.email_outlined,
//                         title: 'Email',
//                         value: 'N/A',
//                         onTap: () => _showEditDialog(context, 'email', ""),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildInfoCard(
//                         context,
//                         themeProv: themeProv,
//                         icon: Icons.phone_outlined,
//                         title: 'Phone',
//                         value: 'N/A',
//                         onTap: () =>
//                             _showEditDialog(context, 'phone', "016121....."),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildInfoCard(
//                         context,
//                         themeProv: themeProv,
//                         icon: Icons.badge_outlined,
//                         title: 'Role',
//                         value: 'N/A',
//                         onTap: null,
//                       ),
//                       const SizedBox(height: 24),

//                       // Preferences
//                       const Text(
//                         'Preferences',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Card(
//                         color: themeProv.isDarkMode
//                             ? AppColors.cardDark
//                             : AppColors.cardColor,
//                         child: SwitchListTile(
//                           secondary: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.primary
//                                   .withOpacity(
//                                     themeProv.isDarkMode ? 0.3 : 0.1,
//                                   ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Icon(
//                               themeProv.isDarkMode
//                                   ? Icons.dark_mode
//                                   : Icons.light_mode,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                           title: Text(
//                             'Dark Mode',
//                             style: TextStyle(
//                               color: themeProv.isDarkMode
//                                   ? AppColors.textPrimaryDark
//                                   : AppColors.textPrimary,
//                             ),
//                           ),
//                           subtitle: Text(
//                             themeProv.isDarkMode ? 'Enabled' : 'Disabled',
//                             style: TextStyle(
//                               color: themeProv.isDarkMode
//                                   ? AppColors.textPrimaryDark
//                                   : AppColors.textPrimary,
//                             ),
//                           ),
//                           value: themeProv.isDarkMode,
//                           onChanged: (value) {
//                             HapticFeedback.lightImpact();
//                             themeProv.toggleTheme();
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       // Logout Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 54,
//                         child: ElevatedButton(
//                           onPressed: () => _showLogoutDialog(context),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: const [
//                               Icon(Icons.logout, color: Colors.white),
//                               SizedBox(width: 8),
//                               Text(
//                                 'Logout',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInfoCard(
//     BuildContext context, {
//     required ThemeProvider themeProv,
//     required IconData icon,
//     required String title,
//     required String value,
//     VoidCallback? onTap,
//   }) {
//     return Card(
//       color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: themeProv.isDarkMode
//                 ? AppColors.cardDark
//                 : AppColors.cardColor,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: Theme.of(context).colorScheme.primary),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontSize: 12,
//             color: themeProv.isDarkMode
//                 ? AppColors.textPrimaryDark
//                 : AppColors.textPrimary,
//           ),
//         ),
//         subtitle: Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: themeProv.isDarkMode
//                 ? AppColors.textPrimaryDark
//                 : AppColors.textPrimary,
//           ),
//         ),
//         trailing: onTap != null
//             ? Icon(
//                 Icons.edit_outlined,
//                 size: 20,
//                 color: themeProv.isDarkMode
//                     ? AppColors.textPrimaryDark
//                     : AppColors.textPrimary,
//               )
//             : null,
//         onTap: onTap != null
//             ? () {
//                 HapticFeedback.lightImpact();
//                 onTap();
//               }
//             : null,
//       ),
//     );
//   }

//   void _showEditDialog(
//     BuildContext context,
//     String field,
//     String? currentValue,
//   ) {
//     final controller = TextEditingController(text: currentValue);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Edit ${field[0].toUpperCase()}${field.substring(1)}'),
//         content: TextField(
//           controller: controller,
//           decoration: InputDecoration(hintText: 'Enter new $field'),
//           autofocus: true,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               HapticFeedback.mediumImpact();
//               // final authProvider = Provider.of<AuthProvider>(
//               //   context,
//               //   listen: false,
//               // );
//               // await authProvider.updateProfile({field: controller.text});
//               if (context.mounted) {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Profile updated successfully')),
//                 );
//               }
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             // onPressed: () {
//             //   HapticFeedback.mediumImpact();
//             //   // final authProvider = Provider.of<AuthProvider>(
//             //   //   context,
//             //   //   listen: false,
//             //   // );
//             //   // authProvider.logout();
//             //   // Navigator.of(context).pushAndRemoveUntil(
//             //   //   MaterialPageRoute(builder: (_) => const LoginScreen()),
//             //   //   (route) => false,
//             //   // );

//             // },
//             onPressed: () async {
//               HapticFeedback.mediumImpact();

//               // Close the dialog first
//               Navigator.pop(context);

//               try {
//                 // Option 1: Using Provider
//                 // Uncomment if using Provider
//                 // final authProvider = Provider.of<AuthProvider>(
//                 //   context,
//                 //   listen: false,
//                 // );
//                 // await authProvider.logout();

// ignore_for_file: use_build_context_synchronously

//                 // Option 2: Direct service call
//                 // If you don't have a provider, use your service directly
//                 // await LoginLocalService().clearLoginData();
//                 // DioSingleton.instance.clearAuth(); // Clear Dio headers if needed
//                 await LoginLocalService().clearLoginData();
//                 // Navigate to login screen and clear all previous routes
//                 nav.toLogin();
//               } catch (e) {
//                 // Show error message if logout fails
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Logout failed: ${e.toString()}'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Logout'),
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
import 'package:project_management/db/service/login/login_local_service.dart';
import 'package:project_management/feature/profile/presentation/view_model/profile_vm.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger profile load safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileVm>().loadProfile();
    });

    return Consumer2<ThemeProvider, ProfileVm>(
      builder: (context, themeProv, profileVm, _) {
        final profile = profileVm.profile;

        return Scaffold(
          backgroundColor: themeProv.isDarkMode
              ? AppColors.backgroundDark
              : AppColors.backgroundColor,
          body: profileVm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : profileVm.errorMessage != null
              ? Center(
                  child: Text(
                    profileVm.errorMessage!,
                    style: TextStyle(
                      color: themeProv.isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => profileVm.refreshProfile(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // ================= Header =================
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: !themeProv.isDarkMode
                                  ? [
                                      AppColors.containerColor,
                                      AppColors.primaryLight,
                                    ]
                                  : [
                                      AppColors.containerColor,
                                      AppColors.backgroundDark,
                                    ],
                            ),
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: themeProv.isDarkMode
                                          ? AppColors.backgroundColor
                                          : AppColors.backgroundDark,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        (profile?.userName?.isNotEmpty == true)
                                            ? profile!.userName![0]
                                                  .toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    profile?.userName ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    profile?.email ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      profile?.userCode ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // ================= Content =================
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionTitle('Account Information', themeProv),
                              const SizedBox(height: 12),

                              _buildInfoCard(
                                context,
                                themeProv: themeProv,
                                icon: Icons.person_outline,
                                title: 'Full Name',
                                value: profile?.userName ?? 'N/A',
                                onTap: () => _showEditDialog(
                                  context,
                                  'name',
                                  profile?.userName,
                                ),
                              ),
                              const SizedBox(height: 8),

                              _buildInfoCard(
                                context,
                                themeProv: themeProv,
                                icon: Icons.email_outlined,
                                title: 'Email',
                                value: profile?.email ?? 'N/A',
                                onTap: () => _showEditDialog(
                                  context,
                                  'email',
                                  profile?.email,
                                ),
                              ),
                              const SizedBox(height: 8),

                              _buildInfoCard(
                                context,
                                themeProv: themeProv,
                                icon: Icons.phone_outlined,
                                title: 'Phone',
                                value: profile?.phone ?? 'N/A',
                                onTap: () => _showEditDialog(
                                  context,
                                  'phone',
                                  profile?.phone,
                                ),
                              ),
                              const SizedBox(height: 8),

                              _buildInfoCard(
                                context,
                                themeProv: themeProv,
                                icon: Icons.badge_outlined,
                                title: 'Role',
                                value: profile?.userType ?? 'N/A',
                                onTap: null,
                              ),
                              const SizedBox(height: 24),

                              _sectionTitle('Preferences', themeProv),
                              const SizedBox(height: 12),

                              Card(
                                color: themeProv.isDarkMode
                                    ? AppColors.cardDark
                                    : AppColors.cardColor,
                                child: SwitchListTile(
                                  secondary: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(
                                            themeProv.isDarkMode ? 0.3 : 0.1,
                                          ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      themeProv.isDarkMode
                                          ? Icons.dark_mode
                                          : Icons.light_mode,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  title: Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                      color: themeProv.isDarkMode
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  value: themeProv.isDarkMode,
                                  onChanged: (_) {
                                    HapticFeedback.lightImpact();
                                    themeProv.toggleTheme();
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),

                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => _showLogoutDialog(context),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.logout, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  // ================= Helpers =================

  Widget _sectionTitle(String title, ThemeProvider themeProv) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: themeProv.isDarkMode
            ? AppColors.textPrimaryDark
            : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required ThemeProvider themeProv,
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Card(
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: themeProv.isDarkMode
                ? AppColors.textHint
                : AppColors.textHintDark,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: themeProv.isDarkMode
                ? AppColors.textPrimaryDark
                : AppColors.textPrimary,
          ),
        ),
        // trailing: onTap != null ? const Icon(Icons.edit_outlined) : null,
        // onTap: onTap,
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String field,
    String? currentValue,
  ) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile update not implemented')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              await LoginLocalService().clearLoginData();
              context.read<ProfileVm>().clearProfile();
              nav.toLogin();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
