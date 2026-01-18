import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine.dart';
import 'notification_service.dart';

class MedicineService {
  static const String _medicinesKey = 'medicines';

  static Future<List<Medicine>> getMedicines() async {
    final prefs = await SharedPreferences.getInstance();
    final String? medicinesJson = prefs.getString(_medicinesKey);

    if (medicinesJson == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(medicinesJson);
    return decoded.map((json) => Medicine.fromJson(json)).toList();
  }

  static Future<void> saveMedicine(Medicine medicine) async {
    final prefs = await SharedPreferences.getInstance();
    final medicines = await getMedicines();

    // Check if medicine already exists (for updates)
    final existingIndex = medicines.indexWhere((m) => m.id == medicine.id);
    if (existingIndex != -1) {
      medicines[existingIndex] = medicine;
    } else {
      medicines.add(medicine);
    }

    final String encoded = jsonEncode(
      medicines.map((m) => m.toJson()).toList(),
    );

    await prefs.setString(_medicinesKey, encoded);
    
    // Schedule notification for this medicine
    await NotificationService().scheduleMedicineNotification(medicine);
  }

  static Future<void> updateMedicine(Medicine medicine) async {
    await saveMedicine(medicine);
  }

  static Future<void> deleteMedicine(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final medicines = await getMedicines();
    final medicineToDelete = medicines.firstWhere((m) => m.id == id);
    medicines.removeWhere((medicine) => medicine.id == id);

    final String encoded = jsonEncode(
      medicines.map((m) => m.toJson()).toList(),
    );

    await prefs.setString(_medicinesKey, encoded);
    
    // Cancel notification for this medicine
    await NotificationService().cancelNotification(medicineToDelete.id.hashCode);
  }
}
