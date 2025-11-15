import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:projet_ia/services/users.dart';
import 'package:projet_ia/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:projet_ia/classes/user.dart';
import 'package:projet_ia/screens/home.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isLoading = false;
  final UserService userService = UserService();
  UserProvider userProvider = UserProvider();

  Widget buildIcon(IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, size: 90, color: Colors.white),
    );
  }

  TextStyle buildTitleStyle(Color textColor) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w900,
      color: textColor,
    );
  }

  void createUser() async {
    // var userProvider = context.read<UserIdProvider>();
    setState(() {
      isLoading = true;
    });

    final response = await userService.createUser(new UserModel.empty());

    print(response);

    if (response.length == 36) {
      userProvider.setUserId(response);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vérifiez votre connexxion internet et ressayer"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          // colors: [Color(0xFFf5f7fa), Color(0xFFc3cfe2)],
          // colors: [Colors.white, Colors.black],
          colors: [
            Colors.white, // rose clair
            Colors.white, // rose clair
            Color(0xFFc3cfe2), // bleu-gris clair
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: IntroductionScreen(
        // globalBackgroundColor: Colors.grey[200],
        globalBackgroundColor: Colors.transparent,
        pages: [
          // ---- Écran 1 ----
          PageViewModel(
            title: "Un espace intime pour vous",
            body:
                "Discutez librement avec votre coach virtuel, exprimez vos émotions et recevez un soutien personnalisé.",
            image: buildIcon(Icons.chat_bubble_outline, Colors.pinkAccent),
            // image: Center(
            //   child: Icon(
            //     Icons.chat_bubble_outline,
            //     size: 120,
            //     color: Colors.pinkAccent,
            //   ),
            // ),
            decoration: PageDecoration(
              titleTextStyle: buildTitleStyle(Colors.pinkAccent),
              bodyTextStyle: TextStyle(fontSize: 16),
            ),
          ),

          // ---- Écran 2 ----
          PageViewModel(
            title: "Renforcez vos liens",
            body:
                "Accédez à des recommandations adaptées à votre relation pour mieux comprendre, aimer et partager.",
            image: buildIcon(Icons.favorite_outline, Colors.redAccent),
            // image: Center(
            //   child: Icon(
            //     Icons.favorite_outline,
            //     size: 120,
            //     color: Colors.redAccent,
            //   ),
            // ),
            decoration: PageDecoration(
              titleTextStyle: buildTitleStyle(Colors.redAccent),
              bodyTextStyle: TextStyle(fontSize: 16),
            ),
          ),

          // ---- Écran 3 ----
          PageViewModel(
            title: "Un lieu rien qu’à vous",
            body:
                "Gérez vos informations, personnalisez votre expérience et retrouvez vos conversations en toute confidentialité.",
            image: buildIcon(Icons.lock_outline, Colors.deepPurpleAccent),
            // image: Center(
            //   child: Icon(
            //     Icons.lock_outline,
            //     size: 120,
            //     color: Colors.deepPurpleAccent,
            //   ),
            // ),
            decoration: PageDecoration(
              titleTextStyle: buildTitleStyle(Colors.deepPurpleAccent),
              bodyTextStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],

        // Boutons
        onDone: () => createUser(),
        // {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => const UserFormScreen()),
        //   );
        // }
        showSkipButton: true,
        skip: const Text("Passer"),
        next: const Icon(Icons.arrow_forward),
        done: const Text(
          "Commencer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        dotsDecorator: const DotsDecorator(
          size: Size(8, 8),
          activeSize: Size(16, 8),
          activeColor: Colors.pinkAccent,
          color: Colors.grey,
          spacing: EdgeInsets.symmetric(horizontal: 3),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
