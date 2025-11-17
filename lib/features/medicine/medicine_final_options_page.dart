import 'package:flutter/material.dart';

class MedicineFinalOptionsPage extends StatefulWidget {
  final String medicineName;
  final String medicineForm;
  final String frequency;
  final String dailyFrequency;
  final TimeOfDay time;
  final int dosage;

  const MedicineFinalOptionsPage({
    super.key,
    required this.medicineName,
    required this.medicineForm,
    required this.frequency,
    required this.dailyFrequency,
    required this.time,
    required this.dosage,
  });

  @override
  State<MedicineFinalOptionsPage> createState() =>
      _MedicineFinalOptionsPageState();
}

class _MedicineFinalOptionsPageState extends State<MedicineFinalOptionsPage> {
  final List<Map<String, dynamic>> _options = [
    {
      'title': 'Set treatment duration?',
      'icon': Icons.event_outlined,
      'selected': false
    },
    {
      'title': 'Get refill reminders?',
      'icon': Icons.notifications_active_outlined,
      'selected': false
    },
    {
      'title': 'Add instructions?',
      'icon': Icons.info_outline,
      'selected': false
    },
    {
      'title': 'Change the med icon?',
      'icon': Icons.edit_outlined,
      'selected': false
    },
  ];

  void _handleSave() {
    // TODO: Save medicine data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.medicineName} saved successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Navigate back to home
    Navigator.of(context).popUntil((route) => route.isFirst);
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      widget.medicineName,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(width: 40), // Balance the row
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
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
                            Icons.medication_outlined,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        widget.medicineName,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Options Container
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Almost done. Would you like to:',
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Options List
                            ..._options.map((option) {
                              return Column(
                                children: [
                                  _buildOptionItem(
                                    title: option['title'],
                                    icon: option['icon'],
                                  ),
                                  if (_options.indexOf(option) !=
                                      _options.length - 1)
                                    Divider(
                                      color: Colors.white.withOpacity(0.1),
                                      height: 32,
                                    ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Save Button
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
                          onPressed: _handleSave,
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
                                'Save',
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check,
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

  Widget _buildOptionItem({
    required String title,
    required IconData icon,
  }) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        // Handle option tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title feature coming soon!'),
            backgroundColor: cs.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: cs.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
