import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:meal_plan_app/intro2.dart';
import 'package:meal_plan_app/login.dart';

void main() {
  runApp(const Intro());
}

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      // Ajout des routes
      routes: {
        '/': (context) => const Scaffold(body: SafeArea(child: Intro1())),
        '/nextPage': (context) => const Intro1(), // Page cible
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class Intro1 extends StatelessWidget {
  const Intro1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return SingleChildScrollView(
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/intro.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Positioned(
              top: height * 0.17,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      const Color(0x00C4C4C4),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),

            // Text content
            Positioned(
              left: width * 0.06,
              bottom: height * 0.15,
              right: width * 0.08,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you ready to plan\nyour week!',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Find the most delicious food\nwith the best quality',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            // Skip text (maintenant cliquable)
            Positioned(
              left: width * 0.8,
              bottom: height * 0.08,
              child: SizedBox(
                width: 60,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      // Animation de fondu + navigation
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const LoginEmpty(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    },
                    splashColor: Colors.transparent, // Désactive l'effet de splash
                    child: Text(
                      'Skip',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}