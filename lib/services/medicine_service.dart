import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine.dart';

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
  }

  static Future<void> deleteMedicine(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final medicines = await getMedicines();
    medicines.removeWhere((medicine) => medicine.id == id);

    final String encoded = jsonEncode(
      medicines.map((m) => m.toJson()).toList(),
    );

    await prefs.setString(_medicinesKey, encoded);
  }
}
