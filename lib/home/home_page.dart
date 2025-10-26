import 'package:flutter/material.dart';
import '../models/user_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userData = UserData();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final firstName = userData.firstName ?? 'User';

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.primary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top bar with app name and notifications
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MediAlert',
                            style: textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // TODO: Navigate to notifications
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Welcome message
                      Text(
                        'Welcome aboard, $firstName!',
                        style: textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "You've completed your MediAlert profile.\nNow, let's add your medication to create\nyour very first reminder.",
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add Medicine Card
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            cs.primary.withOpacity(0.1),
                            cs.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: cs.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 64,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No medications yet',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start by adding your first medication\nand set up reminders',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withOpacity(0.7),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Add Medicine Button
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/add-medicine');
                              },
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: cs.primary,
                              ),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: Text(
                                'Add my med',
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quick Actions Section
                    Text(
                      'Quick Actions',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick action cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            context,
                            icon: Icons.calendar_today_outlined,
                            title: 'Schedule',
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionCard(
                            context,
                            icon: Icons.history_outlined,
                            title: 'History',
                            color: const Color(0xFFFF9800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            context,
                            icon: Icons.bar_chart_outlined,
                            title: 'Progress',
                            color: const Color(0xFF9C27B0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionCard(
                            context,
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            color: const Color(0xFF607D8B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Tips Card
                    Container(
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cs.secondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: cs.onSecondary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tip of the day',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: cs.onSecondaryContainer,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Set reminders 30 minutes before meals for better medication absorption.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: cs.onSecondaryContainer.withOpacity(
                                      0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add-medicine');
        },
        backgroundColor: cs.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Medicine',
          style: textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navigate to respective pages
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
