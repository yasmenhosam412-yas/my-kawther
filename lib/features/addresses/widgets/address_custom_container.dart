import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/widgets/confirm_delete_bottom_sheet.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';

class AddressCustomContainer extends StatelessWidget {
  const AddressCustomContainer({
    super.key,
    required this.selected,
    required this.addControlButtons,
    required this.addressModel,
    this.onEdit,
    this.onDelete,
    this.onShippingSelected,
    this.isToRefund,
  });

  final bool selected;
  final bool addControlButtons;
  final AddressModel addressModel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<AddressModel>? onShippingSelected;
  final bool? isToRefund;

  @override
  Widget build(BuildContext context) {
    final isPharmacy = addressModel.isPickupFromPharmacy;
    final canDelete = !isPharmacy && (addressModel.id != null);

    final typeTextStyle = AppTextStyles.noto16w400.copyWith(
      color: AppColors.darkColor,
    );

    final addressTextStyle = AppTextStyles.noto16w400.copyWith(
      color: AppColors.darkColor,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppPadding.small),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow:
            selected
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
        border: Border.all(
          color: selected ? AppColors.primaryColor : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(AppPadding.small),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(Assets.iconsMap),
                    const SizedBox(width: AppPadding.small),
                    Text(
                      getLocalizedType(addressModel.type, context) ?? '',
                      style: typeTextStyle,
                    ),
                  ],
                ),
                if (addControlButtons && canDelete)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final result = await showModalBottomSheet<bool>(
                            context: context,
                            builder: (bottomSheetContext) {
                              return BlocProvider.value(
                                value: context.read<AddressCubit>(),
                                child: ConfirmDeleteBottomSheet(
                                  label:
                                      S.of(context).deleteAddressConfirmation,
                                  id: addressModel.id!,
                                ),
                              );
                            },
                          );

                          if (result == true) {
                            onDelete?.call();
                          }
                        },
                        icon: SvgPicture.asset(
                          Assets.iconsDelete,
                          colorFilter: const ColorFilter.mode(
                            AppColors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:
                            onEdit ??
                            () {
                              Navigator.pushNamed(
                                context,
                                Routes.editAddress,
                                arguments: addressModel,
                              );
                            },
                        icon: SvgPicture.asset(
                          Assets.iconsEditAddress,
                          colorFilter: const ColorFilter.mode(
                            AppColors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        tooltip: S.of(context).edit,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppPadding.small),

          if (!isPharmacy)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    "${addressModel.address} - ${addressModel.apartment ?? ""}",
                    style: addressTextStyle,
                  ),
                ),
                const SizedBox(height: AppPadding.small),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    "${S.of(context).government} : ${addressModel.city ?? ""}",
                    style: addressTextStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text("${addressModel.address}", style: addressTextStyle),
            ),
          const SizedBox(height: AppPadding.small),
          (isToRefund == true)
              ? const SizedBox.shrink()
              : InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  onShippingSelected?.call(addressModel);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: selected,
                      onChanged: (value) {
                        onShippingSelected?.call(addressModel);
                      },
                    ),
                    Flexible(
                      child: Text(
                        isPharmacy
                            ? S.of(context).takeFromPharamcy
                            : S.of(context).useAsShippingAddress,
                        style: typeTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  getLocalizedType(String? type, BuildContext context) {
    switch (type?.toLowerCase()) {
      case "home":
        return S.of(context).homeAddress;
      case "work":
        return S.of(context).work;
      case "pharmacy":
        return S.of(context).takeFromPharamcy;
    }
  }
}
