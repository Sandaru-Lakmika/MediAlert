# MediAlert - Medicine Reminder App

A comprehensive Flutter-based medicine reminder application that helps users manage their medication schedules, track adherence, and maintain medicine stock levels.

[![Flutter](https://img.shields.io/badge/Flutter-3.9.0-02569B?style=flat&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.0-0175C2?style=flat&logo=dart)](https://dart.dev)

---

## Overview

MediAlert is an offline-first, privacy-focused mobile application designed to help users never miss their medication. Built with Flutter, it provides intelligent reminders, progress tracking, and stock management features to ensure consistent medication adherence.

**Key Highlights:**

- No internet required - fully offline capable
- All data stored locally on device (privacy-first)
- Smart timezone-aware notifications
- Automatic missed dose detection
- Material Design 3 with light/dark mode
- Real-time progress tracking

---

## Features

- **User Onboarding** - Multi-step personalized setup wizard
- **Medicine Management** - Add, edit, delete medications with flexible scheduling
- **Smart Notifications** - Exact-time reminders with daily auto-repeat
- **Progress Tracking** - Real-time adherence percentage with activity history
- **Stock Management** - Track quantities with low stock alerts
- **Missed Dose Detection** - Automatic tracking when app resumes
- **Settings** - User profile and preferences management

---

## Technology Stack

**Frontend:**

- Flutter 3.9.0
- Dart 3.9.0
- Material Design 3
- StatefulWidgets with lifecycle observers

**Backend/Data:**

- SharedPreferences (local persistent storage)
- JSON serialization for data models
- Service layer architecture
- No remote server required

**Key Dependencies:**

```yaml
shared_preferences: ^2.2.2 # Local data persistence
flutter_local_notifications: ^17.2.3 # Push notification system
timezone: ^0.9.4 # Timezone handling for scheduling
```

---

## Architecture

### System Architecture

```
┌─────────────────────────────────────┐
│         UI Layer (Widgets)          │
│  Pages, Dialogs, Components         │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│        Service Layer                │
│  - MedicineService                  │
│  - NotificationService              │
│  - ActivityService                  │
│  - ProgressNotifier                 │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Data Layer                  │
│  Models + SharedPreferences (JSON)  │
└─────────────────────────────────────┘
```

### Data Flow

```
User Action → Widget → Service Layer → SharedPreferences (JSON Storage)
                ↓
         NotificationService
                ↓
    OS Notification System
```

---

## Backend Implementation

### 1. Data Persistence (`medicine_service.dart`, `activity_service.dart`)

**Storage Mechanism:**

- Uses SharedPreferences for local key-value storage
- All data serialized to JSON format
- No network calls - completely offline

**Medicine Storage:**

```dart
// Save medicines as JSON array
final String encoded = jsonEncode(
  medicines.map((m) => m.toJson()).toList(),
);
await prefs.setString('medicines', encoded);
```

**Data Models:**

- `Medicine` - id, name, form, frequency, time, dosage, quantity
- `MedicineActivity` - id, medicineName, action (taken/missed), timestamp
- `UserData` - firstName, lastName, gender, birthDate, goals

### 2. Notification System (`notification_service.dart`)

**Implementation:**

- Uses `flutter_local_notifications` plugin
- Timezone-aware scheduling with `timezone` package
- Set to Asia/Colombo timezone

**Daily Scheduling:**

```dart
await notificationsPlugin.zonedSchedule(
  medicine.id.hashCode,                    // Unique notification ID
  'Time to take your medicine!',
  '${medicine.name} - ${medicine.dosage} ${medicine.form}(s)',
  scheduledTime,
  notificationDetails,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  matchDateTimeComponents: DateTimeComponents.time,  // Daily repeat
);
```

**Notification Types:**

1. **Medicine Reminders** - Scheduled at exact medicine time, repeats daily
2. **Low Stock Alerts** - Triggered when quantity < 5

**Payload System:**

- Notifications carry payload data for deep linking
- Low stock notifications navigate directly to Stock tab
- Format: `low_stock:{medicine_id}`

### 3. Missed Dose Detection (`home_page.dart`)

**Implementation:**

- Uses `WidgetsBindingObserver` to monitor app lifecycle
- Triggers on `AppLifecycleState.resumed`

**Logic:**

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    _checkMissedDoses();  // Automatic check when app resumes
  }
}
```

**Detection Process:**

1. Compare scheduled time vs current time
2. Check if medicine was taken today
3. Check if already marked as missed
4. If conditions met, auto-create "missed" activity
5. Update progress statistics

### 4. Progress Tracking (`activity_service.dart`, `progress_notifier.dart`)

**Activity Storage:**

- Each medicine action (taken/missed) stored as `MedicineActivity`
- Activities stored as JSON array in SharedPreferences
- Filtered by date for daily/weekly/monthly views

**Adherence Calculation:**

```dart
adherence = (taken_count / total_medicines) × 100
```

**Real-Time Updates:**

- Uses `ChangeNotifier` pattern via `ProgressNotifier`
- All listeners notified on activity changes
- UI updates automatically across all tabs

### 5. State Management

**Pattern:** Service layer with ChangeNotifier

**Key Services:**

- `MedicineService` - CRUD operations for medicines
- `NotificationService` - Scheduling and canceling notifications
- `ActivityService` - Recording and retrieving activities
- `ProgressNotifier` - Broadcasting progress updates

---

## Project Structure

```
lib/
├── main.dart                          # Entry point, notification setup
├── home/
│   └── home_page.dart                 # Main dashboard with tab navigation
├── models/
│   ├── medicine.dart                  # Medicine data model with JSON methods
│   └── user_data.dart                 # User data model
├── services/
│   ├── medicine_service.dart          # Medicine CRUD + persistence
│   ├── notification_service.dart      # Notification scheduling logic
│   ├── activity_service.dart          # Activity tracking + storage
│   └── progress_notifier.dart         # ChangeNotifier for real-time updates
├── features/
│   ├── welcome/                       # Onboarding flow (5 pages)
│   ├── medicine/                      # Medicine management (8 pages)
│   ├── progress/                      # Progress tracking UI
│   ├── medicine_stock/                # Stock management UI
│   └── settings/                      # Settings UI
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.9.0+
- Dart SDK 3.9.0+
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

