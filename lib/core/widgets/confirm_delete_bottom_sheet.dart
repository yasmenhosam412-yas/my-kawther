import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';

class ConfirmDeleteBottomSheet extends StatefulWidget {
  const ConfirmDeleteBottomSheet({
    super.key,
    required this.label,
    required this.id,
  });

  final int id;
  final String label;

  @override
  State<ConfirmDeleteBottomSheet> createState() =>
      _ConfirmDeleteBottomSheetState();
}

class _ConfirmDeleteBottomSheetState extends State<ConfirmDeleteBottomSheet> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressCubitState>(
      listener: (context, state) {
        if (state is AddressLoadedState) {
          ToastMessage().displayMessageToast(
            S.of(context).loaded,
            AppColors.primaryColor,
          );
          Navigator.pop(context, true);
        } else if (state is AddressErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).unexpectedError)),
          );
          setState(() => isDeleting = false);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(30),
            left: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(AppPadding.large),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 2, color: Colors.grey[300]),
            const SizedBox(height: AppPadding.medium),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      side: const BorderSide(color: Colors.transparent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (!isDeleting) Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).no,
                      style: AppTextStyles.noto16w400.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppPadding.medium),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffDE1135),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                    ),
                    onPressed:
                        isDeleting
                            ? null
                            : () {
                              setState(() => isDeleting = true);
                              context.read<AddressCubit>().deleteAddress(
                                widget.id,
                                context,
                              );
                            },
                    child:
                        isDeleting
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              S.of(context).yes_delete,
                              style: AppTextStyles.noto16w400.copyWith(
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
