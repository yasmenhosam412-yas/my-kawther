import 'package:elkawther/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap; // Callback function

  const TabItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryColor : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isSelected)
              Container(
                height: 2,
                width: double.infinity,
                color: AppColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
