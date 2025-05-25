import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAddMealPage extends StatefulWidget {
  const AdminAddMealPage({super.key});

  @override
  State<AdminAddMealPage> createState() => _AdminAddMealPageState();
}

class _AdminAddMealPageState extends State<AdminAddMealPage> {
  final _formKey = GlobalKey<FormState>();
  final _ingredients = <String>[];

  // Champs
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final instructionController = TextEditingController();
  final categoryController = TextEditingController();
  final photoUrlController = TextEditingController();
  final ratingController = TextEditingController();
  final commentController = TextEditingController();

  final ingredientController = TextEditingController();

  void addIngredient() {
    if (ingredientController.text.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(ingredientController.text.trim());
        ingredientController.clear();
      });
    }
  }

  void removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

void submitForm() async {
  if (_formKey.currentState!.validate()) {
    final mealData = {
      'id': idController.text.trim(),
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'ingredients': _ingredients,
      'instructions': instructionController.text.trim(),
      'category': categoryController.text.trim(),
      'photo': photoUrlController.text.trim(),
      'rating': double.tryParse(ratingController.text.trim()) ?? 0.0,
      'comments': commentController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('meals').add(mealData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Repas enregistré avec succès dans Firestore !')),
      );

      _formKey.currentState!.reset();
      setState(() => _ingredients.clear());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
      );
    }
  }
}


  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    instructionController.dispose();
    categoryController.dispose();
    photoUrlController.dispose();
    ratingController.dispose();
    commentController.dispose();
    ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un repas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(idController, 'ID du repas'),
              buildTextField(nameController, 'Nom du repas'),
              buildTextField(descriptionController, 'Description'),
              const SizedBox(height: 16),

              // Ingrédients
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: ingredientController,
                      decoration: const InputDecoration(labelText: 'Ingrédient'),
                    ),
                  ),
                  IconButton(
                    onPressed: addIngredient,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              if (_ingredients.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _ingredients.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_ingredients[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => removeIngredient(index),
                      ),
                    );
                  },
                ),

              buildTextField(instructionController, 'Instructions', maxLines: 4),
              buildTextField(categoryController, 'Catégorie'),
              buildTextField(photoUrlController, 'URL de la photo'),
              buildTextField(ratingController, 'Note (0.0 - 5.0)', inputType: TextInputType.number),
              buildTextField(commentController, 'Commentaires', maxLines: 2),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Enregistrer le repas'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: inputType,
        decoration: InputDecoration(labelText: label),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }
}
