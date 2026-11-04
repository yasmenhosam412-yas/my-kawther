import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showDisplayAddressesBottomSheet(
  BuildContext context, {
  required ValueChanged<AddressModel> onAddressSelected,
  AddressModel? selectedAddress,
}) async {
  final cubit = context.read<AddressCubit>();
  if (cubit.addresses == null) {
    await cubit.getAllAddresses(context);
    if (!context.mounted) return;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => BlocProvider.value(
          value: cubit,
          child: _AddressPicker(
            selectedAddress: selectedAddress,
            onAddressSelected: onAddressSelected,
          ),
        ),
  );
}

class _AddressPicker extends StatelessWidget {
  const _AddressPicker({required this.onAddressSelected, this.selectedAddress});

  final AddressModel? selectedAddress;
  final ValueChanged<AddressModel> onAddressSelected;

  @override
  Widget build(BuildContext context) {
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
            child: BlocBuilder<AddressCubit, AddressCubitState>(
              builder: (context, state) {
                final addresses = context.watch<AddressCubit>().addresses ?? [];
                if (state is AddressLoadingState && addresses.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AddressErrorState && addresses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message.localizedMessage(context),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed:
                              () => context
                                  .read<AddressCubit>()
                                  .getAllAddresses(context),
                          child: Text(S.of(context).retry),
                        ),
                      ],
                    ),
                  );
                }
                if (addresses.isEmpty) {
                  return Center(child: Text(S.of(context).noAddressesFound));
                }
                final selectedId =
                    selectedAddress?.id ??
                    context.read<AddressCubit>().getDefaultAddress()?.id;
                return ListView.separated(
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    final selected = address.id == selectedId;
                    final isPharmacy =
                        address.isPharmacy == true ||
                        (address.type ?? '').toLowerCase() == 'pharmacy';
                    final color =
                        isPharmacy ? AppColors.teal : AppColors.primaryColor;
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Navigator.pop(context);
                          onAddressSelected(address);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected ? color : color.withOpacity(0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isPharmacy
                                    ? Icons.local_pharmacy_rounded
                                    : Icons.location_on_rounded,
                                color: color,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address.address ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.noto14w400.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.darkColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      address.city?.isNotEmpty == true
                                          ? address.city!
                                          : S.of(context).takeFromPharamcy,
                                      style: AppTextStyles.noto14w400.copyWith(
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
  }
}
