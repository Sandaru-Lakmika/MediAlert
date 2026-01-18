import 'package:flutter/material.dart';
import 'medicine_time_page.dart';
import 'medicine_dosage_page.dart';
import '../../models/medicine.dart';

class MedicineRecurringCyclePage extends StatefulWidget {
  final String medicineName;
  final String medicineForm;
  final String frequency;
  final Medicine? existingMedicine;

  const MedicineRecurringCyclePage({
    super.key,
    required this.medicineName,
    required this.medicineForm,
    required this.frequency,
    this.existingMedicine,
  });

  @override
  State<MedicineRecurringCyclePage> createState() =>
      _MedicineRecurringCyclePageState();
}

class _MedicineRecurringCyclePageState
    extends State<MedicineRecurringCyclePage> {
  String? _selectedInterval;
  int _customHours = 4;

  final List<Map<String, dynamic>> _intervals = [
    {'name': 'Every 2 hours', 'hours': 2, 'icon': Icons.schedule_outlined},
    {'name': 'Every 4 hours', 'hours': 4, 'icon': Icons.schedule_outlined},
    {'name': 'Every 6 hours', 'hours': 6, 'icon': Icons.schedule_outlined},
    {'name': 'Every 8 hours', 'hours': 8, 'icon': Icons.schedule_outlined},
    {'name': 'Every 12 hours', 'hours': 12, 'icon': Icons.schedule_outlined},
    {
      'name': 'Custom interval',
      'hours': 0,
      'icon': Icons.edit_calendar_outlined,
    },
  ];

  void _handleNext() {
    if (_selectedInterval == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a time interval'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Validate custom interval
    if (_selectedInterval == 'Custom interval' && _customHours < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least 1 hour'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Determine the final interval string
    String finalInterval = _selectedInterval!;
    if (_selectedInterval == 'Custom interval') {
      finalInterval = 'Every $_customHours hours';
    }

    // Navigate directly to dosage page with default time (8:00 AM)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicineDosagePage(
          medicineName: widget.medicineName,
          medicineForm: widget.medicineForm,
          frequency: widget.frequency,
          dailyFrequency: finalInterval,
          time: const TimeOfDay(hour: 8, minute: 0),
        ),
      ),
    );
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
                            Icons.refresh,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        "How often should you take it?",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Select the time interval",
                        style: textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Interval Options
                      ..._intervals.map((interval) {
                        final isSelected =
                            _selectedInterval == interval['name'];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedInterval = interval['name'];
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? cs.primary.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? cs.primary
                                      : Colors.grey.withOpacity(0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? cs.primary.withOpacity(0.2)
                                        : Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? cs.primary.withOpacity(0.2)
                                          : cs.primaryContainer.withOpacity(
                                              0.5,
                                            ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      interval['icon'],
                                      color: isSelected
                                          ? cs.primary
                                          : cs.onSurface.withOpacity(0.6),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      interval['name'],
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? cs.primary
                                            : cs.onSurface,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: cs.primary,
                                      size: 24,
                                    )
                                  else
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Colors.grey.withOpacity(0.3),
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      // Custom Hour Picker (shown when custom interval is selected)
                      if (_selectedInterval == 'Custom interval') ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: cs.primary, width: 2),
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
                                'Select hours interval',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Example: Every 4 hours',
                                style: textTheme.bodySmall?.copyWith(
                                  color: cs.onSurface.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Decrease button
                                  IconButton(
                                    onPressed: () {
                                      if (_customHours > 1) {
                                        setState(() {
                                          _customHours--;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.remove_circle_outline,
                                      color: _customHours > 1
                                          ? cs.primary
                                          : Colors.grey,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  // Hour display
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cs.primaryContainer.withOpacity(
                                        0.3,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: cs.primary.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$_customHours',
                                          style: textTheme.displaySmall
                                              ?.copyWith(
                                                color: cs.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _customHours == 1 ? 'hour' : 'hours',
                                          style: textTheme.titleLarge?.copyWith(
                                            color: cs.onSurface.withOpacity(
                                              0.7,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  // Increase button
                                  IconButton(
                                    onPressed: () {
                                      if (_customHours < 24) {
                                        setState(() {
                                          _customHours++;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      color: _customHours < 24
                                          ? cs.primary
                                          : Colors.grey,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 60),

                      // Next Button
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
                          onPressed: _handleNext,
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
                                'Next',
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
}
