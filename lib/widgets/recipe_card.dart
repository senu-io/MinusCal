import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../theme/app_theme.dart';
import 'macro_badge.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and favorite button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.text,
                        height: 1.25,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: recipe.isFavorite ? AppTheme.support : AppTheme.textMuted,
                      size: 20,
                    ),
                    onPressed: onToggleFavorite,
                    tooltip: recipe.isFavorite ? 'Remove from saved' : 'Save recipe',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                recipe.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textQuiet,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Time, difficulty, servings row
              Row(
                children: [
                  Text(
                    '${recipe.totalTimeMinutes} min',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textQuiet,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const Text('  ·  ', style: TextStyle(color: AppTheme.textMuted)),
                  Text(
                    recipe.difficulty,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textQuiet),
                  ),
                  const Text('  ·  ', style: TextStyle(color: AppTheme.textMuted)),
                  Text(
                    '${recipe.servings} servings',
                    style: const TextStyle(fontSize: 13, color: AppTheme.textQuiet),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1, color: AppTheme.line),
              const SizedBox(height: 12),

              // Ruled macro strip with tabular figures
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MacroBadge(
                    label: 'Calories',
                    value: '${recipe.nutrition.calories} kcal',
                    compact: true,
                    isLead: true,
                  ),
                  MacroBadge(
                    label: 'Protein',
                    value: '${recipe.nutrition.proteinGrams}g',
                    compact: true,
                  ),
                  MacroBadge(
                    label: 'Carbs',
                    value: '${recipe.nutrition.carbsGrams}g',
                    compact: true,
                  ),
                  MacroBadge(
                    label: 'Fat',
                    value: '${recipe.nutrition.fatGrams}g',
                    compact: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
