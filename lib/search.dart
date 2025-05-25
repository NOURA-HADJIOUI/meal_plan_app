import 'package:flutter/material.dart';

// Classe pour représenter une recette
class Recipes  {
  final String name;
  final String description;
  final List<String> ingredients;
  final int cookingTime; // en minutes
  final String difficulty;
  final List<String> tags;
  final String imageUrl;

  Recipes({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.cookingTime,
    required this.difficulty,
    required this.tags,
    required this.imageUrl,
  });

  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    final searchLower = query.toLowerCase();
    return name.toLowerCase().contains(searchLower) ||
           description.toLowerCase().contains(searchLower) ||
           ingredients.any((ingredient) => 
               ingredient.toLowerCase().contains(searchLower)) ||
           tags.any((tag) => tag.toLowerCase().contains(searchLower));
  }

  bool matchesFilters(Set<String> filters) {
    if (filters.isEmpty) return true;
    
    for (String filter in filters) {
      bool matches = false;
      
      switch (filter) {
        case 'Easy':
          matches = difficulty == 'Easy';
          break;
        case '5 Ingredients or Less':
          matches = ingredients.length <= 5;
          break;
        case 'Under 30 Minutes':
          matches = cookingTime <= 30;
          break;
        case 'Under 1 Hour':
          matches = cookingTime <= 60;
          break;
        case 'Under 4 Hours':
          matches = cookingTime <= 240;
          break;
        case 'Under 15 Minutes':
          matches = cookingTime <= 15;
          break;
        default:
          matches = tags.contains(filter);
          break;
      }
      
      if (!matches) return false;
    }
    
    return true;
  }
}

class RecipeSearchPage extends StatefulWidget {
  const RecipeSearchPage({super.key});

  @override
  _RecipeSearchPageState createState() => _RecipeSearchPageState();
}

class _RecipeSearchPageState extends State<RecipeSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  
  // États des filtres
  Set<String> selectedPopular = {};
  Set<String> selectedDifficulty = {};
  Set<String> selectedDiets = {};
  Set<String> selectedCookingStyle = {};

  // Liste des recettes
  List<Recipes> allRecipes = [];
  List<Recipes> filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _initializeRecipes();
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeRecipes() {
    allRecipes = [
      Recipes(
        name: 'Salade César au Poulet',
        description: 'Une délicieuse salade césar avec du poulet grillé et des croûtons maison.',
        ingredients: ['Poulet', 'Laitue romaine', 'Parmesan', 'Croûtons', 'Sauce césar'],
        cookingTime: 25,
        difficulty: 'Easy',
        tags: ['Chicken', 'Healthy', 'Savory', 'Salad Dressings'],
        imageUrl: 'assets/caesar_salad.jpg',
      ),
      Recipes(
        name: 'Pancakes aux Myrtilles',
        description: 'Des pancakes moelleux aux myrtilles fraîches, parfaits pour le petit-déjeuner.',
        ingredients: ['Farine', 'Œufs', 'Lait', 'Myrtilles'],
        cookingTime: 15,
        difficulty: 'Easy',
        tags: ['Breakfast', 'Under 15 Minutes', '5 Ingredients or Less', 'Easy'],
        imageUrl: 'assets/pancakes.jpg',
      ),
      Recipes(
        name: 'Smoothie Protéiné',
        description: 'Un smoothie riche en protéines pour bien commencer la journée.',
        ingredients: ['Banane', 'Protéine en poudre', 'Lait d\'amande'],
        cookingTime: 5,
        difficulty: 'Easy',
        tags: ['Breakfast', 'High Protein', 'Healthy', 'No Cook', 'Vegan', 'Under 15 Minutes'],
        imageUrl: 'assets/smoothie.jpg',
      ),
      Recipes(
        name: 'Tarte au Chocolat',
        description: 'Une tarte au chocolat décadente pour les amateurs de desserts.',
        ingredients: ['Chocolat noir', 'Beurre', 'Œufs', 'Sucre', 'Farine', 'Crème'],
        cookingTime: 180,
        difficulty: 'Medium',
        tags: ['Dessert', 'Under 4 Hours'],
        imageUrl: 'assets/chocolate_tart.jpg',
      ),
      Recipes(
        name: 'Sauté de Légumes',
        description: 'Un sauté de légumes colorés, sain et rapide à préparer.',
        ingredients: ['Brocolis', 'Poivrons', 'Courgettes', 'Huile d\'olive', 'Ail'],
        cookingTime: 20,
        difficulty: 'Easy',
        tags: ['Vegan', 'Healthy', 'Under 30 Minutes', 'Stove Top', 'Inexpensive'],
        imageUrl: 'assets/veggie_stir_fry.jpg',
      ),
      Recipes(
        name: 'Gazpacho Andalou',
        description: 'Une soupe froide rafraîchissante, parfaite pour l\'été.',
        ingredients: ['Tomates', 'Concombre', 'Poivron', 'Oignon'],
        cookingTime: 10,
        difficulty: 'Easy',
        tags: ['Vegan', 'Healthy', 'No Cook', 'Under 15 Minutes', 'Low Cholesterol'],
        imageUrl: 'assets/gazpacho.jpg',
      ),
    ];
    
    filteredRecipes = List.from(allRecipes);
  }

