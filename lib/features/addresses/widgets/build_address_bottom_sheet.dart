import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/checkout/data/checkout_local_store.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

void showDisplayAddressesBottomSheet(
  BuildContext context, {
  required Function(AddressModel selectedAddress) onAddressSelected,
}) {
  final store = CheckoutLocalStore.instance;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        height: MediaQuery.sizeOf(context).height * 0.62,
        decoration: const BoxDecoration(
          color: Color(0xFFF5FAFD),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightDarker,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                S.of(context).please_select_address,
                style: AppTextStyles.noto16w400.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkColor,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListenableBuilder(
                listenable: store,
                builder: (context, _) {
                  return ListView.separated(
                    itemCount: store.addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, index) {
                      final address = store.addresses[index];
                      final selected = address.id == store.current.id;
                      final color = address.isPharmacy == true
                          ? AppColors.teal
                          : AppColors.primaryColor;
                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            store.select(address);
                            Navigator.pop(context);
                            onAddressSelected(address);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: selected
                                    ? color
                                    : color.withOpacity(0.08),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  address.isPharmacy == true
                                      ? Icons.local_pharmacy_rounded
                                      : Icons.location_on_rounded,
                                  color: color,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address.address ?? '',
                                        style: AppTextStyles.noto14w400
                                            .copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.darkColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        address.city?.isNotEmpty == true
                                            ? address.city!
                                            : S.of(context).takeFromPharamcy,
                                        style:
                                            AppTextStyles.noto14w400.copyWith(
                                          fontSize: 12,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (address.isDefault)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.teal.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      S.of(context).defultAddress,
                                      style: AppTextStyles.noto14w400.copyWith(
                                        color: AppColors.teal,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
