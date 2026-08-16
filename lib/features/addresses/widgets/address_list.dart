import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/features/addresses/widgets/address_custom_container.dart';

class AddressList extends StatelessWidget {
  const AddressList({super.key});

  @override
  Widget build(BuildContext context) {
    final addresses = context.watch<AddressCubit>().addresses ?? [];

    return ListView.separated(
      padding: const EdgeInsets.all(AppPadding.medium),
      itemCount: addresses.length,
      separatorBuilder:
          (context, index) => const SizedBox(height: AppPadding.medium),
      itemBuilder: (context, index) {
        final address = addresses[index];
        final isSelected = address.isDefault == true;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AddressCustomContainer(
            addressModel: address,
            selected: isSelected,
            addControlButtons: true,
            onDelete: () async {
              await context.read<AddressCubit>().getAllAddresses(context);
            },
            onShippingSelected: (selectedAddress) {
              final cubit = context.read<AddressCubit>();
              final addresses = cubit.addresses ?? [];

              final updatedAddresses =
                  addresses.map((addr) {
                    if (addr.id == selectedAddress.id) {
                      return addr.copyWith(isDefault: true);
                    } else if (addr.isDefault == true) {
                      return addr.copyWith(isDefault: false);
                    }
                    return addr;
                  }).toList();

              cubit.setAddresses(updatedAddresses);

              if (selectedAddress.id != null) {
                cubit
                    .toggleDefaultAddress(selectedAddress.id!, context)
                    .catchError((error) {
                      if (!context.mounted) return;
                      cubit.getAllAddresses(context);
                    });
              }
            },
          ),
        );
      },
    );
  }
}
