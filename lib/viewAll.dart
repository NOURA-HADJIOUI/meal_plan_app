import 'package:flutter/material.dart';

void main() {
  runApp(const ViewAll());
}

class ViewAll extends StatelessWidget {
  const ViewAll({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const RecipeHomePage(),
    );
  }
}

class RecipeHomePage extends StatefulWidget {
  const RecipeHomePage({super.key});

  @override
  State<RecipeHomePage> createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
// Index pour la navigation (Recipes est sélectionné)

  @override
  Widget build(BuildContext context) {
    // Récupération de la largeur de l'écran
    final screenWidth = MediaQuery.of(context).size.width;

    // Exemple d'adaptation de la taille du texte en fonction de la largeur
    double titleFontSize = screenWidth > 600 ? 22 : 18;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header avec back button et titre
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenWidth * 0.02,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    iconSize: screenWidth > 600 ? 32 : 24,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "New Recipes",
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.12), // Pour équilibrer le header
                ],
              ),
            ),

            // Liste de recettes
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(screenWidth * 0.04),
                children: const [
                  RecipeCard(
                    image: "assets/img/Recipe1.jpeg",
                    title: "Pasta with Tomato Sauce",
                    duration: "20min",
                    calories: "620 kcal",
                  ),
                  SizedBox(height: 16),
                  RecipeCard(
                    image: "assets/img/Recipe1.jpeg",
                    title: "Lemon Chicken",
                    duration: "30min",
                    calories: "700 kcal",
                  ),
                  SizedBox(height: 16),
                  RecipeCard(
                    image: "assets/img/Recipe1.jpeg",
                    title: "Grilled Salmon",
                    duration: "25min",
                    calories: "550 kcal",
                  ),
                  SizedBox(height: 16),
                  RecipeCard(
                    image: "assets/img/Recipe1.jpeg",
                    title: "Lemon Chicken",
                    duration: "30min",
                    calories: "700 kcal",
                  ),
                  SizedBox(height: 16),
                  RecipeCard(
                    image: "assets/img/Recipe1.jpeg",
                    title: "Lemon Chicken",
                    duration: "30min",
                    calories: "700 kcal",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String image;
  final String title;
  final String duration;
  final String calories;

  const RecipeCard({
    super.key,
    required this.image,
    required this.title,
    required this.duration,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Ajuster la hauteur de l'image selon la largeur (ratio 3:4 par exemple)
    final imageHeight = screenWidth > 600 ? 250.0 : 150.0;
    final fontSizeTitle = screenWidth > 600 ? 20.0 : 16.0;
    final fontSizeDetails = screenWidth > 600 ? 16.0 : 14.0;
    final padding = screenWidth * 0.04;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image de recette
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              image,
              height: imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Informations sur la recette
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$duration · $calories",
                  style: TextStyle(
                    fontSize: fontSizeDetails,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
