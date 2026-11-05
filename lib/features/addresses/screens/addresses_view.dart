import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/features/home/widgets/shimmer_box.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({super.key});

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.read<AddressCubit>().addresses == null) {
        context.read<AddressCubit>().getAllAddresses(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocConsumer<AddressCubit, AddressCubitState>(
      listener: (context, state) {
        if (state is AddressErrorState) {
          AppSnackBar.error(state.message.localizedMessage(context));
        }
      },
      builder: (context, state) {
        final addresses = context.read<AddressCubit>().addresses ?? [];
        final isLoading = state is AddressLoadingState;
        return ProfileScaffold(
          title: S.of(context).addressesTitle,
          subtitle:
              isAr
                  ? 'عناوين التوصيل والاستلام من الصيدلية'
                  : 'Delivery and pharmacy pickup addresses',
          bottom: ProfilePrimaryButton(
            title: S.of(context).addNewAddressButton,
            onPressed: () => Navigator.pushNamed(context, Routes.addNewAddress),
          ),
          body:
              addresses.isEmpty
                  ? isLoading
                      ? const _AddressesLoadingList()
                      : state is AddressErrorState
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.message.localizedMessage(context),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed:
                                  () => context
                                      .read<AddressCubit>()
                                      .getAllAddresses(context),
                              child: Text(S.of(context).retry),
                            ),
                          ],
                        ),
                      )
                      : Center(
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
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return _AddressCard(
                        address: address,
                        selected: address.isDefault,
                        busy: isLoading,
                      );
                    },
                  ),
        );
      },
    );
  }
}

class _AddressesLoadingList extends StatelessWidget {
  const _AddressesLoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder:
          (context, index) => const DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShimmerBox(height: 42, width: 42, radius: 13),
                      SizedBox(width: 10),
                      ShimmerBox(height: 16, width: 100, radius: 8),
                      Spacer(),
                      ShimmerBox(height: 38, width: 38, radius: 12),
                      SizedBox(width: 6),
                      ShimmerBox(height: 38, width: 38, radius: 12),
                    ],
                  ),
                  SizedBox(height: 16),
                  ShimmerBox(height: 14, width: 210, radius: 7),
                  SizedBox(height: 8),
                  ShimmerBox(height: 12, width: 130, radius: 6),
                  SizedBox(height: 14),
                  ShimmerBox(height: 16, width: double.infinity, radius: 8),
                ],
              ),
            ),
          ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.selected,
    required this.busy,
  });

  final AddressModel address;
  final bool selected;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final isPharmacy =
        address.isPharmacy == true ||
        (address.type ?? '').toLowerCase() == 'pharmacy';
    final color =
        isPharmacy
            ? AppColors.teal
            : (address.type ?? '').toLowerCase() == 'work'
            ? const Color(0xFF7C3AED)
            : AppColors.primaryColor;
    final icon =
        isPharmacy
            ? Icons.local_pharmacy_rounded
            : (address.type ?? '').toLowerCase() == 'work'
            ? Icons.work_outline_rounded
            : Icons.home_rounded;
    final typeLabel =
        isPharmacy
            ? S.of(context).takeFromPharamcy
            : (address.type ?? '').toLowerCase() == 'work'
            ? S.of(context).work
            : S.of(context).homeAddress;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : color.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(selected ? 0.10 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    typeLabel,
                    style: AppTextStyles.noto16w400.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkColor,
                    ),
                  ),
                ),
                if (selected) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      S.of(context).defultAddress,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                if (!isPharmacy)
                  IconButton(
                    onPressed: busy ? null : () => _confirmDelete(context),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.grey,
                    ),
                    tooltip: S.of(context).yes_delete,
                  ),
                IconButton(
                  onPressed:
                      busy
                          ? null
                          : () {
                            Navigator.pushNamed(
                              context,
                              Routes.editAddress,
                              arguments: address,
                            );
                          },
                  icon: const Icon(Icons.edit_outlined, color: AppColors.grey),
                  tooltip: S.of(context).edit,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isPharmacy
                  ? (address.address ?? '')
                  : [
                        address.address,
                        if (address.apartment?.isNotEmpty == true)
                          address.apartment,
                      ]
                      .whereType<String>()
                      .where((part) => part.isNotEmpty)
                      .join(' - '),
              style: AppTextStyles.noto14w400.copyWith(
                color: AppColors.darkColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (!isPharmacy && address.city?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                '${S.of(context).government} : ${address.city}',
                style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
              ),
            ],
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap:
                  busy || address.id == null
                      ? null
                      : () => context.read<AddressCubit>().toggleDefaultAddress(
                        address.id!,
                        context,
                      ),
              child: Row(
                children: [
                  Checkbox(
                    value: selected,
                    activeColor: color,
                    onChanged:
                        busy || address.id == null
                            ? null
                            : (_) => context
                                .read<AddressCubit>()
                                .toggleDefaultAddress(address.id!, context),
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
      if (!context.mounted) return;
      await context.read<AddressCubit>().deleteAddress(address.id!, context);
      if (!context.mounted) return;
      if (context.read<AddressCubit>().state is AddressErrorState) return;
      AppSnackBar.success(S.of(context).loaded);
    }
  }
}
