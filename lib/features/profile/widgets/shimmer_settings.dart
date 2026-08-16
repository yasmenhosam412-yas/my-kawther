import 'package:flutter/material.dart';
import 'package:elkawther/features/home/widgets/shimmer_box.dart';

class SettingsPageShimmer extends StatelessWidget {
  const SettingsPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          final isShortLine = index % 5 == 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ShimmerBox(
              height: 18,
              width: screenWidth * (isShortLine ? 0.6 : 0.95),
              radius: 6,
            ),
          );
        },
      ),
    );
  }
}
