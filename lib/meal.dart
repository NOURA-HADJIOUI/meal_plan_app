// meal.dart - Classes manquantes
class Meal {
  final String title;
  final String imageUrl;
  final Recipe? recipe;

  Meal({
    required this.title,
    required this.imageUrl,
    this.recipe, required String description,
  });

  get description => null;
}

class Recipe {
  final String title;
  final String imageUrl;
  final String quantity;
  final double rating;
  final int reviewCount;
  final List<String> steps;
  final List<Ingredient> ingredients;
  final String difficulty;
  final String time;
  final String calories;
  final String description;
  final List<Review> reviews;

  Recipe({
    required this.title,
    required this.imageUrl,
    required this.quantity,
    required this.rating,
    required this.reviewCount,
    required this.steps,
    required this.ingredients,
    required this.difficulty,
    required this.time,
    required this.calories,
    required this.description,
    required this.reviews,
  });
}

class Ingredient {
  final String name;
  final String imageUrl;
  final String quantity;

  Ingredient({
    required this.name,
    required this.imageUrl,
    required this.quantity,
  });
}

class Review {
  final String userName;
  final String userImage;
  final String date;
  final double rating;
  final String comment;

  Review({
    required this.userName,
    required this.userImage,
    required this.date,
    required this.rating,
    required this.comment,
  });
}