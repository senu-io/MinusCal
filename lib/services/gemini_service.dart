import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pantry_item.dart';
import '../models/meal_preference.dart';
import '../models/recipe.dart';

class GeminiService {
  static const String _geminiModel = 'gemini-2.0-flash';
  static const String _geminiFallbackModel = 'gemini-1.5-flash';

  Future<List<Recipe>> generateRecipes({
    required List<PantryItem> pantry,
    required MealPreference preference,
    String? apiKey,
  }) async {
    final availableAppliances = pantry
        .where((i) => i.category == ItemCategory.appliances && i.isAvailable)
        .map((i) => i.name)
        .toList();

    final availableIngredients = pantry
        .where((i) => i.category != ItemCategory.appliances && i.isAvailable)
        .map((i) => i.name)
        .toList();

    if (availableIngredients.isEmpty) {
      throw Exception('Please select at least 1 or 2 ingredients in your pantry.');
    }

    // If an API key is provided, invoke live Gemini API
    if (apiKey != null && apiKey.trim().isNotEmpty) {
      try {
        return await _callGeminiApi(
          apiKey: apiKey.trim(),
          model: _geminiModel,
          appliances: availableAppliances,
          ingredients: availableIngredients,
          preference: preference,
        );
      } catch (e) {
        // Retry with fallback model
        try {
          return await _callGeminiApi(
            apiKey: apiKey.trim(),
            model: _geminiFallbackModel,
            appliances: availableAppliances,
            ingredients: availableIngredients,
            preference: preference,
          );
        } catch (innerError) {
          throw Exception('Gemini API Error: $innerError');
        }
      }
    }

    // If no API key configured, use our intelligent local Chef Generator
    await Future.delayed(const Duration(milliseconds: 1200)); // natural UX transition
    return _generateSmartLocalMockRecipes(
      appliances: availableAppliances,
      ingredients: availableIngredients,
      preference: preference,
    );
  }

