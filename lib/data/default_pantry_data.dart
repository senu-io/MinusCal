import '../models/pantry_item.dart';

class DefaultPantryData {
  static List<PantryItem> get initialPantryItems => [
        // Appliances
        PantryItem(
          id: 'app_gas_cooker',
          name: 'Gas Cooker / Stovetop',
          category: ItemCategory.appliances,
          isAvailable: true,
        ),
        PantryItem(
          id: 'app_microwave',
          name: 'Microwave',
          category: ItemCategory.appliances,
          isAvailable: true,
        ),
        PantryItem(
          id: 'app_oven',
          name: 'Oven',
          category: ItemCategory.appliances,
          isAvailable: false,
        ),
        PantryItem(
          id: 'app_rice_cooker',
          name: 'Rice Cooker',
          category: ItemCategory.appliances,
          isAvailable: false,
        ),
        PantryItem(
          id: 'app_air_fryer',
          name: 'Air Fryer',
          category: ItemCategory.appliances,
          isAvailable: false,
        ),
        PantryItem(
          id: 'app_blender',
          name: 'Blender',
          category: ItemCategory.appliances,
          isAvailable: false,
        ),
        PantryItem(
          id: 'app_toaster',
          name: 'Toaster',
          category: ItemCategory.appliances,
          isAvailable: false,
        ),

        // Meats & Proteins
        PantryItem(
          id: 'prot_chicken_breast',
          name: 'Chicken Breast',
          category: ItemCategory.meatsProteins,
          isAvailable: true,
        ),
        PantryItem(
          id: 'prot_eggs',
          name: 'Eggs',
          category: ItemCategory.meatsProteins,
          isAvailable: true,
        ),
        PantryItem(
          id: 'prot_ground_beef',
          name: 'Ground Beef',
          category: ItemCategory.meatsProteins,
          isAvailable: false,
        ),
        PantryItem(
          id: 'prot_tuna',
          name: 'Canned Tuna',
          category: ItemCategory.meatsProteins,
          isAvailable: false,
        ),
        PantryItem(
          id: 'prot_salmon',
          name: 'Salmon Fillet',
          category: ItemCategory.meatsProteins,
          isAvailable: false,
        ),
        PantryItem(
          id: 'prot_steak',
          name: 'Beef Steak',
          category: ItemCategory.meatsProteins,
          isAvailable: false,
        ),
        PantryItem(
          id: 'prot_tofu',
          name: 'Tofu',
          category: ItemCategory.meatsProteins,
          isAvailable: false,
        ),
        PantryItem(
          id: 'prot_turkey',
          name: 'Ground Turkey',
          category: ItemCategory.meatsProteins,
          isAvailable: false,
        ),
        PantryItem(
          id: 'prot_bacon',
          name: 'Bacon',
          category: ItemCategory.meatsProteins,
          isAvailable: false,
        ),
        PantryItem(
          id: 'prot_shrimp',
          name: 'Shrimp',
          category: ItemCategory.meatsProteins,
          isAvailable: false,
        ),

        // Vegetables
        PantryItem(
          id: 'veg_onions',
          name: 'Onions',
          category: ItemCategory.vegetables,
          isAvailable: true,
        ),
        PantryItem(
          id: 'veg_garlic',
          name: 'Garlic',
          category: ItemCategory.vegetables,
          isAvailable: true,
        ),
        PantryItem(
          id: 'veg_tomatoes',
          name: 'Tomatoes',
          category: ItemCategory.vegetables,
          isAvailable: true,
        ),
        PantryItem(
          id: 'veg_spinach',
          name: 'Spinach',
          category: ItemCategory.vegetables,
          isAvailable: false,
        ),
        PantryItem(
          id: 'veg_broccoli',
          name: 'Broccoli',
          category: ItemCategory.vegetables,
          isAvailable: false,
        ),
        PantryItem(
          id: 'veg_carrots',
          name: 'Carrots',
          category: ItemCategory.vegetables,
          isAvailable: false,
        ),
        PantryItem(
          id: 'veg_bell_peppers',
          name: 'Bell Peppers',
          category: ItemCategory.vegetables,
          isAvailable: false,
        ),
        PantryItem(
          id: 'veg_mushrooms',
          name: 'Mushrooms',
          category: ItemCategory.vegetables,
          isAvailable: false,
        ),
        PantryItem(
          id: 'veg_potatoes',
          name: 'Potatoes',
          category: ItemCategory.vegetables,
          isAvailable: true,
        ),
        PantryItem(
          id: 'veg_zucchini',
          name: 'Zucchini',
          category: ItemCategory.vegetables,
          isAvailable: false,
        ),
        PantryItem(
          id: 'veg_cucumber',
          name: 'Cucumber',
          category: ItemCategory.vegetables,
          isAvailable: false,
        ),

        // Carbs & Grains
        PantryItem(
          id: 'carb_rice',
          name: 'White / Basmati Rice',
          category: ItemCategory.carbsGrains,
          isAvailable: true,
        ),
        PantryItem(
          id: 'carb_pasta',
          name: 'Pasta / Noodles',
          category: ItemCategory.carbsGrains,
          isAvailable: true,
        ),
        PantryItem(
          id: 'carb_oats',
          name: 'Rolled Oats',
          category: ItemCategory.carbsGrains,
          isAvailable: false,
        ),
        PantryItem(
          id: 'carb_bread',
          name: 'Bread / Slices',
          category: ItemCategory.carbsGrains,
          isAvailable: true,
        ),
        PantryItem(
          id: 'carb_tortillas',
          name: 'Tortillas / Wraps',
          category: ItemCategory.carbsGrains,
          isAvailable: false,
        ),
        PantryItem(
          id: 'carb_quinoa',
          name: 'Quinoa',
          category: ItemCategory.carbsGrains,
          isAvailable: false,
        ),
        PantryItem(
          id: 'carb_flour',
          name: 'All-Purpose Flour',
          category: ItemCategory.carbsGrains,
          isAvailable: false,
        ),

        // Dairy & Alternatives
        PantryItem(
          id: 'dairy_milk',
          name: 'Milk (Dairy / Plant)',
          category: ItemCategory.dairy,
          isAvailable: true,
        ),
        PantryItem(
          id: 'dairy_greek_yogurt',
          name: 'Greek Yogurt',
          category: ItemCategory.dairy,
          isAvailable: false,
        ),
        PantryItem(
          id: 'dairy_cheese',
          name: 'Cheddar / Mozzarella',
          category: ItemCategory.dairy,
          isAvailable: true,
        ),
        PantryItem(
          id: 'dairy_butter',
          name: 'Butter',
          category: ItemCategory.dairy,
          isAvailable: true,
        ),
        PantryItem(
          id: 'dairy_parmesan',
          name: 'Parmesan Cheese',
          category: ItemCategory.dairy,
          isAvailable: false,
        ),
        PantryItem(
          id: 'dairy_cottage_cheese',
          name: 'Cottage Cheese',
          category: ItemCategory.dairy,
          isAvailable: false,
        ),

        // Spices & Staples
        PantryItem(
          id: 'spice_salt',
          name: 'Salt',
          category: ItemCategory.spicesPantry,
          isAvailable: true,
          isDefaultEssential: true,
        ),
        PantryItem(
          id: 'spice_black_pepper',
          name: 'Black Pepper',
          category: ItemCategory.spicesPantry,
          isAvailable: true,
          isDefaultEssential: true,
        ),
        PantryItem(
          id: 'spice_olive_oil',
          name: 'Olive Oil / Cooking Oil',
          category: ItemCategory.spicesPantry,
          isAvailable: true,
          isDefaultEssential: true,
        ),
        PantryItem(
          id: 'spice_paprika',
          name: 'Smoked Paprika',
          category: ItemCategory.spicesPantry,
          isAvailable: true,
        ),
        PantryItem(
          id: 'spice_garlic_powder',
          name: 'Garlic Powder',
          category: ItemCategory.spicesPantry,
          isAvailable: false,
        ),
        PantryItem(
          id: 'spice_cumin',
          name: 'Cumin',
          category: ItemCategory.spicesPantry,
          isAvailable: false,
        ),
        PantryItem(
          id: 'spice_chili_flakes',
          name: 'Chili Flakes',
          category: ItemCategory.spicesPantry,
          isAvailable: false,
        ),
        PantryItem(
          id: 'spice_oregano',
          name: 'Oregano / Italian Herbs',
          category: ItemCategory.spicesPantry,
          isAvailable: false,
        ),
        PantryItem(
          id: 'spice_soy_sauce',
          name: 'Soy Sauce',
          category: ItemCategory.spicesPantry,
          isAvailable: false,
        ),
        PantryItem(
          id: 'spice_cinnamon',
          name: 'Cinnamon',
          category: ItemCategory.spicesPantry,
          isAvailable: false,
        ),

        // Sweets & Desserts
        PantryItem(
          id: 'sweet_sugar',
          name: 'Sugar / Sweetener',
          category: ItemCategory.dessertsSweets,
          isAvailable: true,
          isDefaultEssential: true,
        ),
        PantryItem(
          id: 'sweet_honey',
          name: 'Honey / Maple Syrup',
          category: ItemCategory.dessertsSweets,
          isAvailable: false,
        ),
        PantryItem(
          id: 'sweet_cocoa',
          name: 'Cocoa Powder / Dark Chocolate',
          category: ItemCategory.dessertsSweets,
          isAvailable: false,
        ),
        PantryItem(
          id: 'sweet_peanut_butter',
          name: 'Peanut Butter',
          category: ItemCategory.dessertsSweets,
          isAvailable: false,
        ),
        PantryItem(
          id: 'sweet_banana',
          name: 'Bananas',
          category: ItemCategory.dessertsSweets,
          isAvailable: false,
        ),
        PantryItem(
          id: 'sweet_berries',
          name: 'Berries (Fresh or Frozen)',
          category: ItemCategory.dessertsSweets,
          isAvailable: false,
        ),
      ];
}
