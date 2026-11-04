import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:elkawther/core/theme/app_padding.dart';

class CustomReviewListItem extends StatelessWidget {
  final int rate;
  final String reviewText;
  final String reviewerName;
  final String createdAt;

  const CustomReviewListItem({
    super.key,
    required this.rate,
    required this.reviewText,
    required this.reviewerName,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(createdAt);
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 1.0),
              child: Icon(
                index < rate ? Icons.star_rounded : Icons.star_border_rounded,
                color: Colors.amber,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppPadding.small),
        if (reviewText.trim().isNotEmpty) ...[
          Text(
            reviewText,
            style: AppTextStyles.ibmPlexSans16w500.copyWith(
              color: const Color(0xff6B7280),
            ),
          ),
          const SizedBox(height: AppPadding.small),
        ],
        RichText(
          text: TextSpan(
            style: AppTextStyles.ibmPlexSans16w500.copyWith(
              color: const Color(0xff6B7280),
            ),
            children: [
              TextSpan(
                text: reviewerName,
                style: AppTextStyles.ibmPlexSans16w500.copyWith(
                  color: const Color(0xff6B7280),
                ),
              ),
              const TextSpan(text: ' , '),
              TextSpan(
                text: formattedDate,
                style: AppTextStyles.ibmPlexSans16w500.copyWith(
                  color: const Color(0xff6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
