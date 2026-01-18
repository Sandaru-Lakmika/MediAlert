import 'package:flutter/material.dart';
import '../../models/user_data.dart';
import 'edit_profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final userData = UserData();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.surface, cs.primary.withOpacity(0.05)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.settings, color: cs.primary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Settings',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Profile Section
                    _buildSectionHeader('Profile', cs, textTheme),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      cs: cs,
                      textTheme: textTheme,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.account_circle_outlined,
                      title: 'Account',
                      subtitle:
                          '${userData.firstName ?? 'User'} ${userData.lastName ?? ''}',
                      cs: cs,
                      textTheme: textTheme,
                      onTap: () {
                        // TODO: Account details
                      },
                    ),

                    const SizedBox(height: 24),

                    // Notifications Section
                    _buildSectionHeader('Notifications', cs, textTheme),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.notifications_outlined,
                      title: 'Notification Settings',
                      subtitle: 'Manage your alert preferences',
                      cs: cs,
                      textTheme: textTheme,
                      onTap: () {
                        // TODO: Notification settings
                      },
                    ),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.alarm_outlined,
                      title: 'Reminder Schedule',
                      subtitle: 'Configure reminder timings',
                      cs: cs,
                      textTheme: textTheme,
                      onTap: () {
                        // TODO: Reminder settings
                      },
                    ),

                    const SizedBox(height: 24),

                    // App Section
                    _buildSectionHeader('App', cs, textTheme),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.palette_outlined,
                      title: 'Theme',
                      subtitle: 'Light, Dark, or System',
                      cs: cs,
                      textTheme: textTheme,
                      onTap: () {
                        // TODO: Theme settings
                      },
                    ),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: 'English',
                      cs: cs,
                      textTheme: textTheme,
                      onTap: () {
                        // TODO: Language settings
                      },
                    ),

                    const SizedBox(height: 24),

                    // Support Section
                    _buildSectionHeader('Support', cs, textTheme),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get assistance',
                      cs: cs,
                      textTheme: textTheme,
                      onTap: () {
                        // TODO: Help
                      },
                    ),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'App version and information',
                      cs: cs,
                      textTheme: textTheme,
                      onTap: () {
                        _showAboutDialog(context, cs, textTheme);
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    ColorScheme cs,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        title,
        style: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: cs.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme cs,
    required TextTheme textTheme,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: cs.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: cs.onSurface.withOpacity(0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(
    BuildContext context,
    ColorScheme cs,
    TextTheme textTheme,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.medication, color: cs.primary, size: 28),
            const SizedBox(width: 12),
            Text(
              'MediAlert',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your personal medication reminder assistant. Never miss a dose again!',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '© 2026 MediAlert Team',
              style: textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: cs.primary)),
          ),
        ],
      ),
    );
  }
}
