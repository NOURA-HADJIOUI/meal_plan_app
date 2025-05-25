import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> getMealPlans(String userId) async {
  final mealPlansSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('mealPlans')
      .orderBy('date') // si tu ajoutes un champ 'date' dans chaque doc
      .get();

  return mealPlansSnapshot.docs.map((doc) {
    return {
      'date': doc.id,
      'breakfast': doc['breakfast'],
      'lunch': doc['lunch'],
      'dinner': doc['dinner'],
    };
  }).toList();
}
class WeeklyMealPlan extends StatelessWidget {
  final String userId;

  const WeeklyMealPlan({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getMealPlans(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun repas planifié.'));
        }

        final meals = snapshot.data!;

        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text('Jour : ${meal['date']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Petit déjeuner : ${meal['breakfast']}'),
                    Text('Déjeuner : ${meal['lunch']}'),
                    Text('Dîner : ${meal['dinner']}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