  Future<List<Recipe>> _callGeminiApi({
    required String apiKey,
    required String model,
    required List<String> appliances,
    required List<String> ingredients,
    required MealPreference preference,
  }) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
    );

    final prompt = _buildPrompt(appliances, ingredients, preference);

    final requestBody = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "responseMimeType": "application/json",
        "temperature": 0.7,
        "responseSchema": {
          "type": "OBJECT",
          "properties": {
            "recipes": {
              "type": "ARRAY",
              "items": {
                "type": "OBJECT",
                "properties": {
                  "title": {"type": "STRING"},
                  "description": {"type": "STRING"},
                  "prepTimeMinutes": {"type": "INTEGER"},
                  "cookTimeMinutes": {"type": "INTEGER"},
                  "difficulty": {"type": "STRING"},
                  "servings": {"type": "INTEGER"},
                  "nutrition": {
                    "type": "OBJECT",
                    "properties": {
                      "calories": {"type": "INTEGER"},
                      "proteinGrams": {"type": "INTEGER"},
                      "carbsGrams": {"type": "INTEGER"},
                      "fatGrams": {"type": "INTEGER"},
                      "fiberGrams": {"type": "INTEGER"}
                    },
                    "required": ["calories", "proteinGrams", "carbsGrams", "fatGrams"]
                  },
                  "appliances": {
                    "type": "ARRAY",
                    "items": {"type": "STRING"}
                  },
                  "ingredientsUsed": {
                    "type": "ARRAY",
                    "items": {"type": "STRING"}
                  },
                  "missingOrOptional": {
                    "type": "ARRAY",
                    "items": {"type": "STRING"}
                  },
                  "instructions": {
                    "type": "ARRAY",
                    "items": {"type": "STRING"}
                  },
                  "chefTip": {"type": "STRING"}
                },
                "required": [
                  "title",
                  "description",
                  "prepTimeMinutes",
                  "cookTimeMinutes",
                  "difficulty",
                  "servings",
                  "nutrition",
                  "appliances",
                  "ingredientsUsed",
                  "instructions"
                ]
              }
            }
          },
          "required": ["recipes"]
        }
      }
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200) {
      throw Exception('Status ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final candidates = data['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('No response generated by Gemini.');
    }

    final text = candidates[0]['content']['parts'][0]['text'] as String;
    final parsed = jsonDecode(text) as Map<String, dynamic>;
    final rawList = parsed['recipes'] as List<dynamic>? ?? [];

    return rawList.map((r) => Recipe.fromJson(r as Map<String, dynamic>)).toList();
  }

  String _buildPrompt(
    List<String> appliances,
    List<String> ingredients,
    MealPreference preference,
  ) {
    return '''
You are MinusCal, a culinary recipe and nutrition planner.
Generate ${preference.recipeCount} practical recipes based on what the user has in their kitchen.

USER KITCHEN INVENTORY:
- Appliances: ${appliances.isEmpty ? 'Basic Stovetop' : appliances.join(', ')}
- Available items: ${ingredients.join(', ')}

PARAMETERS:
- Meal: ${preference.mealType.label}
- Cooking time: ${preference.complexity.label}
- Goal: ${preference.fitnessGoal.label}
- Servings: ${preference.servings}
- Strict mode: ${preference.strictPantryOnly ? 'Use only listed items and water.' : 'Prioritize listed items; up to two optional items in missingOrOptional.'}

REQUIREMENTS:
1. Provide nutritional estimates per serving (Calories, Protein, Carbs, Fat, Fiber).
2. Specify which appliances are used.
3. List ingredients in ingredientsUsed (from user items) and missingOrOptional (if any).
4. Provide numbered step-by-step instructions.
5. Provide a brief cooking note in chefTip.
''';
  }

  List<Recipe> _generateSmartLocalMockRecipes({
    required List<String> appliances,
    required List<String> ingredients,
    required MealPreference preference,
  }) {
    final hasChicken = ingredients.any((i) => i.toLowerCase().contains('chicken'));
    final hasEggs = ingredients.any((i) => i.toLowerCase().contains('egg'));
    final hasRice = ingredients.any((i) => i.toLowerCase().contains('rice'));
    final hasPasta = ingredients.any((i) => i.toLowerCase().contains('pasta'));
    final hasTomato = ingredients.any((i) => i.toLowerCase().contains('tomato'));
    final hasCheese = ingredients.any((i) => i.toLowerCase().contains('cheese'));
    final hasAirFryer = appliances.any((a) => a.toLowerCase().contains('air fryer'));
    final mainAppliance = appliances.isNotEmpty ? appliances.first : 'Gas Cooker / Stovetop';

    final List<Recipe> recipes = [];

    // Recipe 1: Primary Protein / Quick Dish
    if (hasChicken && hasRice) {
      recipes.add(
        Recipe(
          id: 'rec_1',
          title: hasAirFryer ? 'Crispy Spiced Chicken Rice Bowl' : 'Golden Garlic Herb Chicken & Rice',
          description:
              'Succulent sliced chicken breast seasoned with garlic and paprika served over fluffy aromatic rice.',
          prepTimeMinutes: 10,
          cookTimeMinutes: 20,
          difficulty: 'Easy',
          servings: preference.servings,
          nutrition: NutritionInfo(
            calories: 510,
            proteinGrams: 44,
            carbsGrams: 52,
            fatGrams: 11,
            fiberGrams: 4,
          ),
          appliances: [if (hasAirFryer) 'Air Fryer' else mainAppliance],
          ingredientsUsed: [
            'Chicken Breast',
            'White / Basmati Rice',
            if (ingredients.contains('Garlic')) 'Garlic',
            if (ingredients.contains('Onions')) 'Onions',
            'Salt',
            'Black Pepper',
            'Olive Oil / Cooking Oil',
          ],
          missingOrOptional: ['Fresh Parsley garnish'],
          instructions: [
            'Rinse the rice under cold water, then cook on stovetop or rice cooker with a pinch of salt until tender.',
            'Slice chicken breast into even cutlets. Rub with olive oil, smoked paprika, salt, pepper, and minced garlic.',
            if (hasAirFryer)
              'Preheat Air Fryer to 200°C (390°F). Cook chicken for 12–14 minutes, flipping halfway until golden.'
            else
              'Heat a skillet over medium-high heat with olive oil. Sear chicken for 6–7 minutes per side until internal temp is 74°C.',
            'Let chicken rest for 3 minutes, then slice diagonally. Serve over the warm rice bowl.',
          ],
          chefTip: 'Resting the chicken allows juices to redistribute so every bite stays juicy.',
        ),
      );
    } else if (hasEggs) {
      recipes.add(
        Recipe(
          id: 'rec_1_egg',
          title: 'Savory Mediterranean Scramble Skillet',
          description: 'Fluffy protein-packed eggs scrambled with garlic, onions, and melted cheese.',
          prepTimeMinutes: 5,
          cookTimeMinutes: 10,
          difficulty: 'Quick & Easy',
          servings: preference.servings,
          nutrition: NutritionInfo(
            calories: 360,
            proteinGrams: 28,
            carbsGrams: 8,
            fatGrams: 24,
            fiberGrams: 2,
          ),
          appliances: [mainAppliance],
          ingredientsUsed: [
            'Eggs',
            if (hasTomato) 'Tomatoes',
            if (hasCheese) 'Cheddar / Mozzarella',
            'Olive Oil / Cooking Oil',
            'Salt',
            'Black Pepper',
          ],
          missingOrOptional: ['Toasted sourdough slice'],
          instructions: [
            'Whisk eggs vigorously with salt, black pepper, and a splash of milk or water.',
            'Heat olive oil in a pan over medium heat; sauté diced tomatoes and onions for 2 minutes.',
            'Pour in the beaten eggs and gently push curds from edges to center with a spatula until soft and creamy.',
            if (hasCheese) 'Sprinkle cheese on top and cover for 30 seconds to melt.',
          ],
          chefTip: 'Remove from heat slightly before fully set; residual pan heat finishes cooking the curds.',
        ),
      );
    } else {
      recipes.add(
        Recipe(
          id: 'rec_1_generic',
          title: 'Pantry Chef Sauté & Grain Plate',
          description: 'A balanced nutrient-dense sauté built with your available kitchen staples.',
          prepTimeMinutes: 10,
          cookTimeMinutes: 15,
          difficulty: 'Easy',
          servings: preference.servings,
          nutrition: NutritionInfo(
            calories: 420,
            proteinGrams: 18,
            carbsGrams: 58,
            fatGrams: 12,
            fiberGrams: 6,
          ),
          appliances: [mainAppliance],
          ingredientsUsed: ingredients.take(5).toList(),
          missingOrOptional: [],
          instructions: [
            'Prep and wash all available ingredients into uniform bite-sized pieces.',
            'Warm cooking oil in your cookware over medium heat.',
            'Add aromatics first, followed by heartier vegetables and grains.',
            'Season with salt, pepper, and available spices. Sauté until tender-crisp.',
          ],
          chefTip: 'Toast dry spices in warm oil for 30 seconds first to unlock maximum aroma.',
        ),
      );
    }

    // Recipe 2: Comfort / Carb or Vegetable Fusion
    if (hasPasta && hasTomato) {
      recipes.add(
        Recipe(
          id: 'rec_2',
          title: 'Rustic Garlic Tomato Pasta Pomodoro',
          description: 'Al dente pasta tossed in an aromatic tomato garlic sauce with olive oil.',
          prepTimeMinutes: 5,
          cookTimeMinutes: 15,
          difficulty: 'Easy',
          servings: preference.servings,
          nutrition: NutritionInfo(
            calories: 480,
            proteinGrams: 16,
            carbsGrams: 78,
            fatGrams: 10,
            fiberGrams: 5,
          ),
          appliances: [mainAppliance],
          ingredientsUsed: [
            'Pasta / Noodles',
            'Tomatoes',
            'Garlic',
            'Olive Oil / Cooking Oil',
            'Salt',
            'Black Pepper',
            if (hasCheese) 'Cheddar / Mozzarella',
          ],
          missingOrOptional: ['Fresh basil leaves'],
          instructions: [
            'Bring a large pot of salted water to a rolling boil and cook pasta until al dente.',
            'In a wide skillet, heat olive oil and gently sauté crushed garlic until fragrant (do not burn).',
            'Add diced tomatoes, salt, pepper, and simmer for 8 minutes until sauce thickens.',
            'Reserve 1/4 cup pasta cooking water, toss drained pasta into the sauce with pasta water.',
            if (hasCheese) 'Top with grated cheese before serving.',
          ],
          chefTip: 'Starchy pasta cooking water is the secret to getting a glossy, restaurant-style sauce.',
        ),
      );
    } else {
      recipes.add(
        Recipe(
          id: 'rec_2_veggie',
          title: 'High-Energy Golden Vegetable Hash',
          description: 'Crispy diced potatoes and vegetables pan-seared with smoked spices.',
          prepTimeMinutes: 10,
          cookTimeMinutes: 18,
          difficulty: 'Easy',
          servings: preference.servings,
          nutrition: NutritionInfo(
            calories: 390,
            proteinGrams: 12,
            carbsGrams: 64,
            fatGrams: 9,
            fiberGrams: 7,
          ),
          appliances: [mainAppliance],
          ingredientsUsed: [
            if (ingredients.contains('Potatoes')) 'Potatoes',
            if (ingredients.contains('Onions')) 'Onions',
            'Olive Oil / Cooking Oil',
            'Smoked Paprika',
            'Salt',
            'Black Pepper',
          ],
          missingOrOptional: ['Avocado slices'],
          instructions: [
            'Dice potatoes into small 1/2-inch cubes so they cook through quickly.',
            'Heat olive oil in pan; sear potatoes for 10 minutes undisturbed to form a golden crust.',
            'Toss with diced onions, smoked paprika, salt, and pepper.',
            'Cook for another 5 minutes until fork-tender and crispy.',
          ],
          chefTip: 'Don’t stir potatoes for the first 5 minutes to allow a crispy sear to form.',
        ),
      );
    }

    // Recipe 3: Gym / Protein Booster or Healthy Quick Fix
    recipes.add(
      Recipe(
        id: 'rec_3',
        title: 'MinusCal Power Recovery Plate',
        description:
            'A focused fitness meal formulated for clean macronutrients, muscle preservation, and sustained satiety.',
        prepTimeMinutes: 8,
        cookTimeMinutes: 12,
        difficulty: 'Quick',
        servings: preference.servings,
        nutrition: NutritionInfo(
          calories: preference.fitnessGoal == FitnessGoal.lowCalorie ? 320 : 540,
          proteinGrams: 42,
          carbsGrams: preference.fitnessGoal == FitnessGoal.lowCarb ? 12 : 48,
          fatGrams: 14,
          fiberGrams: 5,
        ),
        appliances: [mainAppliance],
        ingredientsUsed: ingredients.take(6).toList(),
        missingOrOptional: ['Lemon squeeze'],
        instructions: [
          'Pre-heat cookware with a light coat of cooking oil.',
          'Cook protein sources first to target internal temperature.',
          'Add vegetables towards the end to retain crunch and micronutrients.',
          'Plate with calculated portion sizes for your ${preference.fitnessGoal.label}.',
        ],
        chefTip:
            'Pairing high-protein foods with fiber slows gastric emptying and keeps you full for hours on a deficit.',
      ),
    );

    return recipes;
  }
}
