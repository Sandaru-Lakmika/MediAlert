import 'package:flutter/material.dart';
import '../../models/user_data.dart';
import 'edit_profile_page.dart';
import '../welcome/welcome_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final userData = UserData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        elevation: 0,
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.surface, cs.primary.withOpacity(0.05)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Card
            Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Profile Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [cs.primary, cs.primary.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(Icons.person, size: 50, color: cs.onPrimary),
                  ),
                  const SizedBox(height: 16),
                  // User Name
                  Text(
                    userData.firstName != null || userData.lastName != null
                        ? '${userData.firstName ?? ''} ${userData.lastName ?? ''}'
                              .trim()
                        : 'User',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // User Role/Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Active User',
                      style: textTheme.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Account Information Section
            _buildSectionHeader('Personal Information', cs, textTheme),
            _buildInfoCard(
              context: context,
              icon: Icons.person_outline,
              label: 'First Name',
              value: userData.firstName ?? 'Not set',
              cs: cs,
              textTheme: textTheme,
            ),
            _buildInfoCard(
              context: context,
              icon: Icons.person_outline,
              label: 'Last Name',
              value: userData.lastName ?? 'Not set',
              cs: cs,
              textTheme: textTheme,
            ),
            _buildInfoCard(
              context: context,
              icon: Icons.wc_outlined,
              label: 'Gender',
              value: userData.gender ?? 'Not set',
              cs: cs,
              textTheme: textTheme,
            ),
            _buildInfoCard(
              context: context,
              icon: Icons.cake_outlined,
              label: 'Date of Birth',
              value: userData.birthDate != null
                  ? '${userData.birthDate!.day}/${userData.birthDate!.month}/${userData.birthDate!.year}'
                  : 'Not set',
              cs: cs,
              textTheme: textTheme,
            ),

            const SizedBox(height: 24),

            // Goals Section
            if (userData.goals.isNotEmpty) ...[
              _buildSectionHeader('My Goals', cs, textTheme),
              Container(
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: userData.goals.map((goal) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: cs.primary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              goal,
                              style: textTheme.bodyMedium?.copyWith(
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Account Actions Section
            _buildSectionHeader('Account Actions', cs, textTheme),
            _buildActionButton(
              context: context,
              icon: Icons.edit_outlined,
              label: 'Edit Profile',
              color: cs.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
            ),
            _buildActionButton(
              context: context,
              icon: Icons.logout,
              label: 'Sign Out',
              color: Colors.red,
              onTap: () {
                _showSignOutDialog(context);
              },
            ),

            const SizedBox(height: 32),
          ],
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

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme cs,
    required TextTheme textTheme,
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
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
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

  void _showSignOutDialog(BuildContext context) {
    final userData = UserData();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            const SizedBox(width: 12),
            const Text('Sign Out'),
          ],
        ),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Clear user data
              userData.clear();

              // Close dialog
              Navigator.pop(context);

              // Navigate to welcome page and clear navigation stack
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomePage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
