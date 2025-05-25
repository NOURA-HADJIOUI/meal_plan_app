// calendar.dart - Version corrigée
import 'package:flutter/material.dart';
import 'package:meal_plan_app/meal.dart';
import 'package:meal_plan_app/firebase_service.dart';
import 'dart:ui'; // Pour BackdropFilter

class CalendarApp extends StatelessWidget {
  final Meal meal;

  const CalendarApp({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'Inter',
      ),
      home: CalendarScreen(meal: meal),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  final Meal meal;

  const CalendarScreen({super.key, required this.meal});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int? selectedDay;
  DateTime currentDate = DateTime(2025, 4, 7);
  final MealFirebaseService _firebaseService = MealFirebaseService();
  bool _isLoading = false;

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
                CustomAppBar(mealTitle: widget.meal.title),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Affichage du repas sélectionné avec image et description
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: widget.meal.imageUrl.isNotEmpty
                                          ? Image.network(
                                              widget.meal.imageUrl,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                            loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder: (context, error, stackTrace) {
                                                // Si l'image réseau échoue, essayer comme asset local
                                                return Image.asset(
                                                  widget.meal.imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return const Center(
                                                      child: Icon(Icons.restaurant, 
                                                        color: Colors.grey, size: 30),
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          : const Center(
                                              child: Icon(Icons.restaurant, 
                                                color: Colors.grey, size: 30),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.meal.title,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Sélectionnez une date pour planifier ce repas',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Affichage de la description si elle existe
                              if (widget.meal.description != null && 
                                  widget.meal.description!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.orange.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 16,
                                            color: Colors.orange[700],
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Description',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.orange[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.meal.description!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
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
                          isLoading: _isLoading,
                          onCancel: () => Navigator.pop(context),
                          onOk: _handleOkPressed,
                          hasSelection: selectedDay != null,
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

  Future<void> _handleOkPressed() async {
    if (selectedDay == null) {
      _showSnackBar('Veuillez sélectionner une date', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final selectedDate = DateTime(
        currentDate.year,
        currentDate.month,
        selectedDay!,
      );

      // Passer toutes les informations du repas à Firebase
      final success = await _firebaseService.addScheduledMeal(
        mealTitle: widget.meal.title,
        selectedDate: selectedDate,
        imageUrl: widget.meal.imageUrl,
        description: widget.meal.description,
      );

      if (success) {
        _showSnackBar(
          'Repas "${widget.meal.title}" planifié pour le $selectedDay/${currentDate.month}/${currentDate.year}',
          Colors.green,
        );
        
        // Attendre un peu pour que l'utilisateur voie le message
        await Future.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          Navigator.pop(context, selectedDate);
        }
      } else {
        _showSnackBar('Erreur lors de l\'enregistrement du repas', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Erreur: ${e.toString()}', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String mealTitle;

  const CustomAppBar({super.key, required this.mealTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Planifier: $mealTitle',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 40), // Pour équilibrer la row
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

  List<String> get weekdays => ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  List<List<int>> getWeeksForMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    
    // Correction pour commencer la semaine le lundi (weekday 1)
    int startingWeekday = firstDay.weekday - 1; // 0 = lundi, 6 = dimanche
    
    final daysInMonth = lastDay.day;
    final weeks = <List<int>>[];
    var currentWeek = <int>[];
    
    // Ajouter les jours vides du début
    for (int i = 0; i < startingWeekday; i++) {
      currentWeek.add(0);
    }
    
    // Ajouter tous les jours du mois
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
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month - 1]; // Correction de l'index
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
  final bool isLoading;
  final bool hasSelection;

  const CalendarActions({
    super.key,
    required this.onCancel,
    required this.onOk,
    required this.isLoading,
    required this.hasSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: isLoading ? null : onCancel,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Annuler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: (isLoading || !hasSelection) ? null : onOk,
            style: TextButton.styleFrom(
              backgroundColor: (hasSelection && !isLoading) ? Colors.orange : Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Planifier',
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