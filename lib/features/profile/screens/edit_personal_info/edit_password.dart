import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/custom_password_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<ProfileCubit>();
    setState(() => _saving = true);
    await cubit.changePassword(
      _passwordController.text,
      _confirmPasswordController.text,
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
    final success = state is ProfileEditPassSuccessState
        ? state.message
        : S.of(context).loaded;
    AppSnackBar.success(success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ProfileScaffold(
      title: S.of(context).editPassword,
      subtitle: isAr ? 'عيّن كلمة مرور جديدة' : 'Set a new password',
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
                  TextFieldCustomLabel(label: S.of(context).newPassword),
                  CustomPasswordFormField(
                    hintText: S.of(context).enterNewPasswordHere,
                    controller: _passwordController,
                    validator: (value) =>
                        Validators.validatePassword(context, value),
                  ),
                  const SizedBox(height: AppPadding.medium),
                  TextFieldCustomLabel(label: S.of(context).confirmPassword),
                  CustomPasswordFormField(
                    hintText: S.of(context).confirmNewPasswordHere,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return S.of(context).passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
