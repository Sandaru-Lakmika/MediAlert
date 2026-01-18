import 'package:flutter/material.dart';

class Medicine {
  final String id;
  final String name;
  final String form;
  final String frequency;
  final String dailyFrequency;
  final TimeOfDay time;
  final int dosage;
  final DateTime createdAt;
  final int quantity;

  Medicine({
    required this.id,
    required this.name,
    required this.form,
    required this.frequency,
    required this.dailyFrequency,
    required this.time,
    required this.dosage,
    required this.createdAt,
    this.quantity = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'form': form,
      'frequency': frequency,
      'dailyFrequency': dailyFrequency,
      'timeHour': time.hour,
      'timeMinute': time.minute,
      'dosage': dosage,
      'createdAt': createdAt.toIso8601String(),
      'quantity': quantity,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as String,
      name: json['name'] as String,
      form: json['form'] as String,
      frequency: json['frequency'] as String,
      dailyFrequency: json['dailyFrequency'] as String,
      time: TimeOfDay(
        hour: json['timeHour'] as int,
        minute: json['timeMinute'] as int,
      ),
      dosage: json['dosage'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      quantity: json['quantity'] as int? ?? 0,
    );
  }

  String get formattedTime {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
