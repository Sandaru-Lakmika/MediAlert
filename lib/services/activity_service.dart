import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineActivity {
  final String id;
  final String medicineName;
  final String medicineForm;
  final String action; // 'taken' or 'missed'
  final DateTime timestamp;

  MedicineActivity({
    required this.id,
    required this.medicineName,
    required this.medicineForm,
    required this.action,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'medicineForm': medicineForm,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MedicineActivity.fromJson(Map<String, dynamic> json) {
    return MedicineActivity(
      id: json['id'] as String,
      medicineName: json['medicineName'] as String,
      medicineForm: json['medicineForm'] as String,
      action: json['action'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()} ${(difference.inDays / 7).floor() == 1 ? 'week' : 'weeks'} ago';
    }
  }
}

class ActivityService {
  static const String _activitiesKey = 'medicine_activities';

  static Future<List<MedicineActivity>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final String? activitiesJson = prefs.getString(_activitiesKey);

    if (activitiesJson == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(activitiesJson);
    final activities = decoded
        .map((json) => MedicineActivity.fromJson(json))
        .toList();

    // Sort by timestamp, newest first
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return activities;
  }

  static Future<void> recordActivity(MedicineActivity activity) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getActivities();

    activities.add(activity);

    // Keep only last 50 activities
    if (activities.length > 50) {
      activities.removeRange(50, activities.length);
    }

    final String encoded = jsonEncode(
      activities.map((a) => a.toJson()).toList(),
    );

    await prefs.setString(_activitiesKey, encoded);
  }

  static Future<List<MedicineActivity>> getTodayActivities() async {
    final activities = await getActivities();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return activities.where((activity) {
      final activityDate = DateTime(
        activity.timestamp.year,
        activity.timestamp.month,
        activity.timestamp.day,
      );
      return activityDate.isAtSameMomentAs(today);
    }).toList();
  }

  static Future<int> getTodayTakenCount() async {
    final todayActivities = await getTodayActivities();
    return todayActivities.where((a) => a.action == 'taken').length;
  }

  static Future<int> getTodayMissedCount() async {
    final todayActivities = await getTodayActivities();
    return todayActivities.where((a) => a.action == 'missed').length;
  }
}
