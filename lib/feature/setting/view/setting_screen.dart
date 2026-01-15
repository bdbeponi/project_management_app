import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final authProvider = Provider.of<AuthProvider>(context);
    // final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Profile Card
          // _buildProfileCard(context, user),
          const SizedBox(height: 24),

          // Appearance Section
          _buildSectionHeader('Appearance'),
          const SizedBox(height: 12),
          _buildThemeCard(context, themeProvider),
          const SizedBox(height: 24),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          const SizedBox(height: 12),
          _buildNotificationSettings(context),
          const SizedBox(height: 24),

          // Account Section
          _buildSectionHeader('Account'),
          const SizedBox(height: 12),
          _buildAccountSettings(context),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader('About'),
          const SizedBox(height: 12),
          _buildAboutSettings(context),
          const SizedBox(height: 24),

          // Logout Button
          // _buildLogoutButton(context, authProvider),
          const SizedBox(height: 32),

          // Version Info
          _buildVersionInfo(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
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

  Widget _buildThemeCard(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              themeProvider.isDarkMode ? 'Enabled' : 'Disabled',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              themeProvider.toggleTheme();
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.language,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Language',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'English',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              HapticFeedback.lightImpact();
              _showLanguageDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Push Notifications',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Receive push notifications',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            value: true,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              // TODO: Toggle push notifications
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.email_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Email Notifications',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Receive email updates',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            value: true,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              // TODO: Toggle email notifications
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.vibration,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Haptic Feedback',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Vibrate on interactions',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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

  Widget _buildAccountSettings(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lock_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Change Password',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Update your password',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              HapticFeedback.lightImpact();
              _showChangePasswordDialog(context);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.security,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Privacy & Security',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Manage your privacy settings',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Navigate to privacy settings
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.storage,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Storage & Data',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Manage app storage',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              HapticFeedback.lightImpact();
              _showStorageDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.help_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Help & Support',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Get help and contact us',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Navigate to help
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.description_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Terms & Conditions',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Read our terms',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Show terms
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.policy_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Read our privacy policy',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Show privacy policy
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.share,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Share App',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Share with friends',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Share app
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.star_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            title: const Text(
              'Rate App',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Rate us on the store',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.chevron_right),
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

  Widget _buildVersionInfo() {
    return Center(
      child: Column(
        children: [
          Text(
            'Skillers Zone',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2025 Skillers Zone LLC',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
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
