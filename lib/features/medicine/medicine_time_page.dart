import 'package:flutter/material.dart';
import 'medicine_dosage_page.dart';

class MedicineTimePage extends StatefulWidget {
  final String medicineName;
  final String medicineForm;
  final String frequency;
  final String dailyFrequency;

  const MedicineTimePage({
    super.key,
    required this.medicineName,
    required this.medicineForm,
    required this.frequency,
    required this.dailyFrequency,
  });

  @override
  State<MedicineTimePage> createState() => _MedicineTimePageState();
}

class _MedicineTimePageState extends State<MedicineTimePage> {
  TimeOfDay? _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  int _dosageAmount = 1;

  void _handleNext() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a time'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Navigate to dosage page
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => MedicineDosagePage(
          medicineName: widget.medicineName,
          medicineForm: widget.medicineForm,
          frequency: widget.frequency,
          dailyFrequency: widget.dailyFrequency,
          time: _selectedTime!,
        ),
      ),
    );

    // Update dosage if returned from dosage page
    if (result != null) {
      setState(() {
        _dosageAmount = result;
      });
    }
  }

  void _selectTime(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.primary,
      body: SafeArea(
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
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Text(
                    widget.medicineName,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the row
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
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
                            color: cs.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.access_time,
                            size: 56,
                            color: cs.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        "When do you need to take the dose?",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Time Picker Container
                      Container(
                        padding: const EdgeInsets.all(32),
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
                          children: [
                            // Dosage info section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Take',
                                  style: textTheme.titleMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: () async {
                                    // Navigate to dosage page
                                    final result = await Navigator.push<int>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MedicineDosagePage(
                                          medicineName: widget.medicineName,
                                          medicineForm: widget.medicineForm,
                                          frequency: widget.frequency,
                                          dailyFrequency: widget.dailyFrequency,
                                          time: _selectedTime!,
                                        ),
                                      ),
                                    );
                                    if (result != null) {
                                      setState(() {
                                        _dosageAmount = result;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '$_dosageAmount Pill(s)',
                                          style: textTheme.titleMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                          color: cs.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),

                            // Time Display
                            _buildTimeWheel(),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeWheel() {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _selectedTime ?? TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: cs.surface,
                  hourMinuteTextColor: cs.primary,
                  dayPeriodTextColor: cs.primary,
                  dialHandColor: cs.primary,
                  dialBackgroundColor: cs.primaryContainer,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          _selectTime(picked);
        }
      },
      child: Column(
        children: [
          // Hour and Minute Display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeUnit(
                _selectedTime!.hour.toString().padLeft(2, '0'),
              ),
              Text(
                ':',
                style: textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTimeUnit(
                _selectedTime!.minute.toString().padLeft(2, '0'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: textTheme.displayMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
