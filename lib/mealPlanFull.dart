import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MealPlanning());
}

class MealPlanning extends StatelessWidget {
  const MealPlanning({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MealPlan(),
    );
  }
}

class MealPlan extends StatefulWidget {
  const MealPlan({super.key});

  @override
  _MealPlanState createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan> {
  int _selectedDay = 2; // Défaut sur Thursday (index 2)
  int _currentMonth = 4; // Avril
  int _currentYear = 2025;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'scheduled_meals'; // Nom de votre collection Firestore
  
  List<Map<String, dynamic>> _lunchMeals = [];
  List<Map<String, dynamic>> _dinnerMeals = [];
  bool _isLoading = false;
  
  final List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  
  final List<String> _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  
  List<Map<String, dynamic>> get _days {
    // Génère les jours du mois actuel
    DateTime firstDayOfMonth = DateTime(_currentYear, _currentMonth, 1);
    int daysInMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
    
    List<Map<String, dynamic>> days = [];
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime(_currentYear, _currentMonth, i);
      String dayName = _dayNames[date.weekday - 1];
      String fullDate = '${dayName}day, ${i.toString().padLeft(2, '0')} ${_monthNames[_currentMonth - 1]} $_currentYear';
      
      days.add({
        'number': i.toString().padLeft(2, '0'),
        'name': dayName,
        'fullDate': fullDate,
        'date': date,
      });
    }
    return days;
  }

  @override
  void initState() {
    super.initState();
    _loadMealsForSelectedDate();
  }

