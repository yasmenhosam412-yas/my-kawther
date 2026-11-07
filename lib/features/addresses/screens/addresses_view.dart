import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/features/profile/data/app_settings.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/features/home/widgets/shimmer_box.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
    context.watch<AppSettings>();

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
                      ? _AddressMessage(
                        icon: Icons.error_outline_rounded,
                        title: state.message.localizedMessage(context),
                        action: S.of(context).retry,
                        onAction:
                            () => context
                                .read<AddressCubit>()
                                .getAllAddresses(context),
                      )
                      : _AddressMessage(
                        icon: Icons.location_off_outlined,
                        title: S.of(context).noAddressesFound,
                        caption:
                            isAr
                                ? 'أضف عنوان توصيل أو اختر الاستلام من الصيدلية'
                                : 'Add a delivery address or choose pharmacy pickup',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 5, width: double.infinity, radius: 0),
                Padding(
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
              ],
            ),
          ),
    );
  }
}

String? _landmarkText(String? landmark) {
  final value = landmark?.trim() ?? '';
  if (value.isEmpty || value.startsWith('http')) return null;
  return value;
}

String? _mapLink(AddressModel address, bool isPharmacy) {
  final settingsMap = AppSettings.instance.mapUrl;
  final landmark = address.landmark?.trim() ?? '';
  final landmarkMap = landmark.startsWith('http') ? landmark : null;
  if (isPharmacy) return settingsMap ?? landmarkMap;
  return landmarkMap;
}

Future<void> _openMap(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
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

    final line = isPharmacy
        ? (address.address ?? '')
        : [
            address.address,
            if (address.apartment?.isNotEmpty == true) address.apartment,
          ].whereType<String>().where((part) => part.isNotEmpty).join(' · ');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(selected ? 0.14 : 0.07),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 5, color: color),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(icon, color: color),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              typeLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.noto16w400.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkColor,
                              ),
                            ),
                            if (selected) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
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
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line,
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.darkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (!isPharmacy &&
                            address.city?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${S.of(context).government}: ${address.city}',
                            style: AppTextStyles.noto14w400.copyWith(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                        if (_landmarkText(address.landmark) != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            _landmarkText(address.landmark)!,
                            style: AppTextStyles.noto14w400.copyWith(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                        if (_mapLink(address, isPharmacy) != null) ...[
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () => _openMap(_mapLink(address, isPharmacy)!),
                            child: Text(
                              S.of(context).location,
                              style: AppTextStyles.noto14w400.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: busy || address.id == null
                              ? null
                              : () => context
                                    .read<AddressCubit>()
                                    .toggleDefaultAddress(
                                      address.id!,
                                      context,
                                    ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: selected,
                                activeColor: color,
                                visualDensity: VisualDensity.compact,
                                onChanged: busy || address.id == null
                                    ? null
                                    : (_) => context
                                          .read<AddressCubit>()
                                          .toggleDefaultAddress(
                                            address.id!,
                                            context,
                                          ),
                              ),
                              Expanded(
                                child: Text(
                                  isPharmacy
                                      ? S.of(context).takeFromPharamcy
                                      : S.of(context).useAsShippingAddress,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.noto14w400.copyWith(
                                    color: AppColors.darkColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isPharmacy)
                        _RoundAction(
                          icon: Icons.delete_outline_rounded,
                          color: const Color(0xFFDC2626),
                          tooltip: S.of(context).yes_delete,
                          onPressed: busy ? null : () => _confirmDelete(context),
                        ),
                      const SizedBox(width: 6),
                      _RoundAction(
                        icon: Icons.edit_outlined,
                        color: AppColors.primaryColor,
                        tooltip: S.of(context).edit,
                        onPressed: busy
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.editAddress,
                                  arguments: address,
                                );
                              },
                      ),
                    ],
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

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        disabledBackgroundColor: AppColors.grey2,
        fixedSize: const Size(40, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 18),
    );
  }
}

class _AddressMessage extends StatelessWidget {
  const _AddressMessage({
    required this.icon,
    required this.title,
    this.caption,
    this.action,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? caption;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(icon, size: 36, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.noto16w400.copyWith(
                color: AppColors.darkColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (caption != null) ...[
              const SizedBox(height: 4),
              Text(
                caption!,
                textAlign: TextAlign.center,
                style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 14),
              TextButton(onPressed: onAction, child: Text(action!)),
            ],
          ],
        ),
      ),
    );
  }
}
