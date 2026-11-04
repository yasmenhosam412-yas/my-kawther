import 'package:elkawther/features/profile/cubit/reviews_cubit.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/features/products/widgets/custom_review_list_item.dart';

class AllReviewsBottomSheet extends StatefulWidget {
  final int productId;

  const AllReviewsBottomSheet({super.key, required this.productId});

  @override
  State<AllReviewsBottomSheet> createState() => _AllReviewsBottomSheetState();
}

class _AllReviewsBottomSheetState extends State<AllReviewsBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewCubit>().getReview(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.medium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).reviewsAndrev,
                  style: AppTextStyles.noto24w500.copyWith(fontSize: 20),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 1),
          Expanded(
            child: BlocBuilder<ReviewCubit, ReviewState>(
              builder: (context, state) {
                if (state is ReviewLoading) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(AppPadding.medium),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppPadding.small,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(height: AppPadding.small),
                              Container(
                                width: double.infinity,
                                height: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(height: AppPadding.small),
                              Container(
                                width: double.infinity,
                                height: 14,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder:
                        (context, index) =>
                            const SizedBox(height: AppPadding.medium),
                  );
                } else if (state is ReviewRatesLoaded) {
                  final reviews = state.reviews;
                  if (reviews.isEmpty) {
                    return Center(
                      child: Text(
                        S.of(context).reviewsEmpty,
                        style: AppTextStyles.noto16w400.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(AppPadding.medium),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return CustomReviewListItem(
                        rate: review.rate,
                        reviewerName: review.user.name,
                        reviewText: review.review ?? '',
                        createdAt: review.createdAt.toString(),
                      );
                    },
                    separatorBuilder:
                        (context, index) =>
                            const SizedBox(height: AppPadding.medium),
                  );
                } else if (state is ReviewError) {
                  return Center(
                    child: Text(state.message.localizedMessage(context)),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
