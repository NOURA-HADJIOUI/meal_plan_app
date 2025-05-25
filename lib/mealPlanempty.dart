import 'package:flutter/material.dart';

void main() {
  runApp(const MealPlanningApp());
}

class MealPlanningApp extends StatelessWidget {
  const MealPlanningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const MealPlanningScreen(),
    );
  }
}

class MealPlanningScreen extends StatefulWidget {
  const MealPlanningScreen({super.key});

  @override
  State<MealPlanningScreen> createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<MealPlanningScreen> {
  int? _selectedDay;
  final List<Map<String, dynamic>> _days = [
    {'number': '01', 'name': 'Tue'},
    {'number': '02', 'name': 'Wed'},
    {'number': '03', 'name': 'Thu'},
    {'number': '04', 'name': 'Fri'},
    {'number': '05', 'name': 'Sat'},
    {'number': '06', 'name': 'Sun'},
    {'number': '07', 'name': 'Mon'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar (simplifiée)
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(
                      color: Color(0xFF0F0F0F),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.battery_std, color: Colors.black, size: 20),
                ],
              ),
            ),
            
            // Titre
            const Text(
              'Meal Planning',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontFamily: 'Inknut Antiqua',
                fontWeight: FontWeight.w400,
              ),
            ),
            
            // En-tête avec mois et semaine
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    'April 2025',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'View',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Jours de la semaine avec scroll horizontal
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: _days.map((day) {
                  bool isSelected = _selectedDay == _days.indexOf(day);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = _days.indexOf(day);
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Numéro du jour avec cercle de sélection
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFA500) : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                day['number'],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Abel',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Nom du jour
                          Text(
                            day['name'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Playfair Display',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const Divider(thickness: 1, height: 32),
            
            // Section "Non plan yet"
            const Expanded(
              child: Center(
                child: Text(
                  'Non plan yet',
                  style: TextStyle(
                    color: Color(0xFFA7AAAC),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            // Barre de navigation inférieure (simplifiée)
            Container(
              height: 21,
              margin: const EdgeInsets.only(bottom: 8),
              child: Center(
                child: Container(
                  width: 140,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1B1F),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}