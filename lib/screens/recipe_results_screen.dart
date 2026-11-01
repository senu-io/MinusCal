import 'package:flutter/material.dart';
import '../models/pantry_item.dart';
import '../models/meal_preference.dart';
import '../models/recipe.dart';
import '../services/storage_service.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class RecipeResultsScreen extends StatefulWidget {
  final StorageService storageService;
  final List<PantryItem> pantry;
  final MealPreference preference;

  const RecipeResultsScreen({
    super.key,
    required this.storageService,
    required this.pantry,
    required this.preference,
  });

  @override
  State<RecipeResultsScreen> createState() => _RecipeResultsScreenState();
}

class _RecipeResultsScreenState extends State<RecipeResultsScreen> {
  final GeminiService _geminiService = GeminiService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiKey = widget.storageService.getApiKey();
      final results = await _geminiService.generateRecipes(
        pantry: widget.pantry,
        preference: widget.preference,
        apiKey: apiKey,
      );

      for (var r in results) {
        r.isFavorite = widget.storageService.isFavorite(r);
      }

      setState(() {
        _recipes = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasApiKey = widget.storageService.getApiKey() != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggested recipes'),
        actions: [
          if (!_isLoading && _recipes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              tooltip: 'Regenerate',
              onPressed: _fetchRecipes,
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingView()
          : _errorMessage != null
              ? _buildErrorView()
              : _buildResultsList(hasApiKey),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.text),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Generating recipes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Matching selected ingredients to your ${widget.preference.fitnessGoal.label.toLowerCase()} target',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textQuiet,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 36, color: AppTheme.support),
            const SizedBox(height: 16),
            const Text(
              'Could not generate recipes',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppTheme.text),
            ),
            const SizedBox(height: 6),
            Text(
              _errorMessage ?? 'Check your connection or API key and try again.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppTheme.textQuiet),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchRecipes,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(bool hasApiKey) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Mode indicator
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.line),
          ),
          child: Row(
            children: [
              Icon(
                hasApiKey ? Icons.cloud_done_outlined : Icons.offline_pin_outlined,
                size: 16,
                color: AppTheme.textQuiet,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasApiKey ? 'Connected to Google Gemini 2.0 Flash' : 'Local culinary rule generator (Offline)',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textQuiet),
                ),
              ),
            ],
          ),
        ),

        ..._recipes.map((recipe) {
          return RecipeCard(
            recipe: recipe,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => RecipeDetailScreen(
                    recipe: recipe,
                    storageService: widget.storageService,
                  ),
                ),
              );
            },
            onToggleFavorite: () async {
              await widget.storageService.toggleFavorite(recipe);
              setState(() {});
            },
          );
        }),
      ],
    );
  }
}
