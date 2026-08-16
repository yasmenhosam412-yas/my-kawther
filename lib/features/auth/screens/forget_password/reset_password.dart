import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/auto_disappearing_dialog.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/auth/widgets/auth_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AutoDisappearingDialog(
        title: S.of(context).passwordChangedSuccessfully,
      ),
    );

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: S.of(context).createNewPassword,
      subtitle: S.of(context).createNewPasswordDescription,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldCustomLabel(label: S.of(context).newPassword),
            CustomTextFormField(
              hintText: S.of(context).enterNewPasswordHere,
              controller: _passwordController,
              validator: (value) => Validators.validatePassword(context, value),
              isPassword: true,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: AppPadding.medium),
            TextFieldCustomLabel(label: S.of(context).confirmPassword),
            CustomTextFormField(
              hintText: S.of(context).confirmNewPasswordHere,
              controller: _confirmPasswordController,
              validator: (value) => Validators.validatePasswordConfirm(
                context,
                value,
                _passwordController.text,
              ),
              isPassword: true,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 28),
            AuthPrimaryButton(
              title: S.of(context).editPassword,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
