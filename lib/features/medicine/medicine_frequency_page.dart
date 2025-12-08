import 'package:flutter/material.dart';
import 'medicine_daily_frequency_page.dart';
import '../../models/medicine.dart';

class MedicineFrequencyPage extends StatefulWidget {
  final String medicineName;
  final String medicineForm;
  final Medicine? existingMedicine;

  const MedicineFrequencyPage({
    super.key,
    required this.medicineName,
    required this.medicineForm,
    this.existingMedicine,
  });

  @override
  State<MedicineFrequencyPage> createState() => _MedicineFrequencyPageState();
}

class _MedicineFrequencyPageState extends State<MedicineFrequencyPage> {
  String? _selectedFrequency;
  List<String> _selectedDays = [];
  List<String> _selectedEveryOtherDayDays = [];
  List<int> _selectedDaysOfMonth = [];
  List<int> _selectedWeeksOfMonth = [];
  List<String> _selectedMonthsOfYear = [];

  final List<Map<String, dynamic>> _frequencies = [
    {'name': 'Every day', 'icon': Icons.today_outlined, 'needsDialog': false},
    {
      'name': 'Every other day',
      'icon': Icons.calendar_today_outlined,
      'needsDialog': true,
      'dialogType': 'everyOtherDay',
    },
    {
      'name': 'Specific days of the week',
      'icon': Icons.date_range_outlined,
      'needsDialog': true,
      'dialogType': 'weekDays',
    },
    {
      'name': 'On a recurring cycle',
      'icon': Icons.refresh_outlined,
      'needsDialog': false,
    },
    {
      'name': 'Every X days',
      'icon': Icons.calendar_view_day_outlined,
      'needsDialog': true,
      'dialogType': 'daysOfMonth',
    },
    {
      'name': 'Every X weeks',
      'icon': Icons.calendar_view_week_outlined,
      'needsDialog': true,
      'dialogType': 'weeksOfMonth',
    },
    {
      'name': 'Every X months',
      'icon': Icons.calendar_view_month_outlined,
      'needsDialog': true,
      'dialogType': 'monthsOfYear',
    },
  ];

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  void _handleFrequencySelection(Map<String, dynamic> frequency) async {
    setState(() {
      _selectedFrequency = frequency['name'];
    });

    if (frequency['needsDialog'] == true) {
      switch (frequency['dialogType']) {
        case 'everyOtherDay':
          await _showEveryOtherDayDialog();
          break;
        case 'weekDays':
          await _showWeekDaysDialog();
          break;
        case 'daysOfMonth':
          await _showDaysOfMonthDialog();
          break;
        case 'weeksOfMonth':
          await _showWeeksOfMonthDialog();
          break;
        case 'monthsOfYear':
          await _showMonthsOfYearDialog();
          break;
      }
    }
  }

