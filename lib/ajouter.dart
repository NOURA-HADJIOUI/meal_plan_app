import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:table_calendar/table_calendar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ajouter());
}

class ajouter extends StatelessWidget {
  final String userId = "demoUser123";

  const ajouter({super.key}); // Remplace par l'ID utilisateur réel

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planificateur de repas',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: CalendarMealSelector(userId: userId),
    );
  }
}

class CalendarMealSelector extends StatefulWidget {
  final String userId;
  const CalendarMealSelector({super.key, required this.userId});

  @override
  _CalendarMealSelectorState createState() => _CalendarMealSelectorState();
}

class _CalendarMealSelectorState extends State<CalendarMealSelector> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sélectionnez un jour')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              final formattedDate = _selectedDay.toIso8601String().split('T').first;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddMealPage(
                    userId: widget.userId,
                    selectedDate: formattedDate,
                  ),
                ),
              );
            },
            child: Text("Ajouter / Modifier les repas"),
          )
        ],
      ),
    );
  }
}

class AddMealPage extends StatefulWidget {
  final String userId;
  final String selectedDate;

  const AddMealPage({super.key, required this.userId, required this.selectedDate});

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final breakfastController = TextEditingController();
  final lunchController = TextEditingController();
  final dinnerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMealData();
  }

  Future<void> _loadMealData() async {
    try {
      print("Chargement des repas pour ${widget.selectedDate}");
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('mealPlans')
          .doc(widget.selectedDate)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          breakfastController.text = data['breakfast'] ?? '';
          lunchController.text = data['lunch'] ?? '';
          dinnerController.text = data['dinner'] ?? '';
        }
      } else {
        print("Aucun repas trouvé pour cette date.");
      }
    } catch (e) {
      print('Erreur lors du chargement des repas : $e');
    }
  }

 Future<void> saveMealPlan() async {
  print(">>> Enregistrement lancé pour la date : ${widget.selectedDate}");
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('mealPlans')
        .doc(widget.selectedDate)
        .set({
          'breakfast': breakfastController.text,
          'lunch': lunchController.text,
          'dinner': dinnerController.text,
          'date': widget.selectedDate,
        });
    print(">>> Repas enregistré avec succès !");
    Navigator.pop(context);
  } catch (e) {
    print(">>> Erreur lors de l'enregistrement : $e");
  }
}


  Future<void> deleteMealPlan() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('mealPlans')
        .doc(widget.selectedDate)
        .delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Repas du ${widget.selectedDate}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: breakfastController, decoration: InputDecoration(labelText: "Petit-déjeuner")),
            TextField(controller: lunchController, decoration: InputDecoration(labelText: "Déjeuner")),
            TextField(controller: dinnerController, decoration: InputDecoration(labelText: "Dîner")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveMealPlan, child: Text("Enregistrer")),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: deleteMealPlan,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text("Supprimer ce repas", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
