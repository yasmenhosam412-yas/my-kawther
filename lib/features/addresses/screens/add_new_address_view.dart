import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/addresses/widgets/address_radio_buttons.dart';
import 'package:elkawther/features/checkout/data/checkout_local_store.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

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
  late final TextEditingController _apartmentController;
  late final TextEditingController _landmarkController;
  late String _type;
  late String _city;

  bool get _isEdit => widget.existing != null;
  bool get _isPharmacy => widget.existing?.isPharmacy == true;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _addressController = TextEditingController(text: existing?.address ?? '');
    _apartmentController = TextEditingController(text: existing?.apartment ?? '');
    _landmarkController = TextEditingController(text: existing?.landmark ?? '');
    _type = existing?.type ?? 'home';
    _city = CheckoutLocalStore.cities.contains(existing?.city)
        ? existing!.city!
        : CheckoutLocalStore.cities.first;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _apartmentController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = CheckoutLocalStore.instance;
    final fee = store.deliveryFeeForType(_type, isPharmacy: _isPharmacy);

    return ProfileScaffold(
      title: _isEdit ? S.of(context).editAddress : S.of(context).addNewAddress,
      subtitle: isAr
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
                    validator: (value) =>
                        Validators.validateName(context, value),
                  ),
                  const SizedBox(height: 14),
                  TextFieldCustomLabel(label: S.of(context).government),
                  DropdownButtonFormField<String>(
                    value: _city,
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
                    items: CheckoutLocalStore.cities
                        .map(
                          (city) => DropdownMenuItem(
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
                  if (!_isPharmacy) ...[
                    const SizedBox(height: 14),
                    TextFieldCustomLabel(label: S.of(context).apartmentNumber),
                    CustomTextFormField(
                      hintText: S.of(context).enterApartmentNumber,
                      controller: _apartmentController,
                      validator: (value) =>
                          Validators.validateName(context, value),
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
                    child: Text(
                      '${fee.toStringAsFixed(0)} ${S.of(context).currency}',
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final store = CheckoutLocalStore.instance;
    final model = AddressModel(
      id: widget.existing?.id ?? store.nextId(),
      address: _addressController.text.trim(),
      city: _city,
      governorate: _city,
      apartment: _apartmentController.text.trim(),
      landmark: _landmarkController.text.trim(),
      type: _isPharmacy ? 'pharmacy' : _type,
      isDefault: widget.existing?.isDefault ?? false,
      isPharmacy: _isPharmacy,
    );
    if (_isEdit) {
      store.update(model);
      ToastMessage().displayMessageToast(
        S.of(context).addressUpdatedSuccess,
        AppColors.teal,
      );
    } else {
      store.add(model);
      ToastMessage().displayMessageToast(
        S.of(context).addressAddedSuccess,
        AppColors.teal,
      );
    }
    Navigator.pop(context);
  }
}
