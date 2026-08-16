import 'package:flutter/material.dart';

import 'package:elkawther/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Function()? onBackPressed;
  final List<Widget>? actions; // Add actions parameter

  const CustomAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.actions, // Initialize actions
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[50],
          child: IconButton(
            onPressed: onBackPressed ?? () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
          ),
        ),
      ),
      title: Text(
        title ?? '',
        style: const TextStyle(color: AppColors.primaryColor),
      ),
      actions:
          actions
              ?.map(
                (widget) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: widget,
                ),
              )
              .toList(), // Safely map actions with padding
      elevation: 0,
      centerTitle: true, // Center the title
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
