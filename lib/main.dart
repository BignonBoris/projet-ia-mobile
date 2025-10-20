import 'package:flutter/material.dart';
import 'package:projet_ia/screens/home.dart';
import 'package:provider/provider.dart';
import 'providers/user_id_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/menu_provider.dart';
// import 'screens/welcom_chat.dart';
import 'package:projet_ia/screens/on_bording.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getString('onboarding_done') ?? "";

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => UserIdProvider()..generateId()),
        ChangeNotifierProvider(create: (_) => UserIdProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        // ChangeNotifierProvider(create: (_) => UserIdProvider()..loadUserId()),
      ],
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String seenOnboarding;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home:
          (this.seenOnboarding.length == 36)
              ? HomeScreen()
              : OnboardingScreen(),
    );
  }
}
