import 'package:flutter/material.dart';
import '../../models/user_data.dart';

class BirthDatePage extends StatefulWidget {
  const BirthDatePage({super.key});

  @override
  State<BirthDatePage> createState() => _BirthDatePageState();
}

class _BirthDatePageState extends State<BirthDatePage> {
  DateTime? _selectedDate;

  void _handleNext() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select your date of birth'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    // Save birth date
    final userData = UserData();
    userData.birthDate = _selectedDate;
    Navigator.pushNamed(context, '/goals');
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final cs = Theme.of(context).colorScheme;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: cs.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: cs.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
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
                            Icons.cake_outlined,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        "What is your date of birth?",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Date Display Card
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedDate != null
                                  ? cs.primary
                                  : cs.outline.withOpacity(0.2),
                              width: _selectedDate != null ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedDate != null
                                    ? cs.primary.withOpacity(0.15)
                                    : cs.primary.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              if (_selectedDate == null) ...[
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 48,
                                  color: cs.primary.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tap to select your birth date',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: cs.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ] else ...[
                                // Display selected date in a nice format
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildDateBox(
                                      _selectedDate!.day.toString().padLeft(
                                        2,
                                        '0',
                                      ),
                                      'Day',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        '/',
                                        style: textTheme.headlineMedium
                                            ?.copyWith(
                                              color: cs.primary.withOpacity(
                                                0.3,
                                              ),
                                              fontWeight: FontWeight.w300,
                                            ),
                                      ),
                                    ),
                                    _buildDateBox(
                                      _getMonthName(_selectedDate!.month),
                                      'Month',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        '/',
                                        style: textTheme.headlineMedium
                                            ?.copyWith(
                                              color: cs.primary.withOpacity(
                                                0.3,
                                              ),
                                              fontWeight: FontWeight.w300,
                                            ),
                                      ),
                                    ),
                                    _buildDateBox(
                                      _selectedDate!.year.toString(),
                                      'Year',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextButton.icon(
                                  onPressed: _selectDate,
                                  icon: Icon(
                                    Icons.edit_calendar,
                                    size: 18,
                                    color: cs.primary,
                                  ),
                                  label: Text(
                                    'Change date',
                                    style: TextStyle(color: cs.primary),
                                  ),
                                ),
                              ],
                            ],
                          ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateBox(String value, String label) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
