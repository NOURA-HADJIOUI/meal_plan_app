// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const HistoryPage());
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal History',
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const History(),
    );
  }
}

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEDEDED)),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            onPressed: () => Navigator.pop(context),
            color: const Color(0xFF0F0F0F),
          ),
        ),
        title: const Text(
          'History',
          style: TextStyle(
            color: Color(0xFF0F0F0F),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.all(8),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec titre principal
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Text(
              'Meal History',
              style: TextStyle(
                color: const Color(0xFF1C1B1F),
                fontSize: 32,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
          
          // Liste des repas
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('scheduled_meals')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[400],
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Erreur de chargement',
                          style: TextStyle(
                            color: const Color(0xFF1C1B1F),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Vérifiez votre connexion internet',
                          style: TextStyle(
                            color: const Color(0xFFA09CAB),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1C1B1F),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          color: Colors.grey[400],
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun repas trouvé',
                          style: TextStyle(
                            color: const Color(0xFF1C1B1F),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Vos repas programmés apparaîtront ici',
                          style: TextStyle(
                            color: const Color(0xFFA09CAB),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    color: Color(0xFFEDEDED),
                  ),
                  itemBuilder: (context, index) {
                    var mealDoc = snapshot.data!.docs[index];
                    var mealData = mealDoc.data() as Map<String, dynamic>;
                    
                    return MealHistoryItem(
                      title: mealData['title'] ?? 'Repas sans nom',
                      description: mealData['description']?.isNotEmpty == true 
                          ? mealData['description'] 
                          : 'Délicieux repas',
                      imageUrl: mealData['imageUrl'] ?? '',
                      date: mealData['date'] != null 
                          ? (mealData['date'] as Timestamp).toDate()
                          : DateTime.now(),
                      day: mealData['day'] ?? DateTime.now().day,
                      month: mealData['month'] ?? DateTime.now().month,
                      year: mealData['year'] ?? DateTime.now().year,
                      weekday: mealData['weekday'] ?? DateTime.now().weekday,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      
      // Bottom Navigation
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
       
      ),
    );
  }

}

class MealHistoryItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final int day;
  final int month;
  final int year;
  final int weekday;

  const MealHistoryItem({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.day,
    required this.month,
    required this.year,
    required this.weekday,
  });

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 
      'Vendredi', 'Samedi', 'Dimanche'
    ];
    return weekdays[(weekday - 1) % 7];
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '$day ${_getMonthName(month)} $year';
    String displayDescription = description.isNotEmpty 
        ? description 
        : _getWeekdayName(weekday);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du repas
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty && imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
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
                  style: const TextStyle(
                    color: Color(0xFF1C1B1F),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  '$displayDescription • $formattedDate',
                  style: const TextStyle(
                    color: Color(0xFFA09CAB),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Indicateur ou action
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.chevron_right,
              color: const Color(0xFFA09CAB),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.restaurant,
        color: Colors.grey[400],
        size: 24,
      ),
    );
  }
}