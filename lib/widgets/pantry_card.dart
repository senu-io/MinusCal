import 'package:flutter/material.dart';
import '../models/pantry_item.dart';
import '../theme/app_theme.dart';

class PantryCard extends StatelessWidget {
  final PantryItem item;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const PantryCard({
    super.key,
    required this.item,
    required this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = item.isAvailable;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${item.name}, ${isSelected ? "selected" : "not selected"}',
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 48), // 48dp Android floor
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.lead : AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppTheme.leadLight : AppTheme.line,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                size: 18,
                color: isSelected ? AppTheme.pop : AppTheme.textMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppTheme.text : AppTheme.textQuiet,
                  ),
                ),
              ),
              if (item.isDefaultEssential && !isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    'Basic',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 16, color: AppTheme.textMuted),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  tooltip: 'Remove ${item.name}',
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
