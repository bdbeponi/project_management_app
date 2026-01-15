import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/gen/colors.gen.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            iconTheme: IconThemeData(
              color: themeProv.isDarkMode
                  ? AppColors.iconDark
                  : AppColors.iconColor,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // User Profile Card
              // _buildProfileCard(context, user),
              const SizedBox(height: 24),

              // Appearance Section
              _buildSectionHeader('Appearance', themeProv),
              const SizedBox(height: 12),
              _buildThemeCard(context, themeProv),
              const SizedBox(height: 24),

              // Notifications Section
              _buildSectionHeader('Notifications', themeProv),
              const SizedBox(height: 12),
              _buildNotificationSettings(context, themeProv),
              const SizedBox(height: 24),

              // Account Section
              _buildSectionHeader('Account', themeProv),
              const SizedBox(height: 12),
              _buildAccountSettings(context, themeProv),
              const SizedBox(height: 24),

              // About Section
              _buildSectionHeader('About', themeProv),
              const SizedBox(height: 12),
              _buildAboutSettings(context, themeProv),
              const SizedBox(height: 24),

              // Logout Button
              // _buildLogoutButton(context, authProvider),
              const SizedBox(height: 32),

              // Version Info
              _buildVersionInfo(themeProv),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, ThemeProvider themeProv) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: themeProv.isDarkMode
              ? AppColors.textPrimaryDark
              : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget buildProfileCard(BuildContext context, Map<String, dynamic>? user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              child: Text(
                user?['name']?.substring(0, 1).toUpperCase() ?? 'S',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?['name'] ?? 'User Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?['email'] ?? 'email@example.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user?['role'] ?? 'Admin',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                HapticFeedback.lightImpact();
                // TODO: Navigate to edit profile
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Edit profile feature coming soon'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, ThemeProvider themeProv) {
    return Card(
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      child: Column(
        children: [
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                themeProv.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Dark Mode',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              themeProv.isDarkMode ? 'Enabled' : 'Disabled',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            value: themeProv.isDarkMode,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              themeProv.toggleTheme();
            },
          ),
          Divider(
            height: 1,
            color: themeProv.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.language,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Language',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'English',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: themeProv.isDarkMode
                  ? AppColors.iconDark
                  : AppColors.iconColor,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              _showLanguageDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(
    BuildContext context,
    ThemeProvider themeProv,
  ) {
    return Card(
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      child: Column(
        children: [
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Push Notifications',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Receive push notifications',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            value: true,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              // TODO: Toggle push notifications
            },
          ),
          Divider(
            height: 1,
            color: themeProv.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.email_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Email Notifications',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Receive email updates',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            value: true,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              // TODO: Toggle email notifications
            },
          ),
          Divider(
            height: 1,
            color: themeProv.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.vibration,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Haptic Feedback',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Vibrate on interactions',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            value: true,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              // TODO: Toggle haptic feedback
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context, ThemeProvider themeProv) {
    return Card(
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lock_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Change Password',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Update your password',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: themeProv.isDarkMode
                  ? AppColors.iconDark
                  : AppColors.iconColor,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              _showChangePasswordDialog(context);
            },
          ),
          Divider(
            height: 1,
            color: themeProv.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.security,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Privacy & Security',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Manage your privacy settings',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: themeProv.isDarkMode
                  ? AppColors.iconDark
                  : AppColors.iconColor,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Navigate to privacy settings
            },
          ),
          Divider(
            height: 1,
            color: themeProv.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.storage,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Storage & Data',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Manage app storage',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: themeProv.isDarkMode
                  ? AppColors.iconDark
                  : AppColors.iconColor,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              _showStorageDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings(BuildContext context, ThemeProvider themeProv) {
    return Card(
      color: themeProv.isDarkMode ? AppColors.cardDark : AppColors.cardColor,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.help_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Help & Support',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Get help and contact us',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: themeProv.isDarkMode
                  ? AppColors.iconDark
                  : AppColors.iconColor,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Navigate to help
            },
          ),
          Divider(
            height: 1,
            color: themeProv.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.description_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Terms & Conditions',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Read our terms',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: themeProv.isDarkMode
                  ? AppColors.iconDark
                  : AppColors.iconColor,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Show terms
            },
          ),
          Divider(
            height: 1,
            color: themeProv.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.policy_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Privacy Policy',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Read our privacy policy',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: themeProv.isDarkMode
                  ? AppColors.iconDark
                  : AppColors.iconColor,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Show privacy policy
            },
          ),
          Divider(
            height: 1,
            color: themeProv.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.share,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Share App',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Share with friends',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: themeProv.isDarkMode
                  ? AppColors.iconDark
                  : AppColors.iconColor,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Share app
            },
          ),
          Divider(
            height: 1,
            color: themeProv.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(
                  alpha: themeProv.isDarkMode ? 0.3 : 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.star_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              'Rate App',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProv.isDarkMode
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Rate us on the store',
              style: TextStyle(
                fontSize: 13,
                color: themeProv.isDarkMode
                    ? AppColors.textHint
                    : AppColors.textHintDark,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: themeProv.isDarkMode
                  ? AppColors.iconDark
                  : AppColors.iconColor,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Open store rating
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 54,
  //     child: ElevatedButton.icon(
  //       onPressed: () {
  //         HapticFeedback.mediumImpact();
  //         _showLogoutDialog(context, authProvider);
  //       },
  //       icon: const Icon(Icons.logout),
  //       label: const Text(
  //         'Logout',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.red,
  //         foregroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildVersionInfo(ThemeProvider themeProv) {
    return Center(
      child: Column(
        children: [
          Text(
            'Skillers Zone',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: themeProv.isDarkMode
                  ? AppColors.textHint
                  : AppColors.textHintDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: themeProv.isDarkMode
                  ? AppColors.textHint
                  : AppColors.textHintDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2025 Skillers Zone LLC',
            style: TextStyle(
              fontSize: 11,
              color: themeProv.isDarkMode
                  ? AppColors.textHint
                  : AppColors.textHintDark,
            ),
          ),
        ],
      ),
    );
  }

  // void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Logout'),
  //       content: const Text('Are you sure you want to logout?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             HapticFeedback.heavyImpact();
  //             authProvider.logout();
  //             Navigator.of(context).pushAndRemoveUntil(
  //               MaterialPageRoute(builder: (_) => const LoginScreen()),
  //               (route) => false,
  //             );
  //           },
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //           child: const Text('Logout'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'en',
              onChanged: (value) {
                Navigator.pop(context);
                HapticFeedback.selectionClick();
              },
            ),
            RadioListTile<String>(
              title: const Text('বাংলা'),
              value: 'bn',
              groupValue: 'en',
              onChanged: (value) {
                Navigator.pop(context);
                HapticFeedback.selectionClick();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Password changed successfully'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showStorageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage & Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStorageItem('App Cache', '24.5 MB'),
            const SizedBox(height: 12),
            _buildStorageItem('Documents', '156.2 MB'),
            const SizedBox(height: 12),
            _buildStorageItem('Images', '89.7 MB'),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _buildStorageItem('Total Storage', '270.4 MB', isBold: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cache cleared successfully'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(String label, String size, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          size,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
