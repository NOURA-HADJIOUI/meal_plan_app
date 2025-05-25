import 'package:flutter/material.dart';
import 'dart:ui'; // Pour BackdropFilter

void main() {
  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent, // Changé en transparent
        fontFamily: 'Inter',
      ),
      home: const CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int? selectedDay;
  DateTime currentDate = DateTime(2025, 4, 7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const CustomAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        CalendarWidget(
                          currentDate: currentDate,
                          selectedDay: selectedDay,
                          onDaySelected: (day) {
                            setState(() {
                              selectedDay = day;
                            });
                          },
                          onMonthChanged: (direction) {
                            setState(() {
                              currentDate = DateTime(
                                currentDate.year,
                                direction == 'next' 
                                    ? currentDate.month + 1 
                                    : currentDate.month - 1,
                                1,
                              );
                              selectedDay = null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        CalendarActions(
                          onCancel: () => Navigator.pop(context),
                          onOk: () {
                            if (selectedDay != null) {
                              // Créer un DateTime avec la date sélectionnée
                              final selectedDate = DateTime(
                                currentDate.year,
                                currentDate.month,
                                selectedDay!,
                              );
                              Navigator.pop(context, selectedDate);
                            } else {
                              // Aucune date sélectionnée, on peut fermer sans rien renvoyer
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
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


class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24), // Changé en blanc
           onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Spacer(),
          SizedBox(
            width: 40,
            height: 40,
          ),
        ],
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final DateTime currentDate;
  final int? selectedDay;
  final Function(int) onDaySelected;
  final Function(String) onMonthChanged;

  const CalendarWidget({
    super.key,
    required this.currentDate,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onMonthChanged,
  });

  List<String> get weekdays => ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  List<List<int>> getWeeksForMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    
    int startingWeekday = firstDay.weekday; // 1 (lundi) à 7 (dimanche)
    // Ajustement pour commencer par samedi (6)
    startingWeekday = (startingWeekday + 5) % 7;
    
    final daysInMonth = lastDay.day;
    final weeks = <List<int>>[];
    var currentWeek = <int>[];
    
    // Ajouter les jours du mois précédent si nécessaire
    for (int i = 0; i < startingWeekday; i++) {
      currentWeek.add(0);
    }
    
    for (int day = 1; day <= daysInMonth; day++) {
      currentWeek.add(day);
      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = <int>[];
      }
    }
    
    // Compléter la dernière semaine si nécessaire
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(0);
      }
      weeks.add(currentWeek);
    }
    
    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    final weeks = getWeeksForMonth(currentDate);
    final monthName = _getMonthName(currentDate.month);

    return Container(
      width: 380,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month header with navigation
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 24),
                  onPressed: () => onMonthChanged('prev'),
                ),
                const SizedBox(width: 8),
                Text(
                  '$monthName ${currentDate.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 24),
                  onPressed: () => onMonthChanged('next'),
                ),
              ],
            ),
          ),

          // Weekday headers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: weekdays.map((day) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Calendar days
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: weeks.map((week) {
                return Row(
                  children: week.map((day) {
                    return Expanded(
                      child: _DayCell(
                        day: day,
                        isSelected: day != 0 && day == selectedDay,
                        isToday: day == DateTime.now().day && 
                                 currentDate.month == DateTime.now().month &&
                                 currentDate.year == DateTime.now().year,
                        onTap: () {
                          if (day != 0) {
                            onDaySelected(day);
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month ];
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (day == 0) return const SizedBox(height: 40);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade100 : null,
          border: isToday 
              ? Border.all(color: Colors.orange, width: 1.5) 
              : null,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.orange : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onOk;

  const CalendarActions({
    super.key,
    required this.onCancel,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: onOk,
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}