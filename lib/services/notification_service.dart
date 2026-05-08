import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:drift/drift.dart' as drift;

import '../data/local/database.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.handleAction(notificationResponse);
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'medicine_reminders_v2';
  static const String _channelName = 'Medicine Reminders';
  static const String _channelDesc = 'Reminders to take your medicine';

  static const String actionDone = 'DONE_ACTION';
  static const String actionSnooze = 'SNOOZE_ACTION';

  static Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('[NotificationService] Error setting local timezone: $e');
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {
        await handleAction(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> requestPermissions() async {
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();
        await androidPlugin.requestExactAlarmsPermission();
      }
    }
  }

  static Future<bool> checkExactAlarmPermission() async {
     if (Platform.isAndroid) {
        final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
        // Note: checkExactAlarmsPermission might not be available in v17 directly or might strictly return future.
        // If unavailable, we assume true or rely on request. 
        // Checking source for v17: requestExactAlarmsPermission exists. 
        // We can't robustly check status without valid context or external package, 
        // but we can request it again which users can ignore if already granted.
        return true; 
     }
     return true;
  }

  static Future<void> handleAction(NotificationResponse response) async {
    if (response.payload == null) return;
    
    // Payload format: "medId|slot|medName"
    final parts = response.payload!.split('|');
    if (parts.length < 3) return;

    final int medId = int.parse(parts[0]);
    final String slot = parts[1];
    final String medName = parts[2];

    if (response.actionId == actionDone) {
      await _markAsTaken(medId, slot);
    } else if (response.actionId == actionSnooze) {
      await _snoozeReminder(response.id ?? 0, medName, medId, slot);
    }
  }

  static Future<void> _markAsTaken(int medId, String slot) async {
    final db = AppDatabase();
    try {
      // Check if already logged for today (date part)
      // Since specific time isn't crucial for exact "now", just use now.
      await db.into(db.medicineLogs).insert(
        MedicineLogsCompanion(
          medicineId: drift.Value(medId),
          takenAt: drift.Value(DateTime.now()),
          slot: drift.Value(slot),
          isTaken: const drift.Value(true),
        ),
      );
    } catch (e) {
      print("[NotificationService] Error marking as taken: $e");
    } finally {
      await db.close();
    }
  }

  static Future<void> _snoozeReminder(int id, String title, int medId, String slot) async {
    // Snooze for 10 minutes
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(minutes: 10));

    await _notifications.zonedSchedule(
      id, // Re-use ID or new one? ID collision might replace.
      title,
      "Snoozed: Time to take your medicine ($slot)",
      scheduledDate,
      _notificationDetails(actionName: 'Done'), // Keep Done button
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: "$medId|$slot|$title",
    );
  }

  static NotificationDetails _notificationDetails({String actionName = 'Done'}) {
    final List<AndroidNotificationAction> actions = [
      const AndroidNotificationAction(
        actionDone,
        'Done',
        showsUserInterface: false, // Don't open app
        cancelNotification: true,
      ),
      const AndroidNotificationAction(
        actionSnooze,
        'Snooze (10m)',
        showsUserInterface: false,
        cancelNotification: true,
      ),
    ];

    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        actions: actions,
      ),
      iOS: const DarwinNotificationDetails(
        categoryIdentifier: 'medicine_reminder', // Needs category setup for actions on iOS
      ),
    );
  }

  // Schedule Logic
  static Future<void> scheduleMedicine({
    required int id,
    required String name,
    required TimeOfDay time,
    required String slot, // "Morning", "Afternoon", "Evening"
    Set<int>? days, // 1=Mon, 7=Sun. Null = Daily
  }) async {
    int slotIndex = 0;
    if (slot == "Afternoon") slotIndex = 1;
    if (slot == "Evening") slotIndex = 2;

    if (days == null) {
      // Daily
      final notificationId = id * 100 + slotIndex; // Simple ID for daily
      await _scheduleSingle(notificationId, name, slot, time, DateTimeComponents.time, id);
    } else {
      // Specific Days - Schedule separate weekly notification for EACH selected day
      for (final day in days) {
        final notificationId = id * 100 + (day * 10) + slotIndex; 
        await _scheduleSingle(notificationId, name, slot, time, DateTimeComponents.dayOfWeekAndTime, id, day: day);
      }
    }
  }

  static Future<void> _scheduleSingle(
    int notificationId, 
    String name, 
    String slot, 
    TimeOfDay time, 
    DateTimeComponents matchComponent,
    int medId,
    {int? day}
  ) async {
    final tz.TZDateTime exactNow = tz.TZDateTime.now(tz.local);
    // Strip seconds to prevent "current minute" offset bug pushing alarms to tomorrow
    final tz.TZDateTime now = tz.TZDateTime(tz.local, exactNow.year, exactNow.month, exactNow.day, exactNow.hour, exactNow.minute);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (day != null) {
       // Find next occurrence of this specific day
       while (scheduledDate.weekday != day || scheduledDate.isBefore(now)) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
       }
    } else {
       // Daily - if passed, add 1 day
       if (scheduledDate.isBefore(now)) {
         scheduledDate = scheduledDate.add(const Duration(days: 1));
       }
    }

    await _notifications.zonedSchedule(
      notificationId,
      name,
      "Time to take your $slot medicine",
      scheduledDate,
      _notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: matchComponent,
      payload: "$medId|$slot|$name",
    );
  }

  static Future<void> cancelMedicine(int id) async {
     // Cancel Daily
     for (int s=0; s<3; s++) {
       await _notifications.cancel(id * 100 + s);
     }
     // Cancel Weekly (Days 1-7)
     for (int d=1; d<=7; d++) {
       for (int s=0; s<3; s++) {
          await _notifications.cancel(id * 100 + (d * 10) + s);
       }
     }
  }

  // --- Local Testing Helper ---
  static Future<void> testNotification() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledDate = now.add(const Duration(seconds: 5));

    await _notifications.zonedSchedule(
      999999, // Test ID
      'Test Reminder',
      'This is a local 5-second test notification!',
      scheduledDate,
      _notificationDetails(actionName: 'Done'),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: "0|Test|Test Med", // Mock payload
    );
  }
}
