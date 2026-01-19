import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/medicine.dart';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Colombo')); // Set your timezone

    // Android initialization
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    _initialized = true;
  }

  static void Function(String?)? onNotificationTapped;

  Future<void> _onNotificationTap(NotificationResponse response) async {
    // This will be called when user taps on the notification
    if (response.payload != null) {
      print('Notification tapped with payload: ${response.payload}');
      // Call the registered callback
      onNotificationTapped?.call(response.payload);
    }
  }

  Future<void> scheduleMedicineNotification(Medicine medicine) async {
    await initialize();

    // Cancel existing notification for this medicine
    await cancelNotification(medicine.id.hashCode);

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      medicine.time.hour,
      medicine.time.minute,
    );

    // If the scheduled time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledTZ = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    await _notificationsPlugin.zonedSchedule(
      medicine.id.hashCode, // Notification ID
      'Time to take your medicine! 💊',
      '${medicine.name} - ${medicine.dosage} ${medicine.form}(s)',
      scheduledTZ,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_reminders',
          'Medicine Reminders',
          channelDescription: 'Notifications for medicine reminders',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF2196F3),
          playSound: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Daily repeat
      payload: medicine.id, // Pass medicine ID for handling tap
    );
  }

  Future<void> cancelNotification(int notificationId) async {
    await _notificationsPlugin.cancel(notificationId);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> scheduleAllMedicineNotifications(
    List<Medicine> medicines,
  ) async {
    for (final medicine in medicines) {
      await scheduleMedicineNotification(medicine);
    }
  }

  // Show immediate notification for testing
  Future<void> showImmediateNotification(Medicine medicine) async {
    await initialize();

    await _notificationsPlugin.show(
      medicine.id.hashCode,
      'Time to take your medicine! 💊',
      '${medicine.name} - ${medicine.dosage} ${medicine.form}(s)',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_reminders',
          'Medicine Reminders',
          channelDescription: 'Notifications for medicine reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF2196F3),
          playSound: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: medicine.id,
    );
  }

  // Show low stock notification
  Future<void> showLowStockNotification(Medicine medicine) async {
    await initialize();

    await _notificationsPlugin.show(
      medicine.id.hashCode + 1000, // Different ID for low stock notifications
      '⚠️ Low Stock Alert',
      '${medicine.name} is running low! Only ${medicine.quantity} ${medicine.form}(s) remaining',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'low_stock_alerts',
          'Low Stock Alerts',
          channelDescription: 'Notifications for low medicine stock',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFFFA726),
          playSound: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload:
          'low_stock:${medicine.id}', // Special payload for stock navigation
    );
  }
}
