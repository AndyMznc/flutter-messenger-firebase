import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttersimplon/pages/home_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:fluttersimplon/services/users_service.dart';
import 'package:fluttersimplon/theme.dart';
import 'package:jiffy/jiffy.dart';

const firebaseConfig = {};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb
          ? const FirebaseOptions(
              apiKey: "AIzaSyAZnPvLrNOoQ9Eo1W8IHqGpWg8b8eJdYx8",
              authDomain: "flutter-messenger-194a3.firebaseapp.com",
              projectId: "flutter-messenger-194a3",
              storageBucket: "flutter-messenger-194a3.appspot.com",
              messagingSenderId: "896073890490",
              appId: "1:896073890490:web:1f094676a638569205a083")
          : null);
  await Jiffy.setLocale('fr');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messagerie Simplon',
      theme: myTheme,
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (_) {
          return SignInScreen(
            providers: [EmailAuthProvider()],
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                //Ajoute ou met à jour l'utilisateur dans la base
                UsersServices.set(
                  state.user!.uid,
                  state.user!.email!,
                );
                //Redirige vers la Home Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              }),
            ],
          );
        },
        HomePage.name: (_) {
          return const HomePage();
        },
      },
    );
  }
}
