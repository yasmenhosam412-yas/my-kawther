import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/features/checkout/data/checkout_local_store.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddressesView extends StatelessWidget {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = CheckoutLocalStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final addresses = store.addresses;
        return ProfileScaffold(
          title: S.of(context).addressesTitle,
          subtitle: isAr
              ? 'عناوين التوصيل والاستلام من الصيدلية'
              : 'Delivery and pharmacy pickup addresses',
          bottom: ProfilePrimaryButton(
            title: S.of(context).addNewAddressButton,
            onPressed: () => Navigator.pushNamed(context, Routes.addNewAddress),
          ),
          body: addresses.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_off_outlined,
                          size: 56,
                          color: AppColors.grey.withOpacity(0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          S.of(context).noAddressesFound,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return _AddressCard(
                      address: address,
                      selected: address.isDefault,
                    );
                  },
                ),
        );
      },
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.selected});

  final AddressModel address;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final isPharmacy = address.isPharmacy == true ||
        (address.type ?? '').toLowerCase() == 'pharmacy';
    final color = isPharmacy
        ? AppColors.teal
        : (address.type ?? '').toLowerCase() == 'work'
            ? const Color(0xFF7C3AED)
            : AppColors.primaryColor;
    final icon = isPharmacy
        ? Icons.local_pharmacy_rounded
        : (address.type ?? '').toLowerCase() == 'work'
            ? Icons.work_outline_rounded
            : Icons.home_rounded;
    final typeLabel = isPharmacy
        ? S.of(context).takeFromPharamcy
        : (address.type ?? '').toLowerCase() == 'work'
            ? S.of(context).work
            : S.of(context).homeAddress;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? color : color.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(selected ? 0.14 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  typeLabel,
                  style: AppTextStyles.noto16w400.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
              ),
              if (!isPharmacy)
                IconButton(
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.grey,
                  ),
                ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.editAddress,
                    arguments: address,
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.grey,
                ),
                tooltip: S.of(context).edit,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isPharmacy
                ? (address.address ?? '')
                : '${address.address ?? ''} - ${address.apartment ?? ''}',
            style: AppTextStyles.noto14w400.copyWith(
              color: AppColors.darkColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!isPharmacy) ...[
            const SizedBox(height: 4),
            Text(
              '${S.of(context).government} : ${address.city ?? ''}',
              style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
            ),
          ],
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (address.id != null) {
                CheckoutLocalStore.instance.setDefault(address.id!);
              }
            },
            child: Row(
              children: [
                Checkbox(
                  value: selected,
                  activeColor: color,
                  onChanged: (_) {
                    if (address.id != null) {
                      CheckoutLocalStore.instance.setDefault(address.id!);
                    }
                  },
                ),
                Expanded(
                  child: Text(
                    isPharmacy
                        ? S.of(context).takeFromPharamcy
                        : S.of(context).useAsShippingAddress,
                    style: AppTextStyles.noto14w400.copyWith(
                      color: AppColors.darkColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyBorder,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).deleteAddressConfirmation,
                textAlign: TextAlign.center,
                style: AppTextStyles.noto16w400.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkColor,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.darkColor,
                        side: BorderSide(
                          color: AppColors.primaryColor.withOpacity(0.16),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(S.of(context).no),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDE1135),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(S.of(context).yes_delete),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true && address.id != null) {
      CheckoutLocalStore.instance.remove(address.id!);
      if (context.mounted) {
        ToastMessage().displayMessageToast(
          S.of(context).loaded,
          AppColors.primaryColor,
        );
      }
    }
  }
}
