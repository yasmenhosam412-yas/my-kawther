import 'package:elkawther/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      itemCount: 5,
      itemBuilder: (context, _) => Shimmer.fromColors(
        baseColor: const Color(0xFFD6F0FA),
        highlightColor: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: 92,
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
