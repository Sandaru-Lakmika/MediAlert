import 'package:flutter/material.dart';
import 'features/welcome/welcome_page.dart';
import 'features/welcome/user_info_page.dart';
import 'features/welcome/gender_page.dart';
import 'features/welcome/birth_date_page.dart';
import 'features/welcome/goals_page.dart';
import 'features/medicine/add_medicine_page.dart';
import 'home/home_page.dart';

//i am sandaru
//NO excuses in professional life just do it
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediReminderApp());
}

class MediReminderApp extends StatelessWidget {
  const MediReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF2196F3); // vibrant medical blue
    return MaterialApp(
      title: 'Medicine Reminder',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      routes: {
        '/': (_) => const WelcomePage(),
        '/home': (_) => const HomePage(),
        '/user-info': (_) => const UserInfoPage(),
        '/gender': (_) => const GenderPage(),
        '/birth-date': (_) => const BirthDatePage(),
        '/goals': (_) => const GoalsPage(),
        '/add-medicine': (_) => const AddMedicinePage(),
      },
    );
  }
}
