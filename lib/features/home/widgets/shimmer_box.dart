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
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFEAF5FC), Color(0xFFF5FAFD)],
              ),
            ),
            child: const Column(
              children: [
                Row(
                  children: [
                    ShimmerBox(height: 42, width: 42, radius: 21),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(height: 12, width: 94, radius: 6),
                          SizedBox(height: 7),
                          ShimmerBox(height: 16, width: 148, radius: 8),
                        ],
                      ),
                    ),
                    ShimmerBox(height: 40, width: 40, radius: 14),
                  ],
                ),
                SizedBox(height: 16),
                ShimmerBox(height: 50, width: double.infinity, radius: 16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            child: Column(
              children: [
                const ShimmerBox(
                  height: 164,
                  width: double.infinity,
                  radius: 22,
                ),
                const SizedBox(height: 22),
                _shimmerSection(
                  titleWidth: 92,
                  itemHeight: 82,
                  itemWidth: 82,
                  itemCount: 5,
                ),
                const SizedBox(height: 22),
                _shimmerSection(
                  titleWidth: 132,
                  itemHeight: 224,
                  itemWidth: 158,
                  itemCount: 3,
                  productCards: true,
                ),
                const SizedBox(height: 22),
                _shimmerSection(
                  titleWidth: 74,
                  itemHeight: 174,
                  itemWidth: 154,
                  itemCount: 3,
                ),
                const SizedBox(height: 22),
                const ShimmerBox(
                  height: 164,
                  width: double.infinity,
                  radius: 22,
                ),
                const SizedBox(height: 22),
                _shimmerSection(
                  titleWidth: 126,
                  itemHeight: 154,
                  itemWidth: 154,
                  itemCount: 3,
                ),
                const SizedBox(height: 22),
                _shimmerSection(
                  titleWidth: 144,
                  itemHeight: 224,
                  itemWidth: 158,
                  itemCount: 3,
                  productCards: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerSection({
    required double titleWidth,
    required double itemHeight,
    required double itemWidth,
    required int itemCount,
    bool productCards = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShimmerBox(height: 20, width: titleWidth, radius: 7),
            const Spacer(),
            const ShimmerBox(height: 14, width: 54, radius: 7),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: itemHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, __) {
              if (!productCards) {
                return ShimmerBox(
                  height: itemHeight,
                  width: itemWidth,
                  radius: 18,
                );
              }
              return SizedBox(
                width: itemWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      height: itemHeight - 63,
                      width: itemWidth,
                      radius: 18,
                    ),
                    const SizedBox(height: 9),
                    const ShimmerBox(
                      height: 12,
                      width: double.infinity,
                      radius: 6,
                    ),
                    const SizedBox(height: 7),
                    ShimmerBox(height: 12, width: itemWidth * 0.62, radius: 6),
                    const SizedBox(height: 8),
                    ShimmerBox(height: 15, width: itemWidth * 0.48, radius: 7),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: itemCount,
          ),
        ),
      ],
    );
  }
}