void _performSearch() {
  setState(() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      filteredRecipes = [];
      return;
    }

    final allFilters = {
      ...selectedPopular,
      ...selectedDifficulty,
      ...selectedDiets,
      ...selectedCookingStyle,
    };

    filteredRecipes = allRecipes.where((recipe) {
      return recipe.matchesSearch(query) && recipe.matchesFilters(allFilters);
    }).toList();
  });
}


  // Données des filtres
  final List<FilterItem> popularFilters = [
    FilterItem('Easy', Icons.star_outline),
    FilterItem('5 Ingredients or Less', Icons.list_alt),
    FilterItem('Under 30 Minutes', Icons.timer),
    FilterItem('Chicken', Icons.restaurant),
    FilterItem('Breakfast', Icons.breakfast_dining),
    FilterItem('Dessert', Icons.cake),
  ];

  final List<FilterItem> difficultyFilters = [
    FilterItem('Under 1 Hour', Icons.schedule),
    FilterItem('Under 4 Hours', Icons.schedule),
    FilterItem('Under 15 Minutes', Icons.timer),
    FilterItem('5 Ingredients or Less', Icons.list_alt),
  ];

  final List<FilterItem> dietFilters = [
    FilterItem('Low Protein', Icons.fitness_center),
    FilterItem('High Protein', Icons.fitness_center),
    FilterItem('Vegan', Icons.eco),
    FilterItem('Healthy', Icons.favorite),
    FilterItem('Low Cholesterol', Icons.health_and_safety),
  ];

  final List<FilterItem> cookingStyleFilters = [
    FilterItem('Salad Dressings', Icons.restaurant_menu),
    FilterItem('Savory', Icons.restaurant),
    FilterItem('No Cook', Icons.no_meals),
    FilterItem('Inexpensive', Icons.attach_money),
    FilterItem('Stove Top', Icons.soup_kitchen),
    FilterItem('Small Appliance', Icons.kitchen),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Recherche',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre de recherche
              _buildSearchBar(),
              SizedBox(height: 20),
              
              // Affichage du nombre de résultats
             if (_searchController.text.trim().isNotEmpty) ...[
  Text(
    '${filteredRecipes.length} recette(s) trouvée(s)',
    style: TextStyle(
      fontSize: 14,
      color: Colors.grey[600],
      fontWeight: FontWeight.w500,
    ),
  ),
  SizedBox(height: 20),

  if (filteredRecipes.isNotEmpty) ...[
    _buildSearchResults(),
    SizedBox(height: 30),
  ] else ...[
    Text(
      'Aucune recette trouvée.',
      style: TextStyle(
        color: Colors.redAccent,
        fontSize: 14,
      ),
    ),
    SizedBox(height: 30),
  ],
],

              
              // Section Populaire
              _buildFilterSection(
                'Popular',
                popularFilters,
                selectedPopular,
              ),
              SizedBox(height: 25),
              
              // Section Difficulté
              _buildFilterSection(
                'Difficulty',
                difficultyFilters,
                selectedDifficulty,
              ),
              SizedBox(height: 25),
              
              // Section Régimes
              _buildFilterSection(
                'Diets',
                dietFilters,
                selectedDiets,
              ),
              SizedBox(height: 25),
              
              // Section Style de Cuisine
              _buildFilterSection(
                'Cooking Style',
                cookingStyleFilters,
                selectedCookingStyle,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher une recette...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[500],
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Résultats',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),
        ...filteredRecipes.map((recipe) => _buildRecipeCard(recipe)),
      ],
    );
  }

  Widget _buildRecipeCard(Recipes recipe) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      recipe.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.orange[800],
                  size: 30,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.timer, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                '${recipe.cookingTime} min',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.star, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                recipe.difficulty,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.restaurant_menu, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                '${recipe.ingredients.length} ingrédients',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<FilterItem> filters,
    Set<String> selectedFilters,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: filters.map((filter) {
                final isSelected = selectedFilters.contains(filter.name);
                return _buildFilterChip(
                  filter.name,
                  filter.icon,
                  isSelected,
                  () {
                    setState(() {
                      if (isSelected) {
                        selectedFilters.remove(filter.name);
                      } else {
                        selectedFilters.add(filter.name);
                      }
                      _performSearch(); // Relancer la recherche après modification des filtres
                    });
                  },
                  constraints.maxWidth,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    double maxWidth,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterItem {
  final String name;
  final IconData icon;

  FilterItem(this.name, this.icon);
}

// Utilisation dans votre app principale
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Search',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'SF Pro Text', // ou une police similaire
      ),
      home: RecipeSearchPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(MyApp());
}