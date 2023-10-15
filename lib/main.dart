import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import './screens/home_page.dart';
import 'providers/user_providers.dart';
import 'screens/login_signup/login_page.dart';
import 'utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  
  // ErrorWidget.builder = (FlutterErrorDetails details) => MaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       home: Scaffold(
  //         body: Container(
  //           color: secondary,
  //           child: Center(
  //             child: Column(
  //               children: [
  //                 Flexible(
  //                   child: Container(),
  //                   flex: 10,
  //                 ),
  //                 Image.asset(
  //                   'assets/images/logo.png',
  //                   color: primary,
  //                   height: 100,
  //                   width: 100,
  //                 ),
  //                 Flexible(
  //                   child: Container(),
  //                   flex: 1,
  //                 ),
  //                 CircularProgressIndicator(
  //                   color: primary,
  //                 ),
  //                 Flexible(
  //                   child: Container(),
  //                   flex: 10,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sustainable Swap',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xff2e71e5, color),
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        // home: const LandingPage(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not

              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const HomePage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginPage();
          },
        ),
      ),
    );
  }
}