import 'package:flutter/material.dart';
import 'search.dart';
import 'viewAll.dart';
import 'mealDetail.dart';
import 'profile.dart';
import 'mealPlanFull.dart';
import 'random.dart';
import 'package:meal_plan_app/meal.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(initialIndex: 0),
        '/meal-planning': (context) => const MainScreen(initialIndex: 1),
        '/random-recipes': (context) => const MainScreen(initialIndex: 2),
        '/profile': (context) => const MainScreen(initialIndex: 3),
      },
    );
  }
}
class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;
  
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;
  
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
      
  // Helper method to get dynamic padding based on screen size
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 20);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 30);
    } else {
      return const EdgeInsets.symmetric(horizontal: 50);
    }
  }
  
  // Helper to get dynamic font size based on screen width
  static double getFontSize(BuildContext context, double baseFontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return baseFontSize * 0.8;
    if (screenWidth > 1200) return baseFontSize * 1.2;
    return baseFontSize;
  }
  
  // Helper to get dynamic item width for list items
  static double getItemWidth(BuildContext context, {double mobileWidth = 220, double tabletWidth = 300, double desktopWidth = 320}) {
    if (isMobile(context)) return mobileWidth;
    if (isTablet(context)) return tabletWidth;
    return desktopWidth;
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, required this.initialIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // List of all screens
  final List<Widget> _screens = [
    const HomePage(),
    const MealPlanning(),
    RandomPage(), 
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AnimatedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AnimatedBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.home,
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarItem(
            icon: Icons.calendar_today,
            label: 'Meal Planning',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavBarItem(
            icon: Icons.shuffle,
            label: 'Random Recipes',
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavBarItem(
            icon: Icons.person,
            label: 'Profile',
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFF9431).withOpacity(0.2) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: isActive ? const Color(0xFFFF9431) : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFFFF9431) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Méthode pour créer des recettes d'exemple
  Recipe _createSampleRecipe(String title, String imageUrl, String description, String time) {
    return Recipe(
      title: title,
      imageUrl: imageUrl,
      description: description,
      time: time,
      difficulty: "Easy",
      calories: "250 kcal",
       quantity: "",
      rating: 4.5,
      reviewCount: 128,
      ingredients: [
        Ingredient(name: "Lettuce", quantity: "2 cups", imageUrl: "assets/img/lettuce.jpg"),
        Ingredient(name: "Tomatoes", quantity: "3 pieces", imageUrl: "assets/img/tomato.jpg"),
      ],
      steps: [
        "Wash and chop the lettuce",
        "Cut tomatoes into small pieces",
        "Mix everything together"
      ],
      reviews: [
        Review(
          userName: "John Doe",
          userImage: "assets/img/user1.jpg",
          rating: 5.0,
          comment: "Amazing recipe!",
          date: "2 days ago"
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = ResponsiveHelper.getScreenPadding(context);
    final fontSize20 = ResponsiveHelper.getFontSize(context, 20);
    final fontSize18 = ResponsiveHelper.getFontSize(context, 18);
    final gridCrossAxisCount = ResponsiveHelper.isMobile(context)
        ? 1
        : ResponsiveHelper.isTablet(context)
            ? 2
            : 3;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 10),

          // Header
          Padding(
            padding: screenPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello, user name!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/profile_placeholder.jpg"),
                        fit: BoxFit.cover,
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Search bar
          Padding(
            padding: screenPadding,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RecipeSearchPage()),
              ),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: const Color(0xFF3C2F2F),
                        fontSize: fontSize18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // New Recipes Section
          SectionHeader(
            title: 'New Recipes',
            showViewAll: true,
            onViewAllTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ViewAll()),
            ),
          ),
          const SizedBox(height: 10),

          ResponsiveHelper.isMobile(context)
              ? _buildHorizontalRecipeList(context)
              : Padding(
                  padding: screenPadding,
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: gridCrossAxisCount,
                    childAspectRatio: 1.2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final recipe = _createSampleRecipe(
                            "Caesar Salad",
                            "assets/img/Recipe1.jpeg",
                            "Crisp romaine lettuce with creamy dressing",
                            "25min"
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MealDetailPage(recipe: recipe),
                            ),
                          );
                        },
                        child: const RecipeCard(
                          imageUrl: "assets/img/Recipe1.jpeg",
                          title: "Caesar Salad",
                          description: "Crisp romaine lettuce with\ncreamy dressing",
                          time: "25min",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final recipe = _createSampleRecipe(
                            "Bruschetta",
                            "assets/img/Recipe2.jpeg",
                            "Grilled bread with tomato and basil",
                            "37min"
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MealDetailPage(recipe: recipe),
                            ),
                          );
                        },
                        child: const RecipeCard(
                          imageUrl: "assets/img/Recipe2.jpeg",
                          title: "Bruschetta",
                          description: "Grilled bread with tomato\nand basil",
                          time: "37min",
                        ),
                      ),
                    ],
                  ),
                ),

          const SizedBox(height: 20),

          // Get Inspired Section
          const SectionHeader(title: 'Get Inspired', showViewAll: false),
          const SizedBox(height: 10),

          ResponsiveHelper.isMobile(context)
              ? _buildHorizontalCuisineList(context)
              : Padding(
                  padding: screenPadding,
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: gridCrossAxisCount,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    children: [
                      _buildCuisineGridItem(context, "assets/img/Algerian Food.jpeg", "Algerian"),
                      _buildCuisineGridItem(context, "assets/img/mexicanfood.jpg", "Mexican"),
                      _buildCuisineGridItem(context, "assets/img/middleEastern.jpg", "Middle-Eastern"),
                      _buildCuisineGridItem(context, "assets/img/SpanishFood.jpg", "Spanish"),
                      _buildCuisineGridItem(context, "assets/img/Asianfood.jpg", "Asian-Style"),
                    ],
                  ),
                ),

          const SizedBox(height: 20),

          // Suggestions Section
          SectionHeader(
            title: 'Suggestions',
            showViewAll: true,
            onViewAllTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ViewAll()),
            ),
          ),
          const SizedBox(height: 10),

          ResponsiveHelper.isMobile(context)
              ? _buildHorizontalDessertList(context)
              : Padding(
                  padding: screenPadding,
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: gridCrossAxisCount,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    children: const [
                      DessertCard(
                        imageUrl: "assets/img/ChocolateMousse.jpg",
                        title: "Chocolate Mousse",
                        description: "Rich and creamy chocolate\ndessert",
                      ),
                      DessertCard(
                        imageUrl: "assets/img/Sweet1.jpeg",
                        title: "Tiramisu",
                        description: "Layered coffee-flavored Italian\ndessert",
                      ),
                      DessertCard(
                        imageUrl: "assets/img/Drink 1.jpeg",
                        title: "Fruit Smoothie",
                        description: "Fresh and healthy fruit\nbeverage",
                      ),
                      DessertCard(
                        imageUrl: "assets/img/Sweet3.jpeg",
                        title: "Crème Brûlée",
                        description: "Classic French vanilla\ndessert",
                      ),
                    ],
                  ),
                ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Helper method for horizontal recipe list
  Widget _buildHorizontalRecipeList(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: ResponsiveHelper.getScreenPadding(context),
        children: [
          SizedBox(
            width: ResponsiveHelper.getItemWidth(context),
            child: GestureDetector(
              onTap: () {
                final recipe = _createSampleRecipe(
                  "Caesar Salad",
                  "assets/img/Recipe1.jpeg",
                  "Crisp romaine lettuce with creamy dressing",
                  "25min"
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealDetailPage(recipe: recipe),
                  ),
                );
              },
              child: const RecipeCard(
                imageUrl: "assets/img/Recipe1.jpeg",
                title: "Caesar Salad",
                description: "Crisp romaine lettuce with\ncreamy dressing",
                time: "25min",
              ),
            ),
          ),
          const SizedBox(width: 15),
          SizedBox(
            width: ResponsiveHelper.getItemWidth(context),
            child: GestureDetector(
              onTap: () {
                final recipe = _createSampleRecipe(
                  "Bruschetta",
                  "assets/img/Recipe2.jpeg",
                  "Grilled bread with tomato and basil",
                  "37min"
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealDetailPage(recipe: recipe),
                  ),
                );
              },
              child: const RecipeCard(
                imageUrl: "assets/img/Recipe2.jpeg",
                title: "Bruschetta",
                description: "Grilled bread with tomato\nand basil",
                time: "37min",
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for horizontal cuisine list
  Widget _buildHorizontalCuisineList(BuildContext context) {
    return SizedBox(
      height: 188,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: ResponsiveHelper.getScreenPadding(context),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewAll()),
              );
            },
            child: const CuisineCard(
              imageUrl: "assets/img/Algerian Food.jpeg",
              cuisineName: "Algerian",
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewAll()),
              );
            },
            child: const CuisineCard(
              imageUrl: "assets/img/mexicanfood.jpg",
              cuisineName: "Mexican",
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewAll()),
              );
            },
            child: const CuisineCard(
              imageUrl: "assets/img/middleEastern.jpg",
              cuisineName: "Middle-Eastern",
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewAll()),
              );
            },
            child: const CuisineCard(
              imageUrl: "assets/img/SpanishFood.jpg",
              cuisineName: "Spanish",
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewAll()),
              );
            },
            child: const CuisineCard(
              imageUrl: "assets/img/Asianfood.jpg",
              cuisineName: "Asian-Style",
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for cuisine grid items
  Widget _buildCuisineGridItem(BuildContext context, String imageUrl, String cuisineName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ViewAll()),
        );
      },
      child: CuisineCard(
        imageUrl: imageUrl,
        cuisineName: cuisineName,
      ),
    );
  }

  // Helper method for horizontal dessert list
  Widget _buildHorizontalDessertList(BuildContext context) {
    return SizedBox(
      height: 308,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: ResponsiveHelper.getScreenPadding(context),
        children: [
          GestureDetector(
            onTap: () {
              final recipe = _createSampleRecipe(
                "Chocolate Mousse",
                "assets/img/ChocolateMousse.jpg",
                "Rich and creamy chocolate dessert",
                "30min"
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealDetailPage(recipe: recipe),
                ),
              );
            },
            child: const DessertCard(
              imageUrl: "assets/img/ChocolateMousse.jpg",
              title: "Chocolate Mousse",
              description: "Rich and creamy chocolate\ndessert",
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              final recipe = _createSampleRecipe(
                "Tiramisu",
                "assets/img/Sweet1.jpeg",
                "Layered coffee-flavored Italian dessert",
                "45min"
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealDetailPage(recipe: recipe),
                ),
              );
            },
            child: const DessertCard(
              imageUrl: "assets/img/Sweet1.jpeg",
              title: "Tiramisu",
              description: "Layered coffee-flavored Italian\ndessert",
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.showViewAll,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.getScreenPadding(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF11181C),
              fontSize: ResponsiveHelper.getFontSize(context, 20),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showViewAll)
            GestureDetector(
              onTap: onViewAllTap,
              child: Text(
                'View all',
                style: TextStyle(
                  color: const Color(0xFFABADAE),
                  fontSize: ResponsiveHelper.getFontSize(context, 15),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String time;

  const RecipeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust width based on screen size
    double cardWidth = ResponsiveHelper.getItemWidth(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: cardWidth,
              height: cardWidth * 0.75, // Keep aspect ratio
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getFontSize(context, 14),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF1C1B1F),
            fontSize: ResponsiveHelper.getFontSize(context, 16),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              color: const Color(0xFFA09CAB),
              fontSize: ResponsiveHelper.getFontSize(context, 16),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class CuisineCard extends StatelessWidget {
  final String imageUrl;
  final String cuisineName;

  const CuisineCard({
    super.key,
    required this.imageUrl,
    required this.cuisineName,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust width based on screen size
    double cardWidth = ResponsiveHelper.isMobile(context) ? 268 : double.infinity;
    
    return Container(
      width: cardWidth,
      height: 188,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
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
          // Cuisine name
          Positioned(
            bottom: 20,
            left: 16,
            child: Text(
              cuisineName,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.getFontSize(context, 36),
                fontFamily: 'Acme',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DessertCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const DessertCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust width based on screen size
    double cardWidth = ResponsiveHelper.isMobile(context) ? 268 : double.infinity;
    
    return Container(
      width: cardWidth,
      height: 308,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.5, 0.7, 1.0],
              ),
            ),
          ),
          // Title and description
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getFontSize(context, 24),
                    fontFamily: 'Acme',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getFontSize(context, 16),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
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
