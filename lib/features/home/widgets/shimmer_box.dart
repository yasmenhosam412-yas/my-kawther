import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class HomeViewShimmer extends StatelessWidget {
  const HomeViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(height: 40, width: 40, radius: 20),
              Row(
                children: [
                  ShimmerBox(height: 30, width: 30, radius: 8),
                  SizedBox(width: 8),
                  ShimmerBox(height: 30, width: 30, radius: 8),
                  SizedBox(width: 8),
                  ShimmerBox(height: 30, width: 30, radius: 8),
                ],
              ),
            ],
          ),

          const ShimmerBox(height: 50, width: double.infinity, radius: 12),

          const ShimmerBox(height: 160, width: double.infinity, radius: 12),

          _shimmerSectionList(titleWidth: 120, itemHeight: 80, itemCount: 5),

          _shimmerSectionList(titleWidth: 150, itemHeight: 200, itemCount: 3),

          _shimmerSectionList(titleWidth: 100, itemHeight: 80, itemCount: 6),

          _shimmerSectionList(titleWidth: 140, itemHeight: 100, itemCount: 4),

          _shimmerSectionList(titleWidth: 160, itemHeight: 200, itemCount: 3),

          _shimmerSectionList(titleWidth: 140, itemHeight: 200, itemCount: 3),
        ],
      ),
    );
  }

  Widget _shimmerSectionList({
    required double titleWidth,
    required double itemHeight,
    required int itemCount,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(height: 20, width: titleWidth),
        const SizedBox(height: 8),
        SizedBox(
          height: itemHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder:
                (_, __) => ShimmerBox(
                  height: itemHeight,
                  width: itemHeight * 0.8,
                  radius: 12,
                ),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: itemCount,
          ),
        ),
      ],
    );
  }
}
