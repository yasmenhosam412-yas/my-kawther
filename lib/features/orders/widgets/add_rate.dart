import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/profile/cubit/reviews_cubit.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddRateBottomSheet extends StatefulWidget {
  final int productId;

  const AddRateBottomSheet({super.key, required this.productId});

  @override
  State<AddRateBottomSheet> createState() => _AddRateBottomSheetState();
}

class _AddRateBottomSheetState extends State<AddRateBottomSheet> {
  late TextEditingController _commentController;
  final _key = GlobalKey<FormState>();
  double _rating = 1;
  bool _sending = false;

  @override
  void initState() {
    _commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.greyBorder,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).your_evaluation_matters_to_us,
                      style: AppTextStyles.noto16w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: AppColors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).how_was_your_order,
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                S.of(context).please_give_your_rating,
                style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 12),
              Center(
                child: RatingBar.builder(
                  minRating: 1,
                  initialRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  unratedColor: Colors.grey.shade300,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_rounded,
                    color: AppColors.primaryColor,
                  ),
                  onRatingUpdate: (value) => _rating = value,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return S.of(context).write_your_comment_here;
                  }
                  return null;
                },
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: S.of(context).write_your_comment_here,
                  hintStyle: AppTextStyles.noto14w400.copyWith(
                    color: AppColors.grey,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5FAFD),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primaryColor.withOpacity(0.12),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ProfilePrimaryButton(
                title: S.of(context).send,
                isLoading: _sending,
                onPressed: _sending ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _sending = true);
    await context.read<ReviewCubit>().leaveReview(
      widget.productId.toString(),
      _rating.round(),
      _commentController.text.trim(),
    );
    if (!mounted) return;
    final state = context.read<ReviewCubit>().state;
    setState(() => _sending = false);
    if (state is ReviewError) {
      AppSnackBar.error(state.message.localizedMessage(context));
      return;
    }
    Navigator.of(context).pop();
    AppSnackBar.success(S.of(context).thank_you_for_your_rating);
    Navigator.pushNamed(context, Routes.thanksRate);
  }
}
