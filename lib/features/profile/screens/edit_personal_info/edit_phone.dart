import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/profile/data/profile_local_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';

class EditPhone extends StatefulWidget {
  const EditPhone({super.key});

  @override
  State<EditPhone> createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text:
          context.read<ProfileCubit>().userData?.phone ??
          ProfileLocalStore.instance.phone,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<ProfileCubit>();
    final current = cubit.userData;
    if (current == null || current.id == 0) {
      AppSnackBar.error(S.of(context).unexpectedError);
      return;
    }

    setState(() => _saving = true);
    await cubit.editDataUser(
      current.id,
      current.email,
      current.name,
      _phoneController.text.trim(),
      context,
    );
    if (!mounted) return;
    setState(() => _saving = false);

    final state = cubit.state;
    if (state is ProfileEditErrorState) {
      final message = state.message?.localizedMessage(context) ?? '';
      AppSnackBar.error(
        message.isEmpty ? S.of(context).unexpectedError : message,
      );
      return;
    }
    AppSnackBar.success(S.of(context).loaded);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ProfileScaffold(
      title: S.of(context).editPhoneNumber,
      subtitle: isAr ? 'حدّث رقم هاتفك' : 'Update your phone number',
      bottom: ProfilePrimaryButton(
        title: S.of(context).confirm,
        isLoading: _saving,
        onPressed: _saving ? null : _save,
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
                  TextFieldCustomLabel(label: S.of(context).phone_number),
                  CustomTextFormField(
                    hintText: S.of(context).enter_phone_number_here,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    validator: (value) =>
                        Validators.validatePhone(context, value),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppPadding.medium),
        ],
      ),
    );
  }
}