  Future<void> _showEveryOtherDayDialog() async {
    final List<String> tempSelected = List.from(_selectedEveryOtherDayDays);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Select Starting Days',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _weekDays.map((day) {
                    final isSelected = tempSelected.contains(day);
                    return CheckboxListTile(
                      title: Text(day),
                      value: isSelected,
                      activeColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelected.add(day);
                          } else {
                            tempSelected.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _selectedEveryOtherDayDays = tempSelected;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showWeekDaysDialog() async {
    final List<String> tempSelected = List.from(_selectedDays);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Select Days',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _weekDays.map((day) {
                    final isSelected = tempSelected.contains(day);
                    return CheckboxListTile(
                      title: Text(day),
                      value: isSelected,
                      activeColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelected.add(day);
                          } else {
                            tempSelected.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _selectedDays = tempSelected;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showDaysOfMonthDialog() async {
    final List<int> tempSelected = List.from(_selectedDaysOfMonth);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Select Days of Month',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 31,
                  itemBuilder: (context, index) {
                    final day = index + 1;
                    final isSelected = tempSelected.contains(day);
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          if (isSelected) {
                            tempSelected.remove(day);
                          } else {
                            tempSelected.add(day);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : null,
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _selectedDaysOfMonth = tempSelected;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showWeeksOfMonthDialog() async {
    final List<int> tempSelected = List.from(_selectedWeeksOfMonth);
    final weekLabels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Select Weeks of Month',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(4, (index) {
                  final week = index + 1;
                  final isSelected = tempSelected.contains(week);
                  return CheckboxListTile(
                    title: Text(weekLabels[index]),
                    value: isSelected,
                    activeColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onChanged: (bool? value) {
                      setDialogState(() {
                        if (value == true) {
                          tempSelected.add(week);
                        } else {
                          tempSelected.remove(week);
                        }
                      });
                    },
                  );
                }),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _selectedWeeksOfMonth = tempSelected;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showMonthsOfYearDialog() async {
    final List<String> tempSelected = List.from(_selectedMonthsOfYear);
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Select Months of Year',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: months.map((month) {
                    final isSelected = tempSelected.contains(month);
                    return CheckboxListTile(
                      title: Text(month),
                      value: isSelected,
                      activeColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelected.add(month);
                          } else {
                            tempSelected.remove(month);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _selectedMonthsOfYear = tempSelected;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleNext() {
    if (_selectedFrequency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a frequency'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Validate specific selections
    if (_selectedFrequency == 'Specific days of the week' &&
        _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one day'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Navigate to daily frequency page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicineDailyFrequencyPage(
          medicineName: widget.medicineName,
          medicineForm: widget.medicineForm,
          frequency: _selectedFrequency!,
          existingMedicine: widget.existingMedicine,
        ),
      ),
    );
  }

  String _getFrequencyDetails(String frequency) {
    switch (frequency) {
      case 'Every other day':
        return _selectedEveryOtherDayDays.isEmpty
            ? ''
            : _selectedEveryOtherDayDays.length <= 2
            ? _selectedEveryOtherDayDays.join(', ')
            : '${_selectedEveryOtherDayDays.length} days selected';
      case 'Specific days of the week':
        return _selectedDays.isEmpty
            ? ''
            : _selectedDays.length <= 2
            ? _selectedDays.join(', ')
            : '${_selectedDays.length} days selected';
      case 'Every X days':
        return _selectedDaysOfMonth.isEmpty
            ? ''
            : _selectedDaysOfMonth.length <= 3
            ? _selectedDaysOfMonth.map((d) => d.toString()).join(', ')
            : '${_selectedDaysOfMonth.length} days selected';
      case 'Every X weeks':
        return _selectedWeeksOfMonth.isEmpty
            ? ''
            : 'Week ${_selectedWeeksOfMonth.map((w) => w.toString()).join(', ')}';
      case 'Every X months':
        return _selectedMonthsOfYear.isEmpty
            ? ''
            : _selectedMonthsOfYear.length <= 2
            ? _selectedMonthsOfYear.join(', ')
            : '${_selectedMonthsOfYear.length} months selected';
      default:
        return '';
    }
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
                    const SizedBox(width: 48), // For symmetry
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
                            Icons.event_repeat_outlined,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        "How often do you take it?",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Frequency Options
                      ...List.generate(_frequencies.length, (index) {
                        final frequency = _frequencies[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildFrequencyOption(frequency),
                        );
                      }),

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

  Widget _buildFrequencyOption(Map<String, dynamic> frequency) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = _selectedFrequency == frequency['name'];
    final details = _getFrequencyDetails(frequency['name']);

    return GestureDetector(
      onTap: () => _handleFrequencySelection(frequency),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                  frequency['icon'],
                  color: isSelected
                      ? cs.primary
                      : cs.onSurface.withOpacity(0.6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      frequency['name'],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? cs.onSurface
                            : cs.onSurface.withOpacity(0.8),
                      ),
                    ),
                    if (details.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        details,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Info icon or Check icon
              if (frequency['hasInfo'] == true)
                Icon(
                  Icons.help_outline,
                  color: cs.onSurface.withOpacity(0.4),
                  size: 20,
                )
              else
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
