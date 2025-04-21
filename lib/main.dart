import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:myexpenseproject/screens/home_screen.dart';
import 'package:myexpenseproject/screens/monthly_summary_screen.dart';
import 'package:myexpenseproject/screens/login_screen.dart'; // <-- Import your login screen
import 'package:myexpenseproject/providers/transaction_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDo0Bt-wymq9j35MLX9laj8h3KK7t5VRTI",
          authDomain: "my-expense-project-6249c.firebaseapp.com",
          projectId: "my-expense-project-6249c",
          storageBucket: "my-expense-project-6249c.appspot.com",
          messagingSenderId: "351043571549",
          appId: "1:351043571549:web:865b9c59c8e292e72be2b4",
          measurementId: "G-Q8H1DWBM0G",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    print("✅ Firebase Initialized successfully!");
  } catch (e) {
    print("❌ Error initializing Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal Finance Tracker',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // Show LoginScreen or HomeScreen based on auth state
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return const HomeScreen(); // User is logged in
            } else {
              return const LoginScreen(); // User is not logged in
            }
          },
        ),
        routes: {
          '/home': (ctx) => const HomeScreen(),
          '/monthly-summary': (ctx) => const MonthlySummaryScreen(),
          '/login': (ctx) => const LoginScreen(),
        },
      ),
    );
  }
}
