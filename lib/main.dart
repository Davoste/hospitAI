import 'package:flutter/material.dart';
import 'package:hospital_management/screens/addPatient.dart';
import 'package:hospital_management/screens/dashboard.dart';
import 'package:hospital_management/screens/patients.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HOSPITAL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => const Dashboard(),
        '/patients': (context) => const Patients(),
        // '/appointments': (context) => const AppointmentsPage(),
        // '/messages': (context) => const MessagesPage(),
        // '/staff': (context) => const StaffManagementPage(),
        // '/pharmacy': (context) => const PharmacyPage(),
        // '/settings': (context) => const SettingsPage(),
        // '/support': (context) => const SupportPage(),
        // '/logout': (context) => const LogoutPage(),
        '/newPatient': (context) => const addPatient(),
      },
    );
  }
}
