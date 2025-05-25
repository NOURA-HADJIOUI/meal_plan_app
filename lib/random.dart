import 'package:flutter/material.dart';

void main() {
  runApp(const RandomPage());
}



class RandomPage extends StatefulWidget {
  const RandomPage({super.key});

  @override
  State<RandomPage> createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  final List<Meal> _meals = [
    Meal(
      name: 'Pasta with Tomato Sauce',
      time: '20min',
      calories: '620 kcal',
      imageUrl: 'assets/img/pic1 (3).jpg',
    ),
    Meal(
      name: 'Lemon Chicken',
      time: '30min',
      calories: '700 kcal',
      imageUrl: 'assets/img/pic1 (3).jpg',
    ),
    Meal(
      name: 'Grilled Salmon',
      time: '20min',
      calories: '520 kcal',
      imageUrl: 'assets/img/pic1 (3).jpg',
    ),
    Meal(
      name: 'Soy Glazed Salmon',
      time: '25min',
      calories: '580 kcal',
      imageUrl: 'assets/img/pic1 (3).jpg',
    ),
    Meal(
      name: 'Vegetable Stir Fry',
      time: '15min',
      calories: '450 kcal',
      imageUrl: 'assets/img/pic1 (3).jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Random Meal Planning'), // titre fixe, couleur noire par défaut (héritée)
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              // Action de téléchargement
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildMealItem(_meals[0], width),
                  const SizedBox(height: 16),
                  _buildMealItem(_meals[1], width),
                  const SizedBox(height: 16),
                  _buildMealItem(_meals[2], width),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Dinner:'),
                  const SizedBox(height: 8),
                  _buildMealItem(_meals[0], width),
                  const SizedBox(height: 16),
                  _buildMealItem(_meals[1], width),
                  const SizedBox(height: 16),
                  _buildMealItem(_meals[3], width),
                  const SizedBox(height: 16),
                  _buildMealItem(_meals[4], width),
                  const SizedBox(height: 32),
                  _buildActionButtons(width),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showDownloadIcon = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showDownloadIcon)
          const Icon(Icons.download_outlined, color: Colors.grey),
      ],
    );
  }

  Widget _buildMealItem(Meal meal, double width) {
    // Adaptation taille image selon largeur
    double imageHeight = width > 600 ? 250 : 160;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: imageHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(meal.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width > 600 ? 24 : 18,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      meal.time,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.local_fire_department, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      meal.calories,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(double width) {
    bool isWide = width > 600;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9431),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 48 : 32,
              vertical: 20,
            ),
          ),
          child: Text(
            'Save Meal Plan',
            style: TextStyle(fontSize: isWide ? 20 : 16),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9431),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 48 : 32,
              vertical: 20,
            ),
          ),
          child: Text(
            'Regenerate',
            style: TextStyle(fontSize: isWide ? 20 : 16),
          ),
        ),
      ],
    );
  }
}


class Meal {
  final String name;
  final String time;
  final String calories;
  final String imageUrl;

  const Meal({
    required this.name,
    required this.time,
    required this.calories,
    required this.imageUrl,
  });
}