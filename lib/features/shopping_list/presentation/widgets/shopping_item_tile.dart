import 'package:flutter/material.dart';

import '../../domain/entities/shopping_enums.dart';
import '../../domain/entities/shopping_item.dart';

/// 쇼핑 아이템 타일 위젯
class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: theme.colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: item.isCompleted,
          onChanged: (_) => onToggle(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            color: item.isCompleted
                ? theme.colorScheme.onSurface.withOpacity(0.5)
                : null,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              '${item.quantity} ${item.unit}',
              style: TextStyle(
                color: item.isCompleted
                    ? theme.colorScheme.onSurface.withOpacity(0.4)
                    : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            if (item.suggestedBy != SuggestionSource.manual) ...[
              const SizedBox(width: 8),
              _buildSourceChip(context),
            ],
          ],
        ),
        trailing: _buildPriorityIndicator(context),
      ),
    );
  }

  Widget _buildSourceChip(BuildContext context) {
    final theme = Theme.of(context);

    Color chipColor;
    IconData icon;

    switch (item.suggestedBy) {
      case SuggestionSource.lowStock:
        chipColor = Colors.orange;
        icon = Icons.warning_amber;
        break;
      case SuggestionSource.expired:
        chipColor = Colors.red;
        icon = Icons.event_busy;
        break;
      case SuggestionSource.frequent:
        chipColor = Colors.blue;
        icon = Icons.repeat;
        break;
      case SuggestionSource.manual:
        chipColor = theme.colorScheme.primary;
        icon = Icons.add;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: chipColor),
          const SizedBox(width: 2),
          Text(
            item.suggestedBy.label,
            style: TextStyle(fontSize: 10, color: chipColor),
          ),
        ],
      ),
    );
  }

  Widget? _buildPriorityIndicator(BuildContext context) {
    if (item.isCompleted) return null;

    Color color;
    switch (item.priority) {
      case ShoppingPriority.high:
        color = Colors.red;
        break;
      case ShoppingPriority.medium:
        return null; // 보통은 표시하지 않음
      case ShoppingPriority.low:
        color = Colors.grey;
        break;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
