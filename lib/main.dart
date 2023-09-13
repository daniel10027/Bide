import 'package:bide/provider/auth_provider.dart';
import 'package:bide/screens/onboarding.dart';
import 'package:bide/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

       return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  onBoardingScreen(),
        title: "Bide",
      ),
    );
  }
}