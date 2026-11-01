import 'dart:async';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/macro_badge.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final StorageService storageService;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.storageService,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final Set<int> _completedSteps = {};
  Timer? _cookingTimer;
  int _timerSecondsRemaining = 0;
  bool _isTimerActive = false;

  @override
  void dispose() {
    _cookingTimer?.cancel();
    super.dispose();
  }

  void _startTimer(int minutes) {
    _cookingTimer?.cancel();
    setState(() {
      _timerSecondsRemaining = minutes * 60;
      _isTimerActive = true;
    });

    _cookingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSecondsRemaining > 0) {
        setState(() => _timerSecondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _isTimerActive = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Timer complete for ${widget.recipe.title}'),
              backgroundColor: AppTheme.surfaceRaised,
            ),
          );
        }
      }
    });
  }

  void _stopTimer() {
    _cookingTimer?.cancel();
    setState(() {
      _isTimerActive = false;
      _timerSecondsRemaining = 0;
    });
  }

  String _formatTimerTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final isFav = widget.storageService.isFavorite(recipe);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppTheme.support : AppTheme.textQuiet,
            ),
            tooltip: isFav ? 'Remove from saved' : 'Save recipe',
            onPressed: () async {
              await widget.storageService.toggleFavorite(recipe);
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Title and description
          Text(
            recipe.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.text,
              letterSpacing: -0.4,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.description,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textQuiet,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),

          // Metadata row
          Row(
            children: [
              Text(
                '${recipe.prepTimeMinutes} min prep',
                style: const TextStyle(fontSize: 13, color: AppTheme.textQuiet, fontFeatures: [FontFeature.tabularFigures()]),
              ),
              const Text('  ·  ', style: TextStyle(color: AppTheme.textMuted)),
              Text(
                '${recipe.cookTimeMinutes} min cook',
                style: const TextStyle(fontSize: 13, color: AppTheme.textQuiet, fontFeatures: [FontFeature.tabularFigures()]),
              ),
              const Text('  ·  ', style: TextStyle(color: AppTheme.textMuted)),
              Text(
                '${recipe.servings} servings',
                style: const TextStyle(fontSize: 13, color: AppTheme.textQuiet),
              ),
              const Text('  ·  ', style: TextStyle(color: AppTheme.textMuted)),
              Text(
                recipe.difficulty,
                style: const TextStyle(fontSize: 13, color: AppTheme.textQuiet),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(height: 1, color: AppTheme.line),
          const SizedBox(height: 20),

          // Calorie Hero Figure (Oxfords rule: One large figure sitting outside type scale without a card)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${recipe.nutrition.calories}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  fontFeatures: [FontFeature.tabularFigures()],
                  color: AppTheme.text,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'kcal per serving',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textQuiet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Ruled macro cards
          Row(
            children: [
              Expanded(
                child: MacroBadge(
                  label: 'Protein',
                  value: '${recipe.nutrition.proteinGrams}g',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MacroBadge(
                  label: 'Carbohydrates',
                  value: '${recipe.nutrition.carbsGrams}g',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MacroBadge(
                  label: 'Fat',
                  value: '${recipe.nutrition.fatGrams}g',
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),
          const Divider(height: 1, color: AppTheme.line),
          const SizedBox(height: 20),

          // Appliances
          if (recipe.appliances.isNotEmpty) ...[
            const Text(
              'Equipment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text),
            ),
            const SizedBox(height: 8),
            Text(
              recipe.appliances.join(', '),
              style: const TextStyle(fontSize: 14, color: AppTheme.textQuiet),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, color: AppTheme.line),
            const SizedBox(height: 20),
          ],

          // Ingredients
          const Text(
            'Ingredients',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text),
          ),
          const SizedBox(height: 12),
          ...recipe.ingredientsUsed.map((ing) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 16, color: AppTheme.lead),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ing,
                      style: const TextStyle(fontSize: 15, color: AppTheme.text),
                    ),
                  ),
                ],
              ),
            );
          }),

          if (recipe.missingOrOptional.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Optional additions: ${recipe.missingOrOptional.join(", ")}',
              style: const TextStyle(fontSize: 13, color: AppTheme.textQuiet, fontStyle: FontStyle.italic),
            ),
          ],

          const SizedBox(height: 28),
          const Divider(height: 1, color: AppTheme.line),
          const SizedBox(height: 20),

          // Timer row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.line),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 20, color: AppTheme.textQuiet),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cooking timer',
                        style: TextStyle(fontSize: 13, color: AppTheme.textQuiet),
                      ),
                      Text(
                        _isTimerActive
                            ? _formatTimerTime(_timerSecondsRemaining)
                            : '${recipe.cookTimeMinutes} min cook step',
                        style: TextStyle(
                          fontSize: _isTimerActive ? 18 : 14,
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: AppTheme.text,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isTimerActive)
                  TextButton(
                    onPressed: _stopTimer,
                    style: TextButton.styleFrom(foregroundColor: AppTheme.support),
                    child: const Text('Cancel'),
                  )
                else
                  OutlinedButton(
                    onPressed: () => _startTimer(recipe.cookTimeMinutes > 0 ? recipe.cookTimeMinutes : 15),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.line),
                      foregroundColor: AppTheme.text,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: const Text('Start timer'),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Preparation Steps
          const Text(
            'Preparation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.text),
          ),
          const SizedBox(height: 12),
          ...recipe.instructions.asMap().entries.map((entry) {
            final idx = entry.key;
            final step = entry.value;
            final isDone = _completedSteps.contains(idx);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isDone) {
                      _completedSteps.remove(idx);
                    } else {
                      _completedSteps.add(idx);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${idx + 1}.',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: isDone ? AppTheme.textMuted : AppTheme.textQuiet,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          step,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDone ? AppTheme.textMuted : AppTheme.text,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          if (recipe.chefTip != null && recipe.chefTip!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Technique note',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.pop),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.chefTip!,
                    style: const TextStyle(fontSize: 14, color: AppTheme.textQuiet, height: 1.4),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
