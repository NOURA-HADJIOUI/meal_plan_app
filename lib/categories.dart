import 'package:flutter/material.dart';

void main() {
  runApp(const Categorie());
}

class Categorie extends StatelessWidget {
  const Categorie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CategoriesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Category {
  final String title;
  final String subtitle;
  final String imageUrl;

  Category({required this.title, required this.subtitle, required this.imageUrl});
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar & App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEDEDED)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Algerian',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F0F0F),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance for the back button
                ],
              ),
            ),
            
            // Category List
            Expanded(
              child: CategoryList(),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  CategoryList({super.key});

  final List<Category> categories = [
    Category(
      title: 'Traditionnal',
      subtitle: 'Algerian',
      imageUrl: 'https://images.unsplash.com/photo-1551462147-ff29053bfc14?q=80&w=1974',
    ),
    Category(
      title: 'Appetizers',
      subtitle: 'Algerian',
      imageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    ),
    Category(
      title: 'Salads',
      subtitle: 'Algerian',
      imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=1974',
    ),
    Category(
      title: 'Desserts',
      subtitle: 'Algerian',
      imageUrl: 'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=1974',
    ),
    Category(
      title: 'Drinks',
      subtitle: 'Algerian',
      imageUrl: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?q=80&w=1974',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: categories.length,
      itemBuilder: (context, index) => CategoryCard(category: categories[index]),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            category.imageUrl,
            fit: BoxFit.cover,
          ),
          
          // Gradient Overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 93,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          
          // Text Content
          Positioned(
            left: 16,
            bottom: 28,
            child: Text(
              category.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Acme',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          
          // Subtitle
          Positioned(
            left: 16,
            bottom: 8,
            child: Text(
              category.subtitle,
              style: TextStyle(
                color: Colors.white.withAlpha((0.6 * 255).toInt()),
                fontSize: 16,
                fontFamily: 'Crimson Text',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}