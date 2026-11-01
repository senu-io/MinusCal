import 'package:flutter/material.dart';
import '../models/meal_preference.dart';
import '../theme/app_theme.dart';

class PreferenceModal extends StatefulWidget {
  final MealPreference initialPreference;
  final int selectedItemCount;
  final Function(MealPreference) onApply;

  const PreferenceModal({
    super.key,
    required this.initialPreference,
    required this.selectedItemCount,
    required this.onApply,
  });

  @override
  State<PreferenceModal> createState() => _PreferenceModalState();
}

class _PreferenceModalState extends State<PreferenceModal> {
  late MealType _mealType;
  late MealComplexity _complexity;
  late FitnessGoal _fitnessGoal;
  late int _servings;
  late bool _strictMode;

  @override
  void initState() {
    super.initState();
    _mealType = widget.initialPreference.mealType;
    _complexity = widget.initialPreference.complexity;
    _fitnessGoal = widget.initialPreference.fitnessGoal;
    _servings = widget.initialPreference.servings;
    _strictMode = widget.initialPreference.strictPantryOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(top: BorderSide(color: AppTheme.line, width: 1)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sheet Grabber
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recipe options',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.selectedItemCount} items available in kitchen',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textQuiet,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.textQuiet, size: 20),
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Meal Type Section (Plain sentence case, no uppercase letterspacing)
            const Text(
              'Meal type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.text,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MealType.values.map((type) {
                final isSelected = _mealType == type;
                return ChoiceChip(
                  label: Text(type.label),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _mealType = type);
                  },
                  selectedColor: AppTheme.lead,
                  backgroundColor: AppTheme.surfaceRaised,
                  side: BorderSide(
                    color: isSelected ? AppTheme.leadLight : AppTheme.line,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.text : AppTheme.textQuiet,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Fitness & Nutrition Goal
            const Text(
              'Nutritional goal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.text,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FitnessGoal.values.map((goal) {
                final isSelected = _fitnessGoal == goal;
                return ChoiceChip(
                  label: Text(goal.label),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _fitnessGoal = goal);
                  },
                  selectedColor: AppTheme.lead,
                  backgroundColor: AppTheme.surfaceRaised,
                  side: BorderSide(
                    color: isSelected ? AppTheme.leadLight : AppTheme.line,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.text : AppTheme.textQuiet,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Complexity / Time
            const Text(
              'Cooking time',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.text,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: MealComplexity.values.map((comp) {
                final isSelected = _complexity == comp;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => setState(() => _complexity = comp),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.lead : AppTheme.surfaceRaised,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppTheme.leadLight : AppTheme.line,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          comp.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? AppTheme.text : AppTheme.textQuiet,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Servings & Strict Mode Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Servings',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceRaised,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.line),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _servings > 1
                                  ? () => setState(() => _servings--)
                                  : null,
                            ),
                            Text(
                              '$_servings',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFeatures: [FontFeature.tabularFigures()],
                                color: AppTheme.text,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: _servings < 10
                                  ? () => setState(() => _servings++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Strict inventory',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceRaised,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.line),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _strictMode ? 'Strict only' : 'Flexible',
                              style: TextStyle(
                                fontSize: 13,
                                color: _strictMode ? AppTheme.pop : AppTheme.textQuiet,
                              ),
                            ),
                            Switch(
                              value: _strictMode,
                              onChanged: (val) => setState(() => _strictMode = val),
                              activeTrackColor: AppTheme.lead,
                              activeThumbColor: AppTheme.pop,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final pref = MealPreference(
                    mealType: _mealType,
                    complexity: _complexity,
                    fitnessGoal: _fitnessGoal,
                    servings: _servings,
                    strictPantryOnly: _strictMode,
                    recipeCount: 3,
                  );
                  Navigator.pop(context);
                  widget.onApply(pref);
                },
                child: const Text('Generate recipes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
