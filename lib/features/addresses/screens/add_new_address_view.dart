import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/toasts/toasts.dart';
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
  String? _deliveryPricesError;

  bool get _isEdit => widget.existing != null;
  bool get _isPharmacy => widget.existing?.isPharmacy == true;

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
        onPressed: _save,
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
                    suffixIcon: IconButton(
                      onPressed: () {
                        _landmarkController.text =
                            'https://maps.google.com/?q=Cairo';
                      },
                      icon: const Icon(
                        Icons.my_location_rounded,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).feildRequiredalso;
                      }
                      return null;
                    },
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<AddressCubit>();
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
      ToastMessage().displayMessageToast(
        S.of(context).addressUpdatedSuccess,
        AppColors.teal,
      );
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
      ToastMessage().displayMessageToast(
        S.of(context).addressAddedSuccess,
        AppColors.teal,
      );
    }
    if (mounted) Navigator.pop(context, true);
  }

  void _showAddressError(AddressCubitState state) {
    if (state is AddressErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message.localizedMessage(context))),
      );
    }
  }
}
