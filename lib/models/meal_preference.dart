enum MealType {
  any('Any Meal', 'Any delicious meal'),
  breakfast('Breakfast', 'Morning energy & fresh start'),
  lunch('Lunch', 'Midday balanced fuel'),
  dinner('Dinner', 'Satisfying evening plate'),
  snack('Snack', 'Quick bite or light treat'),
  gym('Gym / High Protein', 'Muscle recovery & high protein'),
  dessert('Dessert', 'Sweet & healthy indulgence');

  final String label;
  final String description;
  const MealType(this.label, this.description);
}

enum MealComplexity {
  quick('Quick & Easy', '< 15 mins, minimal cleanup'),
  balanced('Balanced', '15–30 mins standard cook'),
  gourmet('Gourmet / Elaborate', '30+ mins deeper flavor');

  final String label;
  final String subtitle;
  const MealComplexity(this.label, this.subtitle);
}

enum FitnessGoal {
  balanced('Balanced Diet', 'Even split of macros'),
  highProtein('High Protein', 'Maximize protein for muscle synthesis'),
  lowCalorie('Calorie Deficit', 'Filling volume with lower calories'),
  lowCarb('Low Carb / Keto', 'High healthy fats, minimal carbs');

  final String label;
  final String subtitle;
  const FitnessGoal(this.label, this.subtitle);
}

class MealPreference {
  MealType mealType;
  MealComplexity complexity;
  FitnessGoal fitnessGoal;
  int servings;
  bool strictPantryOnly;
  int recipeCount;

  MealPreference({
    this.mealType = MealType.any,
    this.complexity = MealComplexity.balanced,
    this.fitnessGoal = FitnessGoal.balanced,
    this.servings = 2,
    this.strictPantryOnly = false,
    this.recipeCount = 3,
  });

  Map<String, dynamic> toJson() => {
        'mealType': mealType.name,
        'complexity': complexity.name,
        'fitnessGoal': fitnessGoal.name,
        'servings': servings,
        'strictPantryOnly': strictPantryOnly,
        'recipeCount': recipeCount,
      };
}
