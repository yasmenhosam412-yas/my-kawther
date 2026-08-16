import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:elkawther/core/theme/app_padding.dart';

Widget buildShimmerGrid({int? itemCount}) {
  return GridView.builder(
    padding: const EdgeInsets.all(AppPadding.medium),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: AppPadding.medium,
      mainAxisSpacing: AppPadding.medium,
      childAspectRatio: 0.9,
    ),
    itemCount: itemCount ?? 6,
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    },
  );
}
