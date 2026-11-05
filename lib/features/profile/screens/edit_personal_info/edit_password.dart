import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ProfileScaffold(
      title: S.of(context).editPassword,
      subtitle: isAr ? 'عيّن كلمة مرور جديدة' : 'Set a new password',
      bottom: ProfilePrimaryButton(
        title: S.of(context).confirm,
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          AppSnackBar.success(S.of(context).loaded);
          Navigator.pop(context);
        },
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