  // Méthode mise à jour pour récupérer les repas avec description et image
  Future<List<Map<String, dynamic>>> getMealsForDate(DateTime date) async {
    try {
      print('Recherche des repas pour la date: $date');

      // Utiliser la structure de données mise à jour du service Firebase
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      // Requête Firestore optimisée
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      print('Documents trouvés: ${querySnapshot.docs.length}');

      List<Map<String, dynamic>> meals = [];
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        
        // Mapper les données selon la nouvelle structure Firebase
        final mealData = {
          'id': doc.id,
          'mealTitle': data['title'] ?? data['mealTitle'] ?? 'Repas sans titre',
          'title': data['title'] ?? data['mealTitle'] ?? 'Repas sans titre',
          'description': data['description'] ?? 'Aucune description disponible',
          'imageUrl': data['imageUrl'] ?? '',
          'image': data['imageUrl'] ?? '', // Alias pour compatibilité
          'date': data['date'] != null ? (data['date'] as Timestamp).toDate() : DateTime.now(),
          'dateString': data['dateString'] ?? '',
          'createdAt': data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
          'year': data['year'] ?? date.year,
          'month': data['month'] ?? date.month,
          'day': data['day'] ?? date.day,
          'calories': data['calories'], // Si vous avez des calories dans certains repas
          'mealType': data['mealType'] ?? 'lunch', // Défaut à lunch si pas spécifié
        };

        meals.add(mealData);
        
        print('Repas ajouté: ${mealData['mealTitle']}');
        print('Description: ${mealData['description']}');
        print('Image URL: ${mealData['imageUrl']}');
      }

      // Si la requête optimisée ne fonctionne pas, utiliser la méthode de fallback
      if (meals.isEmpty) {
        print('Requête optimisée vide, utilisation de la méthode de fallback...');
        meals = await _getFallbackMealsForDate(date);
      }

      print('Total repas trouvés: ${meals.length}');
      return meals;
      
    } catch (e) {
      print('Erreur lors de la requête optimisée: $e');
      // Fallback vers l'ancienne méthode
      return await _getFallbackMealsForDate(date);
    }
  }

  // Méthode de fallback qui récupère tous les documents et filtre côté client
  Future<List<Map<String, dynamic>>> _getFallbackMealsForDate(DateTime date) async {
    try {
      print('Utilisation de la méthode de fallback pour la date: $date');

      final querySnapshot = await _firestore.collection(_collection).get();
      
      print('Total documents dans la collection: ${querySnapshot.docs.length}');
      
      List<Map<String, dynamic>> filteredMeals = [];
      
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        
        // Vérifier les différents formats de date possibles
        DateTime? mealDate;
        
        if (data['date'] != null) {
          mealDate = (data['date'] as Timestamp).toDate();
        } else if (data['selectedDate'] != null) {
          mealDate = (data['selectedDate'] as Timestamp).toDate();
        }

        if (mealDate != null) {
          print('Comparaison: ${mealDate.year}-${mealDate.month}-${mealDate.day} vs ${date.year}-${date.month}-${date.day}');
          
          // Comparer uniquement année, mois, jour (ignorer l'heure)
          if (mealDate.year == date.year && 
              mealDate.month == date.month && 
              mealDate.day == date.day) {
            
            // Mapper les données selon la nouvelle structure
            final mealData = {
              'id': doc.id,
              'mealTitle': data['title'] ?? data['mealTitle'] ?? 'Repas sans titre',
              'title': data['title'] ?? data['mealTitle'] ?? 'Repas sans titre',
              'description': data['description'] ?? 'Aucune description disponible',
              'imageUrl': data['imageUrl'] ?? '',
              'image': data['imageUrl'] ?? '', // Alias pour compatibilité
              'date': mealDate,
              'dateString': data['dateString'] ?? '${date.day}/${date.month}/${date.year}',
              'createdAt': data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
              'year': data['year'] ?? date.year,
              'month': data['month'] ?? date.month,
              'day': data['day'] ?? date.day,
              'calories': data['calories'],
              'mealType': data['mealType'] ?? 'lunch',
            };

            filteredMeals.add(mealData);
            print('Match trouvé: ${mealData['mealTitle']}');
            print('Description: ${mealData['description']}');
            print('Image URL: ${mealData['imageUrl']}');
          }
        }
      }

      print('Repas filtrés trouvés: ${filteredMeals.length}');
      return filteredMeals;
      
    } catch (e) {
      print('Erreur lors de la méthode de fallback: $e');
      return [];
    }
  }

  // Charger les repas pour la date sélectionnée
  Future<void> _loadMealsForSelectedDate() async {
    if (_days.isEmpty) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final selectedDate = _days[_selectedDay]['date'] as DateTime;
      final meals = await getMealsForDate(selectedDate);
      
      setState(() {
        // Séparer les repas par type si le champ mealType existe
        _lunchMeals = meals.where((meal) => 
          meal['mealType'] == 'lunch' || meal['mealType'] == null).toList();
        _dinnerMeals = meals.where((meal) => 
          meal['mealType'] == 'dinner').toList();
        
        // Si pas de séparation par type, mettre tous les repas dans lunch
        if (_lunchMeals.isEmpty && _dinnerMeals.isEmpty && meals.isNotEmpty) {
          _lunchMeals = meals;
        }
        
        _isLoading = false;
      });
      
      print('Repas chargés - Lunch: ${_lunchMeals.length}, Dinner: ${_dinnerMeals.length}');
    } catch (e) {
      print('Erreur lors du chargement des repas: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeLunchMeal(int index) async {
    if (index < _lunchMeals.length) {
      try {
        // Supprimer de Firestore
        await _firestore
            .collection(_collection)
            .doc(_lunchMeals[index]['id'])
            .delete();
        
        // Supprimer de la liste locale
        setState(() {
          _lunchMeals.removeAt(index);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Repas supprimé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Erreur lors de la suppression du repas: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la suppression du repas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeDinnerMeal(int index) async {
    if (index < _dinnerMeals.length) {
      try {
        // Supprimer de Firestore
        await _firestore
            .collection(_collection)
            .doc(_dinnerMeals[index]['id'])
            .delete();
        
        // Supprimer de la liste locale
        setState(() {
          _dinnerMeals.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Repas supprimé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Erreur lors de la suppression du repas: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la suppression du repas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _previousMonth() {
    setState(() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear--;
      } else {
        _currentMonth--;
      }
      _selectedDay = 0; // Reset to first day of new month
    });
    _loadMealsForSelectedDate();
  }

  void _nextMonth() {
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
      _selectedDay = 0; // Reset to first day of new month
    });
    _loadMealsForSelectedDate();
  }

  void _onDaySelected(int index) {
    setState(() {
      _selectedDay = index;
    });
    _loadMealsForSelectedDate();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Meal Planning',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 20),
                        onPressed: _previousMonth,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_monthNames[_currentMonth - 1]} $_currentYear',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 20),
                        onPressed: _nextMonth,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Week', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              // Section modifiée pour un meilleur défilement horizontal
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _days.length,
                  itemBuilder: (context, index) {
                    final day = _days[index];
                    final isSelected = _selectedDay == index;

                    return GestureDetector(
                      onTap: () => _onDaySelected(index),
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFFFA500) : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? const Color(0xFFFFA500) : Colors.grey.shade300,
                                  width: 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFFFFA500).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  day['number'],
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              day['name'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                color: isSelected ? const Color(0xFFFFA500) : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              if (_days.isNotEmpty)
                Text(
                  _days[_selectedDay]['fullDate'],
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),

              const SizedBox(height: 20),
              
              // Indicateur de chargement
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFA500)),
                    ),
                  ),
                ),

              if (!_isLoading) ...[
                // Section Lunch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Lunch:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                    Text(
                      '${_lunchMeals.length} repas',
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                if (_lunchMeals.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.restaurant_menu, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Aucun repas planifié pour le lunch',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                else
                  ..._lunchMeals.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> meal = entry.value;
                    return MealCard(
                      meal: meal,
                      onDelete: () => _removeLunchMeal(index),
                    );
                  }),

                const SizedBox(height: 20),
                
                // Section Dinner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Dinner:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                    Text(
                      '${_dinnerMeals.length} repas',
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                if (_dinnerMeals.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.dinner_dining, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Aucun repas planifié pour le dîner',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                else
                  ..._dinnerMeals.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> meal = entry.value;
                    return MealCard(
                      meal: meal,
                      onDelete: () => _removeDinnerMeal(index),
                    );
                  }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final Map<String, dynamic> meal;
  final VoidCallback onDelete;

  const MealCard({
    super.key,
    required this.meal,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Récupération sécurisée des données
    final String title = meal['mealTitle'] ?? meal['title'] ?? 'Repas sans titre';
    final String description = meal['description'] ?? 'Aucune description disponible';
    final String imageUrl = meal['imageUrl'] ?? meal['image'] ?? '';
    final String? calories = meal['calories']?.toString();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du repas
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: screenWidth * 0.25,
                      height: screenWidth * 0.25,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFA500)),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Erreur de chargement image: $error');
                        return Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
                        );
                      },
                    )
                  : Container(
                      width: screenWidth * 0.25,
                      height: screenWidth * 0.25,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
                    ),
            ),
            const SizedBox(width: 16),
            // Informations du repas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (calories != null && calories.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '$calories calories',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFFA500),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Bouton de suppression
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                // Confirmation avant suppression
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmer la suppression'),
                      content: Text('Êtes-vous sûr de vouloir supprimer "$title" ?'),
                      actions: [
                        TextButton(
                          child: const Text('Annuler'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            onDelete();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}