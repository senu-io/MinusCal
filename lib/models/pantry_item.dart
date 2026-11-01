enum ItemCategory {
  appliances,
  meatsProteins,
  vegetables,
  carbsGrains,
  dairy,
  spicesPantry,
  dessertsSweets,
  other,
}

extension ItemCategoryExtension on ItemCategory {
  String get displayName {
    switch (this) {
      case ItemCategory.appliances:
        return 'Appliances';
      case ItemCategory.meatsProteins:
        return 'Meats & Protein';
      case ItemCategory.vegetables:
        return 'Vegetables';
      case ItemCategory.carbsGrains:
        return 'Carbs & Grains';
      case ItemCategory.dairy:
        return 'Dairy & Alt';
      case ItemCategory.spicesPantry:
        return 'Spices & Staples';
      case ItemCategory.dessertsSweets:
        return 'Sweets & Desserts';
      case ItemCategory.other:
        return 'Other';
    }
  }

  String get imageAsset {
    switch (this) {
      case ItemCategory.appliances:
        return 'assets/images/appliances.jpg';
      case ItemCategory.meatsProteins:
        return 'assets/images/proteins.jpg';
      case ItemCategory.vegetables:
        return 'assets/images/vegetables.jpg';
      case ItemCategory.carbsGrains:
        return 'assets/images/carbs.jpg';
      case ItemCategory.dairy:
        return 'assets/images/proteins.jpg';
      case ItemCategory.spicesPantry:
        return 'assets/images/spices.jpg';
      case ItemCategory.dessertsSweets:
        return 'assets/images/dessert.jpg';
      case ItemCategory.other:
        return 'assets/images/hero_banner.jpg';
    }
  }
}

class PantryItem {
  final String id;
  final String name;
  final ItemCategory category;
  bool isAvailable;
  final bool isDefaultEssential;

  PantryItem({
    required this.id,
    required this.name,
    required this.category,
    this.isAvailable = false,
    this.isDefaultEssential = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.name,
        'isAvailable': isAvailable,
        'isDefaultEssential': isDefaultEssential,
      };

  factory PantryItem.fromJson(Map<String, dynamic> json) => PantryItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: ItemCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => ItemCategory.other,
        ),
        isAvailable: json['isAvailable'] as bool? ?? false,
        isDefaultEssential: json['isDefaultEssential'] as bool? ?? false,
      );

  PantryItem copyWith({
    String? id,
    String? name,
    ItemCategory? category,
    bool? isAvailable,
    bool? isDefaultEssential,
  }) {
    return PantryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      isDefaultEssential: isDefaultEssential ?? this.isDefaultEssential,
    );
  }
}
