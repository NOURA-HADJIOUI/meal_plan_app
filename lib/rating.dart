// main.dart - Version avec section de rating utilisateur intégrée
import 'package:flutter/material.dart';
import 'package:meal_plan_app/calendar.dart';
import 'package:meal_plan_app/meal.dart';

class MealDetailPage extends StatelessWidget {
  final Recipe recipe;

  const MealDetailPage({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return RecipeDetailScreen(recipe: recipe);
  }
}

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  bool _isFavorite = false;
  
  // Variables pour le rating utilisateur
  int _userSelectedStars = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _hasUserRated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    final meal = Meal(
      title: recipe.title,
      imageUrl: recipe.imageUrl,
      recipe: recipe,
      description: recipe.description,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildRecipeImage(recipe.imageUrl),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    child: Text(
                      recipe.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      Text(
                        ' ${recipe.rating}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(${recipe.reviewCount} Reviews)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    recipe.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem('Ingredients', Icons.restaurant_menu, recipe.ingredients.length.toString()),
                      _buildInfoItem('Difficulty', Icons.signal_cellular_alt, recipe.difficulty),
                      _buildInfoItem('Time', Icons.access_time, recipe.time),
                      _buildInfoItem('Calories', Icons.local_fire_department, recipe.calories),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.black,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: 'Ingredients'),
                            Tab(text: 'Instructions'),
                          ],
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: _selectedIndex == 0 ? 300.0 : 250.0,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildIngredientsTab(recipe),
                              _buildInstructionsTab(recipe),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  _buildReviewsSection(recipe),
                  const SizedBox(height: 32.0),
                  // Section de rating utilisateur
                  _buildUserRatingSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildRegisterButton(meal),
    );
  }

  Widget _buildUserRatingSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Rate this recipe',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Did you like this recipe?',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16.0),
          // Étoiles de rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _userSelectedStars = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Icon(
                    _userSelectedStars > index ? Icons.star : Icons.star_border,
                    size: 40,
                    color: const Color(0xFFFFEB3B),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          // Texte de feedback
          Text(
            _getRatingText(_userSelectedStars),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24.0),
          // Bouton pour ajouter une photo
          GestureDetector(
            onTap: () {
              // Logique pour ajouter une photo
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Photo feature coming soon!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    const Text(
                      'Share your photo!',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Zone de commentaire
          Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add your comment here',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                maxLines: 3,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          // Bouton d'envoi
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _userSelectedStars > 0 ? _submitRating : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9431),
                disabledBackgroundColor: Colors.grey.shade300,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                _hasUserRated ? 'Update Rating' : 'Send Rating',
                style: TextStyle(
                  fontSize: 16,
                  color: _userSelectedStars > 0 ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Message de confirmation
          if (_hasUserRated) ...[
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Thank you for your rating!',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getRatingText(int stars) {
    switch (stars) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  void _submitRating() {
    if (_userSelectedStars > 0) {
      setState(() {
        _hasUserRated = true;
      });
      
      // Ici vous pouvez ajouter la logique pour sauvegarder le rating
      // Par exemple, envoyer à une API ou sauvegarder localement
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rating submitted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Optionnel: vider le commentaire après soumission
      // _commentController.clear();
    }
  }

  Widget _buildRecipeImage(String imageUrl) {
    // Gestion dynamique des images (URL ou assets)
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.restaurant,
              size: 50,
              color: Colors.grey[600],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else {
      // Pour les assets locaux
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.restaurant,
              size: 50,
              color: Colors.grey[600],
            ),
          );
        },
      );
    }
  }

  Widget _buildInfoItem(String title, IconData icon, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.orange, size: 20.0),
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsTab(Recipe recipe) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          Text('${recipe.ingredients.length} items'),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: recipe.ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = recipe.ingredients[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: _buildIngredientImage(ingredient.imageUrl),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ingredient.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ingredient.quantity,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientImage(String imageUrl) {
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return SizedBox(
        width: 50,
        height: 50,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.restaurant, color: Colors.grey[600]),
              ),
            );
          },
        ),
      );
    } else {
      return SizedBox(
        width: 50,
        height: 50,
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.restaurant, color: Colors.grey[600]),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildInstructionsTab(Recipe recipe) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: recipe.steps.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        recipe.steps[index],
                        style: TextStyle(
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(Recipe recipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              color: index < recipe.rating.floor() ? Colors.amber : Colors.amber.withOpacity(0.3),
              size: 30.0,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Center(
          child: Text(
            '${recipe.rating}',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16.0),
        _buildRatingBars(recipe),
        const SizedBox(height: 24.0),
        Text(
          '${recipe.reviewCount} reviews',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16.0),
        if (recipe.reviews.isNotEmpty) _buildReviewsList(recipe),
      ],
    );
  }

  Widget _buildRatingBars(Recipe recipe) {
    // Calcul dynamique des barres de notation basé sur les reviews existantes
    Map<int, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    
    if (recipe.reviews.isNotEmpty) {
      for (var review in recipe.reviews) {
        int rating = review.rating.round();
        if (rating >= 1 && rating <= 5) {
          ratingCounts[rating] = (ratingCounts[rating] ?? 0) + 1;
        }
      }
    } else {
      // Valeurs par défaut si pas de reviews
      ratingCounts = {5: 60, 4: 25, 3: 10, 2: 3, 1: 2};
    }

    int totalReviews = recipe.reviews.isNotEmpty ? recipe.reviews.length : 100;

    return Column(
      children: List.generate(
        5,
        (index) {
          int starRating = 5 - index;
          int count = ratingCounts[starRating] ?? 0;
          double percentage = totalReviews > 0 ? count / totalReviews : 0;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Row(
              children: [
                Text('$starRating', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        index < 2 ? Colors.orange : Colors.orangeAccent,
                      ),
                      minHeight: 8.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text('${(percentage * 100).round()}%', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsList(Recipe recipe) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recipe.reviews.length,
      itemBuilder: (context, index) {
        final review = recipe.reviews[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildUserAvatar(review.userImage),
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        review.date,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: List.generate(
                  5,
                  (starIndex) => Icon(
                    Icons.star,
                    color: starIndex < review.rating ? Colors.orange : Colors.grey[300],
                    size: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(review.comment),
              const SizedBox(height: 8.0),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserAvatar(String imageUrl) {
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 20.0,
        onBackgroundImageError: (exception, stackTrace) {
          // En cas d'erreur, utiliser une icône par défaut
        },
        child: imageUrl.isEmpty ? Icon(Icons.person, color: Colors.grey[600]) : null,
      );
    } else {
      return CircleAvatar(
        backgroundImage: AssetImage(imageUrl),
        radius: 20.0,
        onBackgroundImageError: (exception, stackTrace) {
          // En cas d'erreur, utiliser une icône par défaut
        },
        child: imageUrl.isEmpty ? Icon(Icons.person, color: Colors.grey[600]) : null,
      );
    }
  }

  Widget _buildRegisterButton(Meal meal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CalendarApp(meal: meal),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
          minimumSize: const Size(160, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Register meal!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}