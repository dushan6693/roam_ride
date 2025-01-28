import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_roam_ride/home.dart';
import 'package:fyp_roam_ride/map_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'login.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
  ));
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'watch queue Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
        //colorScheme: ColorProfile.light
      ),
      // darkTheme: ThemeData(
      //     textTheme: GoogleFonts.poppinsTextTheme(),
      //     useMaterial3: true,
      //     colorScheme: ColorProfile.dark),
      themeMode: ThemeMode.system,
      home: AuthWrapper(),
      // const MapScreen(
      //     destination: LatLng(37.7749, -122.4194)),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user != null) {
            // User is signed in, load the home page
            return Home();
          } else {
            // User is not signed in, load the login page
            return Login();
          }
        } else {
          // Show a loading indicator while checking the authentication state
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
