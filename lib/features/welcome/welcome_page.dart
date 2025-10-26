import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primaryContainer.withOpacity(0.65),
              cs.primary.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Brand row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.onPrimary.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: cs.onPrimary.withOpacity(0.15),
                        ),
                      ),
                      child: Icon(
                        Icons.medication_liquid,
                        color: cs.onPrimary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'MediAlert',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Hero
                Align(
                  child: Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      color: cs.onPrimary.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(color: cs.onPrimary.withOpacity(0.18)),
                    ),
                    child: Icon(Icons.alarm, size: 88, color: cs.onPrimary),
                  ),
                ),
                const SizedBox(height: 28),

                // Headline & copy
                Text(
                  'Never miss a dose',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add medicines, get timely reminders, mark taken or missed, and track your progress.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: cs.onPrimary.withOpacity(0.95),
                  ),
                ),

                const Spacer(),

                // CTAs
                FilledButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/user-info'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Get started'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  child: Text(
                    'Skip for now',
                    style: TextStyle(color: cs.onPrimary),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
