import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuildGridShimmer extends StatelessWidget {
  final int itemCount;
  final bool isHealthIssue;

  const BuildGridShimmer({
    super.key,
    required this.itemCount,
    required this.isHealthIssue,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isHealthIssue ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isHealthIssue ? 0.8 : 0.75,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
