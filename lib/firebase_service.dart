// firebase_service.dart - Version complète pour enregistrer tous les détails du repas
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_plan_app/meal.dart';

class MealFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'scheduled_meals';

  // Méthode pour ajouter un repas planifié avec tous ses détails
  Future<bool> addScheduledMeal({
    required String mealTitle,
    required DateTime selectedDate,
    required String imageUrl,
    String? description,
  }) async {
    try {
      // Créer un identifiant unique basé sur la date (format: yyyy-MM-dd)
      final dateKey = '${selectedDate.year.toString().padLeft(4, '0')}-'
          '${selectedDate.month.toString().padLeft(2, '0')}-'
          '${selectedDate.day.toString().padLeft(2, '0')}';

      // Préparer les données à enregistrer
      final mealData = {
        'title': mealTitle,
        'date': Timestamp.fromDate(selectedDate),
        'dateKey': dateKey, // Pour faciliter les requêtes par date
        'imageUrl': imageUrl,
        'description': description ?? '', // Enregistrer une chaîne vide si null
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        // Informations additionnelles utiles
        'year': selectedDate.year,
        'month': selectedDate.month,
        'day': selectedDate.day,
        'weekday': selectedDate.weekday,
      };

      // Enregistrer dans Firestore
      await _firestore
          .collection(_collection)
          .doc(dateKey) // Utiliser la date comme ID pour éviter les doublons
          .set(mealData, SetOptions(merge: true)); // merge: true pour mettre à jour si existe déjà

      print('Repas enregistré avec succès: $mealTitle pour le $dateKey');
      return true;

    } catch (e) {
      print('Erreur lors de l\'enregistrement du repas: $e');
      return false;
    }
  }

  // Méthode alternative pour enregistrer avec un ID automatique (permet plusieurs repas par jour)
  Future<bool> addScheduledMealWithAutoId({
    required String mealTitle,
    required DateTime selectedDate,
    required String imageUrl,
    String? description,
  }) async {
    try {
      final dateKey = '${selectedDate.year.toString().padLeft(4, '0')}-'
          '${selectedDate.month.toString().padLeft(2, '0')}-'
          '${selectedDate.day.toString().padLeft(2, '0')}';

      final mealData = {
        'title': mealTitle,
        'date': Timestamp.fromDate(selectedDate),
        'dateKey': dateKey,
        'imageUrl': imageUrl,
        'description': description ?? '',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'year': selectedDate.year,
        'month': selectedDate.month,
        'day': selectedDate.day,
        'weekday': selectedDate.weekday,
      };

      // Utiliser add() au lieu de set() pour générer un ID automatique
      final docRef = await _firestore
          .collection(_collection)
          .add(mealData);

      print('Repas enregistré avec ID: ${docRef.id} - $mealTitle pour le $dateKey');
      return true;

    } catch (e) {
      print('Erreur lors de l\'enregistrement du repas: $e');
      return false;
    }
  }

  // Méthode pour récupérer les repas planifiés d'une date spécifique
  Future<List<Map<String, dynamic>>> getMealsForDate(DateTime date) async {
    try {
      final dateKey = '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';

      final querySnapshot = await _firestore
          .collection(_collection)
          .where('dateKey', isEqualTo: dateKey)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Ajouter l'ID du document
        return data;
      }).toList();

    } catch (e) {
      print('Erreur lors de la récupération des repas: $e');
      return [];
    }
  }

  // Méthode pour récupérer tous les repas planifiés d'un mois
  Future<List<Map<String, dynamic>>> getMealsForMonth(int year, int month) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

      final querySnapshot = await _firestore
          .collection(_collection)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

    } catch (e) {
      print('Erreur lors de la récupération des repas du mois: $e');
      return [];
    }
  }

  // Méthode pour supprimer un repas planifié
  Future<bool> deleteScheduledMeal(String documentId) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(documentId)
          .delete();

      print('Repas supprimé avec succès: $documentId');
      return true;

    } catch (e) {
      print('Erreur lors de la suppression du repas: $e');
      return false;
    }
  }

  // Méthode pour mettre à jour un repas planifié
  Future<bool> updateScheduledMeal({
    required String documentId,
    String? mealTitle,
    DateTime? selectedDate,
    String? imageUrl,
    String? description,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'updatedAt': Timestamp.now(),
      };

      if (mealTitle != null) updateData['title'] = mealTitle;
      if (imageUrl != null) updateData['imageUrl'] = imageUrl;
      if (description != null) updateData['description'] = description;
      
      if (selectedDate != null) {
        final dateKey = '${selectedDate.year.toString().padLeft(4, '0')}-'
            '${selectedDate.month.toString().padLeft(2, '0')}-'
            '${selectedDate.day.toString().padLeft(2, '0')}';
        
        updateData.addAll({
          'date': Timestamp.fromDate(selectedDate),
          'dateKey': dateKey,
          'year': selectedDate.year,
          'month': selectedDate.month,
          'day': selectedDate.day,
          'weekday': selectedDate.weekday,
        });
      }

      await _firestore
          .collection(_collection)
          .doc(documentId)
          .update(updateData);

      print('Repas mis à jour avec succès: $documentId');
      return true;

    } catch (e) {
      print('Erreur lors de la mise à jour du repas: $e');
      return false;
    }
  }

  // Méthode pour convertir un document Firestore en objet Meal
  Meal documentToMeal(Map<String, dynamic> data) {
    return Meal(
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description']?.isEmpty == true ? null : data['description'],
    );
  }

  // Méthode pour obtenir un stream des repas planifiés (pour mise à jour en temps réel)
  Stream<List<Map<String, dynamic>>> getMealsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
}