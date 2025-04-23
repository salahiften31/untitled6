import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/dashboard.dart';
import 'package:untitled6/home.dart';
import 'package:untitled6/reported.dart';
import 'package:untitled6/users.dart';
import 'package:untitled6/admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB46XNoZSeF1HoBt8GsEDxqHpZrcgFklrw",
            authDomain: "fir-317ff.firebaseapp.com",
            projectId: "fir-317ff",
            storageBucket: "fir-317ff.firebasestorage.app",
            messagingSenderId: "556746272305",
            appId: "1:556746272305:web:a654f7f5dd4b81300d6f10",
            measurementId: "G-4KD48YK7B6"));
  } else {
    Firebase.initializeApp();
  }
  await Supabase.initialize(
    url:
        'https://migwbqbtfzszopvhdzre.supabase.co', // Remplacez par l'URL de votre projet Supabase
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pZ3dicWJ0Znpzem9wdmhkenJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE5MjI3OTgsImV4cCI6MjA1NzQ5ODc5OH0.78NEfAWjrlWsjo_l9ZBLuKzNv13ikUWCBqE0DyCeZSA', // Remplacez par votre clé anonyme
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  GlobalKey<FormState> one = GlobalKey();
  String? s;
  String? h;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {
        "dashb": (context) => Dashboard(),
        "user": (context) => Users(),
        "admin": (context) => Admin(),
        "rep": (context) => Reported(),
      },
    );
  }
}
  String formatLikes(num likes) {
    // Utiliser un pattern personnalisé avec exactement 2 décimales
    final formatter = NumberFormat('#,##0.00', 'fr');
    // Pour les nombres importants, appliquer une logique de compactage manuel
    if (likes >= 1000000000000000) {
      return '${formatter.format(likes / 1000000000000000).replaceAll('\u202f', '')}P';
              
              
          
    } else if (likes >= 1000000000000) {
      return '${formatter.format(likes / 1000000000000).replaceAll('\u202f', '')}T';
    } else if (likes >= 1000000000) {
      return '${formatter.format(likes / 1000000000).replaceAll('\u202f', '')}G';
    } else if (likes >= 1000000) {
      return '${formatter.format(likes / 1000000).replaceAll('\u202f', '')}M';
    } else if (likes >= 1000) {
      return '${formatter.format(likes / 1000).replaceAll('\u202f', '')}k';
    } else if (likes <= 999) {
      final formatter1 = NumberFormat('#0', 'fr');
      return formatter1.format(likes);
    }

    return formatter.format(likes).replaceAll('\u202f', '');
  }