```bash
# Clone repository
git clone https://github.com/yourusername/medialert.git
cd medialert

# Install dependencies
flutter pub get

# Run app
flutter run

# Build release APK
flutter build apk --release
```

---

## How It Works

### Adding a Medicine

**8-Step Wizard:**

1. Medicine name input
2. Form selection (Tablet/Capsule/Syrup/Injection)
3. Frequency (Daily/Weekly/Monthly)
4. Daily frequency count
5. Time picker
6. Dosage amount
7. Stock quantity
8. Review and save

**Backend Process:**

```
User Input → Medicine Model → JSON Serialization
→ SharedPreferences Storage → Notification Scheduling → UI Refresh
```

### Taking Medicine

**Flow:**

1. User taps "Take" button
2. Create `MedicineActivity` with action="taken"
3. Save to SharedPreferences
4. Decrement stock quantity
5. Update medicine record
6. Notify `ProgressNotifier`
7. UI updates across all tabs

### Notification Flow

```
App saves medicine → NotificationService.scheduleMedicineNotification()
→ Calculate next scheduled time → flutter_local_notifications
→ Android/iOS notification system → User receives notification
→ User taps → Payload processed → Navigate to relevant screen
```

---

## Special Features

1. **Lifecycle-Aware Missed Dose Detection** - Automatically tracks missed medications using app lifecycle callbacks
2. **Smart Notification Payload System** - Deep linking from notifications to specific app sections
3. **Real-Time Progress Synchronization** - ChangeNotifier pattern ensures instant updates across all screens
4. **Offline-First Architecture** - Zero network dependency, complete privacy
5. **Timezone-Aware Scheduling** - Exact-time notifications with daily auto-repeat

---

## Authors

**Team 3idiots**

- Sandaru

---

## License

This project is licensed under the MIT License.

---

**Made with Flutter**....
