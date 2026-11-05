import 'dart:async';

import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/addresses/widgets/address_radio_buttons.dart';
import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/features/checkout/data/checkout_local_store.dart';
import 'package:elkawther/features/checkout/models/delivery_prices.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class AddNewAddressView extends StatelessWidget {
  const AddNewAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AddressEditor();
  }
}

class EditAddressView extends StatelessWidget {
  final AddressModel addNewAddress;

  const EditAddressView({super.key, required this.addNewAddress});

  @override
  Widget build(BuildContext context) {
    return _AddressEditor(existing: addNewAddress);
  }
}

class _AddressEditor extends StatefulWidget {
  const _AddressEditor({this.existing});

  final AddressModel? existing;

  @override
  State<_AddressEditor> createState() => _AddressEditorState();
}

class _AddressEditorState extends State<_AddressEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;
  late final TextEditingController _streetController;
  late final TextEditingController _apartmentController;
  late final TextEditingController _landmarkController;
  late String _type;
  late String _city;
  List<DeliveryPrice> _deliveryPrices = [];
  bool _isLoadingDeliveryPrices = true;
  bool _isSaving = false;
  bool _isGettingLocation = false;
  bool _hasCurrentLocation = false;
  String? _deliveryPricesError;

  bool get _isEdit => widget.existing != null;
  bool get _isPharmacy => widget.existing?.isPickupFromPharmacy == true;

  double? get _deliveryFee {
    if (_isPharmacy) return 0;
    for (final deliveryPrice in _deliveryPrices) {
      if (deliveryPrice.governorate.trim().toLowerCase() ==
          _city.trim().toLowerCase()) {
        return double.tryParse(deliveryPrice.price);
      }
    }
    return null;
  }

  Future<void> _loadDeliveryPrices() async {
    final profileCubit = context.read<ProfileCubit>();
    var prices = profileCubit.deliveryPrices;

    if (prices == null) {
      await profileCubit.getDeliveryPricesAndCities();
      prices = profileCubit.deliveryPrices;
    }

    if (!mounted) return;

    final state = profileCubit.state;
    setState(() {
      _isLoadingDeliveryPrices = false;
      _deliveryPrices = prices ?? [];
      _deliveryPricesError =
          state is ProfileCubitDeliveryPricesErrorState
              ? state.message.localizedMessage(context)
              : prices == null || prices.isEmpty
              ? (Localizations.localeOf(context).languageCode == 'ar'
                  ? 'لا توجد أسعار توصيل متاحة'
                  : 'No delivery prices are available')
              : null;

      final selectedCity =
          _deliveryPrices
              .map((price) => price.governorate)
              .where((city) => city.toLowerCase() == _city.toLowerCase())
              .firstOrNull;
      if (selectedCity != null) {
        _city = selectedCity;
      } else if (_deliveryPrices.isNotEmpty) {
        _city = _deliveryPrices.first.governorate;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _addressController = TextEditingController(text: existing?.address ?? '');
    _streetController = TextEditingController(text: existing?.street ?? '');
    _apartmentController = TextEditingController(
      text: existing?.apartment ?? '',
    );
    _landmarkController = TextEditingController(text: existing?.landmark ?? '');
    _type = existing?.type ?? 'home';
    _city =
        CheckoutLocalStore.cities.contains(existing?.city)
            ? existing!.city!
            : CheckoutLocalStore.cities.first;
    _loadDeliveryPrices();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _streetController.dispose();
    _apartmentController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final fee = _deliveryFee;

    return ProfileScaffold(
      title: _isEdit ? S.of(context).editAddress : S.of(context).addNewAddress,
      subtitle:
          isAr
              ? 'أدخل تفاصيل العنوان للتوصيل'
              : 'Enter address details for delivery',
      bottom: ProfilePrimaryButton(
        title: _isEdit ? S.of(context).save : S.of(context).add,
        onPressed: _isSaving ? null : _save,
        isLoading: _isSaving,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ProfileFormCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldCustomLabel(label: S.of(context).address),
                  CustomTextFormField(
                    hintText: S.of(context).enterAddress,
                    controller: _addressController,
                    validator:
                        (value) => Validators.validateName(context, value),
                  ),
                  const SizedBox(height: 14),
                  TextFieldCustomLabel(label: S.of(context).enterstreet),
                  CustomTextFormField(
                    hintText: S.of(context).enter_street_num,
                    controller: _streetController,
                    validator:
                        (value) => Validators.validateName(context, value),
                  ),
                  const SizedBox(height: 14),
                  TextFieldCustomLabel(label: S.of(context).government),
                  DropdownButtonFormField<String>(
                    value:
                        (_deliveryPrices.isEmpty
                                    ? CheckoutLocalStore.cities
                                    : _deliveryPrices
                                        .map((price) => price.governorate)
                                        .toList())
                                .contains(_city)
                            ? _city
                            : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF5FAFD),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor.withOpacity(0.12),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    items:
                        (_deliveryPrices.isEmpty
                                ? CheckoutLocalStore.cities
                                : _deliveryPrices
                                    .map((price) => price.governorate)
                                    .toList())
                            .toSet()
                            .map(
                              (city) => DropdownMenuItem<String>(
                                value: city,
                                child: Text(
                                  city,
                                  style: AppTextStyles.noto14w400.copyWith(
                                    color: AppColors.darkColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _city = value);
                    },
                  ),
                  if (_deliveryPricesError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _deliveryPricesError!,
                      style: AppTextStyles.noto14w400.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLoadingDeliveryPrices = true;
                          _deliveryPricesError = null;
                        });
                        _loadDeliveryPrices();
                      },
                      child: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
                    ),
                  ],
                  if (!_isPharmacy) ...[
                    const SizedBox(height: 14),
                    TextFieldCustomLabel(label: S.of(context).apartmentNumber),
                    CustomTextFormField(
                      hintText: S.of(context).enterApartmentNumber,
                      controller: _apartmentController,
                      validator:
                          (value) => Validators.validateName(context, value),
                    ),
                  ],
                  const SizedBox(height: 14),
                  TextFieldCustomLabel(label: S.of(context).location),
                  CustomTextFormField(
                    hintText: S.of(context).enterTheSiteHere,
                    controller: _landmarkController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).feildRequiredalso;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed:
                          _isGettingLocation ? null : _useCurrentLocation,
                      icon:
                          _isGettingLocation
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Icon(
                                _hasCurrentLocation
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.my_location_rounded,
                              ),
                      label: Text(
                        _isGettingLocation
                            ? (isAr
                                ? 'جارٍ تحديد موقعك...'
                                : 'Getting your location...')
                            : _hasCurrentLocation
                            ? (isAr
                                ? 'تم تحديد موقعك الحالي'
                                : 'Current location selected')
                            : (isAr
                                ? 'استخدم موقعي الحالي'
                                : 'Use my current location'),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        side: BorderSide(
                          color: AppColors.primaryColor.withOpacity(0.3),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAr
                        ? 'سيتم حفظ رابط الخريطة بإحداثيات موقعك'
                        : 'A map link with your coordinates will be saved',
                    style: AppTextStyles.noto14w400.copyWith(
                      color: AppColors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFieldCustomLabel(label: S.of(context).deliveryValue),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5FAFD),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.12),
                      ),
                    ),
                    child:
                        _isLoadingDeliveryPrices
                            ? const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                            : Text(
                              fee == null
                                  ? (isAr
                                      ? 'غير متاح لهذه المحافظة'
                                      : 'Unavailable for this governorate')
                                  : '${fee.toStringAsFixed(0)} ${S.of(context).currency}',
                              style: AppTextStyles.noto14w400.copyWith(
                                fontWeight: FontWeight.w800,
                                color:
                                    fee == null
                                        ? Colors.red
                                        : AppColors.darkColor,
                              ),
                            ),
                  ),
                  if (!_isPharmacy) ...[
                    const SizedBox(height: 14),
                    TextFieldCustomLabel(label: S.of(context).addressType),
                    AddressRadioButtons(
                      initialValue: _type,
                      onChanged: (value) => setState(() => _type = value),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    if (_isGettingLocation) return;
    setState(() {
      _isGettingLocation = true;
      _hasCurrentLocation = false;
    });

    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationMessage(
          isAr
              ? 'فعّل خدمة الموقع في جهازك ثم حاول مرة أخرى.'
              : 'Turn on location services on your device and try again.',
          isAr ? 'الإعدادات' : 'Settings',
          Geolocator.openLocationSettings,
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        _showLocationMessage(
          isAr
              ? 'لم يتم منح إذن الموقع. اسمح بالوصول للموقع لاستخدام هذه الميزة.'
              : 'Location permission was denied. Allow location access to use this feature.',
        );
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          isAr
              ? 'إذن الموقع مرفوض نهائيًا. فعّله من إعدادات التطبيق.'
              : 'Location permission is permanently denied. Enable it in app settings.',
          isAr ? 'الإعدادات' : 'Settings',
          Geolocator.openAppSettings,
        );
        return;
      }
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showLocationMessage(
          isAr
              ? 'إذن الموقع غير متاح. تحقق من إعدادات التطبيق ثم حاول مرة أخرى.'
              : 'Location permission is unavailable. Check app settings and try again.',
          isAr ? 'الإعدادات' : 'Settings',
          Geolocator.openAppSettings,
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
      );
      if (!mounted) return;

      final mapUri = Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': '${position.latitude},${position.longitude}',
      });
      _landmarkController.text = mapUri.toString();
      setState(() => _hasCurrentLocation = true);
    } on TimeoutException {
      _showLocationMessage(
        isAr
            ? 'استغرق تحديد الموقع وقتًا طويلًا. حاول مرة أخرى.'
            : 'Getting your location timed out. Please try again.',
      );
    } on LocationServiceDisabledException {
      _showLocationMessage(
        isAr
            ? 'خدمة الموقع متوقفة. فعّلها ثم حاول مرة أخرى.'
            : 'Location services are disabled. Turn them on and try again.',
        isAr ? 'الإعدادات' : 'Settings',
        Geolocator.openLocationSettings,
      );
    } on PermissionDeniedException {
      _showLocationMessage(
        isAr
            ? 'تعذّر الوصول إلى موقعك. تحقق من إذن الموقع في إعدادات التطبيق.'
            : 'Could not access your location. Check the app location permission.',
        isAr ? 'الإعدادات' : 'Settings',
        Geolocator.openAppSettings,
      );
    } on PlatformException {
      _showLocationMessage(
        isAr
            ? 'تعذّر تحديد الموقع. تحقق من إعدادات الموقع وحاول مرة أخرى.'
            : 'Could not get your location. Check location settings and try again.',
      );
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  void _showLocationMessage(
    String message, [
    String? actionLabel,
    Future<bool> Function()? onAction,
  ]) {
    if (!mounted) return;
    AppSnackBar.show(
      message,
      actionLabel: actionLabel,
      onAction: onAction == null ? null : () async => onAction(),
    );
  }

  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final cubit = context.read<AddressCubit>();
    try {
      if (_isEdit) {
        final id = widget.existing?.id;
        if (id == null) return;
        await cubit.editAddress(
          id,
          _addressController.text.trim(),
          _city,
          _city,
          _apartmentController.text.trim(),
          _landmarkController.text.trim(),
          _isPharmacy ? 'pharmacy' : _type,
          _streetController.text.trim(),
          context,
        );
        if (!mounted) return;
        if (cubit.state is! AddressEditedLoadedState) {
          _showAddressError(cubit.state);
          return;
        }
        AppSnackBar.success(S.of(context).addressUpdatedSuccess);
      } else {
        await cubit.addAddress(
          _addressController.text.trim(),
          _city,
          _city,
          _streetController.text.trim(),
          _landmarkController.text.trim(),
          _isPharmacy ? 'pharmacy' : _type,
          _apartmentController.text.trim(),
          context,
        );
        if (!mounted) return;
        if (cubit.state is! AddressAddedLoadedState) {
          _showAddressError(cubit.state);
          return;
        }
        AppSnackBar.success(S.of(context).addressAddedSuccess);
      }
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showAddressError(AddressCubitState state) {
    if (state is AddressErrorState) {
      AppSnackBar.error(state.message.localizedMessage(context));
    }
  }
}
