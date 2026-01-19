# MediAlert - Medicine Reminder App

A comprehensive Flutter-based medicine reminder application that helps users manage their medication schedules, track adherence, and maintain medicine stock levels.

[![Flutter](https://img.shields.io/badge/Flutter-3.9.0-02569B?style=flat&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.0-0175C2?style=flat&logo=dart)](https://dart.dev)

---

## Application Overview

MediAlert is a comprehensive medicine reminder mobile application built with Flutter that helps users manage their medication schedules, track adherence, and maintain medicine stock levels. This is a fully offline-capable, privacy-focused application with intelligent reminders and automatic missed dose detection.

**Key Points:**

- **No Backend Server** - Fully local, privacy-focused
- **Automatic Missed Dose Detection** - Smart lifecycle management
- **Exact Time Notifications** - Timezone-aware scheduling
- **Real-Time Progress Tracking** - Live adherence monitoring
- **Stock Management** - Prevent running out of medicine
- **Beautiful UI** - Material Design 3 with custom gradients
- **Offline-Capable** - Works without internet

---

## Architecture & Technology Stack

### Frontend (Flutter)

- **Framework**: Flutter with Dart (SDK 3.9.0)
- **UI Design**: Material Design 3 with custom theming
- **State Management**: StatefulWidgets with WidgetsBindingObserver for lifecycle management
- **Navigation**: Named routes and MaterialPageRoute

### Backend/Data Layer

- **Local Storage**: SharedPreferences (persistent key-value storage)
- **Data Format**: JSON serialization/deserialization
- **No Remote Server**: Fully offline-capable application

### Key Dependencies

```yaml
shared_preferences: ^2.2.2 # Local data persistence
flutter_local_notifications: ^17.2.3 # Push notifications
timezone: ^0.9.4 # Timezone handling for notifications
```

### System Architecture

```
┌─────────────────────────────────────────────┐
│         UI Layer (Widgets)                  │
│  Pages, Dialogs, Custom Components          │
└──────────────┬──────────────────────────────┘
               │
┌──────────────▼──────────────────────────────┐
│           Service Layer                     │
│  - MedicineService                          │
│  - NotificationService                      │
│  - ActivityService                          │
│  - ProgressNotifier                         │
└──────────────┬──────────────────────────────┘
               │
┌──────────────▼──────────────────────────────┐
│           Data Layer                        │
│  Models + SharedPreferences (JSON storage)  │
└─────────────────────────────────────────────┘
```

### Data Flow

```
User Action → Widget → Service Layer → SharedPreferences (Local Storage)
                ↓
         NotificationService
                ↓
    OS Notification System
```

---

## Core Features & How They Work

### 1. Onboarding Flow

**Pages**: `welcome_page.dart` → `user_info_page.dart` → `gender_page.dart` → `birth_date_page.dart` → `goals_page.dart`

**How it works:**

- Multi-step wizard collects user information
- Data Storage: Saved to `user_data.dart` model via SharedPreferences
- UX: Smooth transitions with gradient backgrounds and animated icons

### 2. Medicine Management

**Service**: `medicine_service.dart`

**Add/Edit Medicine Flow:**

```
AddMedicinePage → FormPage → FrequencyPage → DailyFrequencyPage
→ TimePage → DosagePage → FinalOptionsPage
```

**Backend Logic:**

- Medicines stored as JSON array in SharedPreferences under key `'medicines'`
- Each medicine has unique ID (UUID-like timestamp-based)
- CRUD operations: `getMedicines()`, `saveMedicine()`, `updateMedicine()`, `deleteMedicine()`
- Automatic notification scheduling on save

**Data Model** (`medicine.dart`):

- id, name, form (Tablet/Capsule/Syrup/Injection)
- frequency (Daily/Weekly/Monthly)
- dailyFrequency, time, dosage
- quantity (for stock management)

### 3. Smart Notification System ⭐ SPECIAL FEATURE

**Service**: `notification_service.dart`

**How it works:**

- Uses `flutter_local_notifications` with timezone support
- Scheduled at exact medicine time daily using `zonedSchedule()`
- Notification ID: `medicine.id.hashCode` (for unique identification)
- **Auto-repeat**: Uses `matchDateTimeComponents.time` for daily recurrence
- **Exact timing**: `AndroidScheduleMode.exactAllowWhileIdle` for precision

**Implementation:**

```dart
await notificationsPlugin.zonedSchedule(
  medicine.id.hashCode,
  'Time to take your medicine! 💊',
  '${medicine.name} - ${medicine.dosage} ${medicine.form}(s)',
  scheduledTime,
  notificationDetails,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  matchDateTimeComponents: DateTimeComponents.time, // Daily repeat
);
```

**Two Types of Notifications:**

1. **Medicine Reminders**: 💊 "Time to take your medicine!"
2. **Low Stock Alerts**: ⚠️ "Medicine running low!" (when quantity < threshold)

**Notification Tap Handling:**

- Payload system navigates to specific screens
- Low stock payload redirects to Stock tab automatically

### 4. Progress Tracking ⭐ SPECIAL FEATURE

**Page**: `progress_page.dart`  
**Service**: `activity_service.dart`

**Features:**

- **Adherence Calculation**: `(taken / total) × 100`
- **Visual Progress**: Circular progress indicator with percentage
- **Activity Log**: Shows "taken" or "missed" status with timestamps
- **Real-time Updates**: Uses `progress_notifier.dart` (ChangeNotifier pattern)

**Backend Logic:**

- Activities stored as JSON array with medicine name, action, timestamp
- Filters by date for daily/weekly/monthly views
- Auto-marks medicines as "missed" if scheduled time passes without action

### 5. Missed Dose Detection ⭐ SPECIAL FEATURE

**Location**: `home_page.dart` (lines 59-97)

**How it works:**

- Uses `WidgetsBindingObserver` to detect app state changes
- Triggers on `AppLifecycleState.resumed`
- Compares scheduled time vs current time
- Auto-creates "missed" activity if not taken

**Implementation:**

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    _checkMissedDoses();  // Check for missed doses when app comes to foreground
    _loadMedicines();
  }
}
```

**Detection Process:**

1. Check if scheduled time has passed
2. Verify if medicine was taken today
3. Verify if not already marked as missed
4. If not taken and not already marked as missed, mark as missed

### 6. Medicine Stock Management

**Page**: `medicine_stock_page.dart`

**Features:**

- Visual stock levels with color-coded status
- Quick quantity update dialog
- Low stock warnings (< 5 items)
- Stock reduction on "Take" action

### 7. Home Dashboard

**Page**: `home_page.dart`

**Features:**

- Personalized greeting with user's name
- Today's medication list with status
- Quick actions: Take, Snooze, Skip
- Empty state with encouraging message
- Real-time updates when returning from background

---

## Backend Implementation Details

### 1. Data Persistence

**Implementation**: `medicine_service.dart`, `activity_service.dart`

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

### 2. Notification Scheduling

**Implementation**: `notification_service.dart`

- Uses `flutter_local_notifications` plugin
- Timezone-aware scheduling with `timezone` package
- Set to Asia/Colombo timezone
- Notification ID uses `medicine.id.hashCode` for uniqueness
- Payload system for deep linking

### 3. Activity Tracking

**Implementation**: `activity_service.dart`

- Each medicine action (taken/missed) stored as `MedicineActivity`
- Activities stored as JSON array in SharedPreferences
- Filtered by date for daily/weekly/monthly views

### 4. State Management

**Pattern**: Service layer with ChangeNotifier

**Key Services:**

- `MedicineService` - CRUD operations for medicines
- `NotificationService` - Scheduling and canceling notifications
- `ActivityService` - Recording and retrieving activities
- `ProgressNotifier` - Broadcasting progress updates

---

## Special/Unique Features

1. **Lifecycle-Aware Missed Dose Detection**
   - Uses `WidgetsBindingObserver` to detect app state changes
   - Automatically marks missed doses when app comes to foreground
   - No manual intervention needed

2. **Smart Notification Payload System**
   - Different payloads for different notification types
   - Deep linking to specific app sections
   - Low stock notifications navigate directly to Stock tab

3. **Multi-Step Medicine Addition**
   - Progressive disclosure UI pattern
   - 8-step wizard with validation
   - Back navigation maintains state
   - Edit mode pre-fills existing data

4. **Real-Time Progress Synchronization**
   - ChangeNotifier pattern for instant updates
   - All tabs reflect changes immediately
   - No manual refresh needed

5. **Timezone-Aware Scheduling**
   - Uses Asia/Colombo timezone
   - Handles daylight saving time
   - Exact time matching for daily repetition

6. **Material Design 3**
   - Dynamic color theming
   - Light/Dark mode support
   - Gradient backgrounds
   - Smooth animations

7. **Offline-First Architecture**
   - No internet required
   - All data stored locally
   - Instant app performance
   - Privacy-focused (no data leaves device)

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

### Example: Adding a Medicine

**8-Step Wizard:**

1. **Medicine Name** → User enters medication name
2. **Form Selection** → Choose: Tablet, Capsule, Syrup, Injection
3. **Frequency** → Select: Daily, Weekly, Monthly
4. **Daily Frequency** → Times per day
5. **Time Selection** → Exact time picker
6. **Dosage** → Number of units per dose
7. **Stock Quantity** → Initial stock count
8. **Review & Save** → Confirmation page

**Backend Flow:**

```
User Input → Medicine Model → JSON Serialization
→ SharedPreferences Storage → Notification Scheduling → UI Refresh
```

### Example: Taking Medicine

**Flow:**

1. User taps "Take" button on home screen
2. App creates `MedicineActivity` with action="taken"
3. Activity saved to SharedPreferences
4. Progress statistics updated
5. Stock quantity decremented
6. Progress tab updates in real-time via `ProgressNotifier`

### Notification Flow

```
Medicine Scheduled → NotificationService.scheduleMedicineNotification()
→ flutter_local_notifications → OS Notification System
→ User taps notification → Deep link to app (optional payload)
```

---

## Demo Flow Recommendation

1. **Start**: Show onboarding flow (skip if already done)
2. **Add Medicine**: Demonstrate the 8-step wizard
3. **Home Screen**: Show today's medications
4. **Take Action**: Mark a medicine as taken
5. **Progress Tab**: Show adherence percentage and activity log
6. **Stock Tab**: Update quantity, show low stock warning
7. **Notification**: Trigger a test notification
8. **Missed Dose**: Exit app, wait past medicine time, return to show auto-missed detection
9. **Settings**: Show user profile and preferences

---

## Authors

**Team 3idiots**

- Sandaru

---

## License

This project is licensed under the MIT License.

---

**Made with Flutter**....
