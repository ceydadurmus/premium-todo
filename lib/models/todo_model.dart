import 'package:flutter/material.dart';

enum TodoCategory {
  work,
  personal,
  health,
  shopping,
}

extension TodoCategoryExtension on TodoCategory {
  String get name {
    switch (this) {
      case TodoCategory.work:
        return 'İş';
      case TodoCategory.personal:
        return 'Kişisel';
      case TodoCategory.health:
        return 'Sağlık';
      case TodoCategory.shopping:
        return 'Alışveriş';
    }
  }

  IconData get icon {
    switch (this) {
      case TodoCategory.work:
        return Icons.work_outline_rounded;
      case TodoCategory.personal:
        return Icons.person_outline_rounded;
      case TodoCategory.health:
        return Icons.favorite_border_rounded;
      case TodoCategory.shopping:
        return Icons.shopping_bag_outlined;
    }
  }

  Color get color {
    switch (this) {
      case TodoCategory.work:
        return const Color(0xFF8B5CF6); // Neon Mor
      case TodoCategory.personal:
        return const Color(0xFF3B82F6); // Neon Mavi
      case TodoCategory.health:
        return const Color(0xFF10B981); // Neon Yeşil
      case TodoCategory.shopping:
        return const Color(0xFFF59E0B); // Neon Kehribar
    }
  }
}

class TodoItem {
  final String id;
  final String title;
  bool isCompleted;
  final TodoCategory category;
  final DateTime date;

  TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.category,
    required this.date,
  });
}
