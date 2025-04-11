
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/dashboard.dart';
import 'package:untitled6/home.dart';
import 'package:untitled6/reported.dart';
import 'package:untitled6/users.dart';
import 'package:untitled6/admin.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {  
   await Firebase.initializeApp(options:FirebaseOptions(  apiKey: "AIzaSyB46XNoZSeF1HoBt8GsEDxqHpZrcgFklrw",
  authDomain: "fir-317ff.firebaseapp.com",
  projectId: "fir-317ff",
  storageBucket: "fir-317ff.firebasestorage.app",
  messagingSenderId: "556746272305",
  appId: "1:556746272305:web:a654f7f5dd4b81300d6f10",
  measurementId: "G-4KD48YK7B6") );}
else {
  Firebase.initializeApp();
}
runApp(MyApp());

}

class MyApp extends StatefulWidget{
  const MyApp({super.key});


  @override
  State<MyApp> createState() => MyAppState();
  }

  class MyAppState extends State<MyApp> {
GlobalKey<FormState> one=GlobalKey();
    String?s;
        String?h;
  @override
  Widget build(BuildContext context) {
return MaterialApp(
home: Home(),
routes: {
"dashb":(context)=> Dashboard(),
"user":(context)=> Users(),
"admin":(context)=>Admin(),
"rep":(context)=>Reported(),
},
);
  }
  }