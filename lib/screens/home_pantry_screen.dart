import 'package:flutter/material.dart';
import '../models/pantry_item.dart';
import '../models/meal_preference.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pantry_card.dart';
import '../widgets/preference_modal.dart';
import 'recipe_results_screen.dart';

class HomePantryScreen extends StatefulWidget {
  final StorageService storageService;
  final VoidCallback onOpenSettings;

  const HomePantryScreen({
    super.key,
    required this.storageService,
    required this.onOpenSettings,
  });

  @override
  State<HomePantryScreen> createState() => _HomePantryScreenState();
}

class _HomePantryScreenState extends State<HomePantryScreen> {
  late List<PantryItem> _pantryItems;
  ItemCategory? _selectedCategory;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadItems() {
    setState(() {
      _pantryItems = widget.storageService.loadPantryItems();
    });
  }

  void _saveItems() {
    widget.storageService.savePantryItems(_pantryItems);
  }

  void _toggleItem(PantryItem item) {
    setState(() {
      item.isAvailable = !item.isAvailable;
    });
    _saveItems();
  }

  void _showAddCustomItemDialog() {
    final nameController = TextEditingController();
    ItemCategory selectedCategory = ItemCategory.meatsProteins;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppTheme.line),
          ),
          title: const Text('Add kitchen item', style: TextStyle(color: AppTheme.text, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Item name', style: TextStyle(fontSize: 13, color: AppTheme.textQuiet)),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                autofocus: true,
                style: const TextStyle(color: AppTheme.text, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'e.g. Avocado, Air Fryer',
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.surfaceRaised,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.line),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Category', style: TextStyle(fontSize: 13, color: AppTheme.textQuiet)),
              const SizedBox(height: 6),
              DropdownButtonFormField<ItemCategory>(
                initialValue: selectedCategory,
                dropdownColor: AppTheme.surfaceRaised,
                style: const TextStyle(color: AppTheme.text, fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppTheme.surfaceRaised,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.line),
                  ),
                ),
                items: ItemCategory.values.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(c.displayName),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedCategory = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppTheme.textQuiet)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final newItem = PantryItem(
                    id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                    name: name,
                    category: selectedCategory,
                    isAvailable: true,
                  );
                  setState(() {
                    _pantryItems.insert(0, newItem);
                  });
                  _saveItems();
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add item'),
            ),
          ],
        ),
      ),
    );
  }

  void _openPreferenceModal() {
    final availableCount = _pantryItems.where((i) => i.isAvailable).length;
    if (availableCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select at least one kitchen item to generate recipes'),
          backgroundColor: AppTheme.surfaceRaised,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PreferenceModal(
        initialPreference: MealPreference(),
        selectedItemCount: availableCount,
        onApply: (pref) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => RecipeResultsScreen(
                storageService: widget.storageService,
                pantry: _pantryItems,
                preference: pref,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableCount = _pantryItems.where((i) => i.isAvailable).length;

    final filteredItems = _pantryItems.where((item) {
      final matchesCategory =
          _selectedCategory == null || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 22),
            tooltip: 'Add item',
            onPressed: _showAddCustomItemDialog,
          ),
          IconButton(
            icon: const Icon(Icons.tune, size: 20),
            tooltip: 'Settings',
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter controls
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: const TextStyle(color: AppTheme.text, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Search food or appliances',
                hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textQuiet, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: AppTheme.textQuiet),
                        tooltip: 'Clear search',
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.line),
                ),
              ),
            ),
          ),

          // Horizontal Category Strip
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              children: [
                _buildCategoryChip(null, 'All (${_pantryItems.length})'),
                ...ItemCategory.values.map((cat) {
                  final count = _pantryItems.where((i) => i.category == cat).length;
                  return _buildCategoryChip(cat, '${cat.displayName} ($count)');
                }),
              ],
            ),
          ),

          // Selection summary strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$availableCount selected',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textQuiet,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          for (var item in filteredItems) {
                            item.isAvailable = true;
                          }
                        });
                        _saveItems();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.textQuiet,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text('Select all', style: TextStyle(fontSize: 13)),
                    ),
                    const Text('·', style: TextStyle(color: AppTheme.line)),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          for (var item in filteredItems) {
                            item.isAvailable = false;
                          }
                        });
                        _saveItems();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.textQuiet,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text('Clear', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppTheme.line),

          // Items List
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No items matching "$_searchQuery"',
                            style: const TextStyle(fontSize: 15, color: AppTheme.textQuiet),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppTheme.line),
                              foregroundColor: AppTheme.text,
                            ),
                            child: const Text('Clear query'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PantryCard(
                          item: item,
                          onToggle: () => _toggleItem(item),
                          onDelete: item.id.startsWith('custom_')
                              ? () {
                                  setState(() {
                                    _pantryItems.removeWhere((i) => i.id == item.id);
                                  });
                                  _saveItems();
                                }
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Persistent Action Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _openPreferenceModal,
            child: Text(
              availableCount == 0
                  ? 'Select kitchen items'
                  : 'Generate recipes ($availableCount ready)',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(ItemCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {
          setState(() {
            _selectedCategory = isSelected ? null : category;
          });
        },
        selectedColor: AppTheme.lead,
        backgroundColor: AppTheme.surface,
        showCheckmark: false,
        side: BorderSide(
          color: isSelected ? AppTheme.leadLight : AppTheme.line,
        ),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.text : AppTheme.textQuiet,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 13,
        ),
      ),
    );
  }
}
