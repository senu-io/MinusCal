class NutritionInfo {
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final int? fiberGrams;

  NutritionInfo({
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    this.fiberGrams,
  });

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'proteinGrams': proteinGrams,
        'carbsGrams': carbsGrams,
        'fatGrams': fatGrams,
        'fiberGrams': fiberGrams,
      };

  factory NutritionInfo.fromJson(Map<String, dynamic> json) => NutritionInfo(
        calories: (json['calories'] as num?)?.toInt() ?? 0,
        proteinGrams: (json['proteinGrams'] as num?)?.toInt() ?? 0,
        carbsGrams: (json['carbsGrams'] as num?)?.toInt() ?? 0,
        fatGrams: (json['fatGrams'] as num?)?.toInt() ?? 0,
        fiberGrams: (json['fiberGrams'] as num?)?.toInt(),
      );
}

class Recipe {
  final String id;
  final String title;
  final String description;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final String difficulty;
  final int servings;
  final NutritionInfo nutrition;
  final List<String> appliances;
  final List<String> ingredientsUsed;
  final List<String> missingOrOptional;
  final List<String> instructions;
  final String? chefTip;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.servings,
    required this.nutrition,
    required this.appliances,
    required this.ingredientsUsed,
    required this.missingOrOptional,
    required this.instructions,
    this.chefTip,
    this.isFavorite = false,
  });

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'prepTimeMinutes': prepTimeMinutes,
        'cookTimeMinutes': cookTimeMinutes,
        'difficulty': difficulty,
        'servings': servings,
        'nutrition': nutrition.toJson(),
        'appliances': appliances,
        'ingredientsUsed': ingredientsUsed,
        'missingOrOptional': missingOrOptional,
        'instructions': instructions,
        'chefTip': chefTip,
        'isFavorite': isFavorite,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: json['title'] as String? ?? 'Untitled Recipe',
        description: json['description'] as String? ?? '',
        prepTimeMinutes: (json['prepTimeMinutes'] as num?)?.toInt() ?? 10,
        cookTimeMinutes: (json['cookTimeMinutes'] as num?)?.toInt() ?? 20,
        difficulty: json['difficulty'] as String? ?? 'Easy',
        servings: (json['servings'] as num?)?.toInt() ?? 2,
        nutrition: json['nutrition'] is Map<String, dynamic>
            ? NutritionInfo.fromJson(json['nutrition'] as Map<String, dynamic>)
            : NutritionInfo(calories: 450, proteinGrams: 30, carbsGrams: 45, fatGrams: 15),
        appliances: (json['appliances'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        ingredientsUsed:
            (json['ingredientsUsed'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        missingOrOptional:
            (json['missingOrOptional'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        instructions:
            (json['instructions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        chefTip: json['chefTip'] as String?,
        isFavorite: json['isFavorite'] as bool? ?? false,
      );
}
