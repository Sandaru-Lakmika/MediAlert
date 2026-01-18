import 'package:flutter/material.dart';
import 'medicine_dosage_page.dart';
import 'medicine_final_options_page.dart';
import '../../models/medicine.dart';

class MedicineTimePage extends StatefulWidget {
  final String medicineName;
  final String medicineForm;
  final String frequency;
  final String dailyFrequency;
  final Medicine? existingMedicine;

  const MedicineTimePage({
    super.key,
    required this.medicineName,
    required this.medicineForm,
    required this.frequency,
    required this.dailyFrequency,
    this.existingMedicine,
  });

  @override
  State<MedicineTimePage> createState() => _MedicineTimePageState();
}

class _MedicineTimePageState extends State<MedicineTimePage> {
  late List<TimeOfDay?> _selectedTimes;
  late List<int> _dosageAmounts;

  @override
  void initState() {
    super.initState();
    _initializeTimeSlots();
  }

  void _initializeTimeSlots() {
    int numSlots = _getNumberOfTimeSlots();
    _selectedTimes = List.generate(
      numSlots,
      (index) => TimeOfDay(hour: 8 + (index * 4), minute: 0),
    );
    _dosageAmounts = List.generate(numSlots, (index) => 1);
  }

  int _getNumberOfTimeSlots() {
    switch (widget.dailyFrequency) {
      case 'Once a day':
        return 1;
      case 'Twice a day':
        return 2;
      case '3 times a day':
        return 3;
      case 'More than 3 times a day':
        return 3;
      default:
        return 1;
    }
  }

  bool _canAddMoreDoses() {
    return widget.dailyFrequency == 'More than 3 times a day';
  }

  void _addNewDoseSlot() {
    setState(() {
      int nextHour = 8 + (_selectedTimes.length * 3);
      if (nextHour > 23) nextHour = 20;
      _selectedTimes.add(TimeOfDay(hour: nextHour, minute: 0));
      _dosageAmounts.add(1);
    });
  }

  void _handleNext() async {
    if (_selectedTimes.any((time) => time == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select all time slots'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Navigate to final options page with first time
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicineFinalOptionsPage(
          medicineName: widget.medicineName,
          medicineForm: widget.medicineForm,
          frequency: widget.frequency,
          dailyFrequency: widget.dailyFrequency,
          time: _selectedTimes.first!,
          dosage: _dosageAmounts.first,
          existingMedicine: widget.existingMedicine,
        ),
      ),
    );
  }

  void _selectTime(int index, TimeOfDay time) {
    setState(() {
      _selectedTimes[index] = time;
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
                            Icons.access_time,
                            size: 56,
                            color: Colors.white,
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

                      // Time Slots - Dynamic based on daily frequency
                      ..._buildTimeSlots(),

                      // Add Dose Button (only for "More than 3 times a day")
                      if (_canAddMoreDoses()) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: _addNewDoseSlot,
                            icon: Icon(Icons.add, color: cs.primary),
                            label: Text(
                              'Add Another Dose',
                              style: textTheme.titleMedium?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              side: BorderSide(color: cs.primary, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
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

  List<Widget> _buildTimeSlots() {
    final cs = Theme.of(context).colorScheme;

    return List.generate(_selectedTimes.length, (index) {
      String timeLabel = _getTimeLabel(index);

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push<int>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicineDosagePage(
                            medicineName: widget.medicineName,
                            medicineForm: widget.medicineForm,
                            frequency: widget.frequency,
                            dailyFrequency: widget.dailyFrequency,
                            time: _selectedTimes[index]!,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _dosageAmounts[index] = result;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Take',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_dosageAmounts[index]} Pill(s)',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: cs.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTimeWheel(index),
            ],
          ),
        ),
      );
    });
  }

  String _getTimeLabel(int index) {
    final labels = ['First', 'Second', 'Third', 'Fourth'];
    if (index < labels.length) {
      return '${labels[index]} dose';
    }
    return 'Dose ${index + 1}';
  }

  Widget _buildTimeWheel(int index) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _selectedTimes[index] ?? TimeOfDay.now(),
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
          _selectTime(index, picked);
        }
      },
      child: Column(
        children: [
          // Hour and Minute Display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeUnit(
                _selectedTimes[index]!.hour.toString().padLeft(2, '0'),
              ),
              Text(
                ':',
                style: textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTimeUnit(
                _selectedTimes[index]!.minute.toString().padLeft(2, '0'),
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
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
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
