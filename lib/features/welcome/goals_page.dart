import 'package:flutter/material.dart';
import '../../models/user_data.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final Set<String> _selectedGoals = {};

  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Get medication reminders',
      'icon': Icons.notifications_active_outlined,
    },
    {
      'title': 'Track whether I took my meds',
      'icon': Icons.check_circle_outline,
    },
    {'title': 'Keep a list of my meds', 'icon': Icons.list_alt_outlined},
    {
      'title': "Remember when it's time to refill",
      'icon': Icons.autorenew_outlined,
    },
    {
      'title': 'Check for drug interaction',
      'icon': Icons.warning_amber_outlined,
    },
  ];

  void _handleDone() {
    if (_selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one goal'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    // Save selected goals
    final userData = UserData();
    userData.goals = _selectedGoals.toList();
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
      } else {
        _selectedGoals.add(goal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primaryContainer.withOpacity(0.3),
              cs.primary.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: cs.primary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // Icon Container
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [cs.primary, cs.primary.withOpacity(0.8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: cs.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.question_answer_outlined,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        "What do you hope to achieve with MediAlert?",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: cs.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'You can choose more than one.',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Goals List
                      ...List.generate(_goals.length, (index) {
                        final goal = _goals[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildGoalOption(
                            title: goal['title'],
                            icon: goal['icon'],
                          ),
                        );
                      }),

                      const SizedBox(height: 40),

                      // Done Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: FilledButton(
                          onPressed: _handleDone,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: cs.primary,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Done',
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalOption({required String title, required IconData icon}) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = _selectedGoals.contains(title);

    return GestureDetector(
      onTap: () => _toggleGoal(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? cs.primary.withOpacity(0.12)
                  : cs.primary.withOpacity(0.04),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? cs.primary.withOpacity(0.15)
                      : cs.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? cs.primary
                      : cs.onSurface.withOpacity(0.6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? cs.onSurface
                        : cs.onSurface.withOpacity(0.8),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Check Icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? cs.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? cs.primary
                        : cs.outline.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
