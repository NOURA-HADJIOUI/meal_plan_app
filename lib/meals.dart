import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class Meal {
  final String title;
  final String description;
  final String imageUrl;

  Meal({required this.title, required this.description, required this.imageUrl});
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MealsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Back Button and Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () {},
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Traditional',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance for the back button
                ],
              ),
            ),
            
            // Meal List
            Expanded(
              child: Meals(),
            ),
          ],
        ),
      ),
    );
  }
}

class Meals extends StatelessWidget {
  Meals({super.key});

  final List<Meal> meals = List.generate(
    8,
    (index) => Meal(
      title: 'Udon Miso',
      description: 'Thick handmade udon noodles in a rich miso broth...',
      imageUrl: index % 2 == 0
          ? "https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg"  // Ramen/udon image
          : "https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg", // Soup image
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: meals.length,
      itemBuilder: (context, index) => MealCard(meal: meals[index]),
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: [
            // Left side: Text
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            
            // Right side: Image
            Expanded(
              flex: 2,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(meal.imageUrl),
                    fit: BoxFit.cover,
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