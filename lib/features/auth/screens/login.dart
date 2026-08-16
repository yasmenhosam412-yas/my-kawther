import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/auth/widgets/auth_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: S.of(context).login,
      subtitle: S.of(context).welcomeBackPleaseEnterYourDetails,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldCustomLabel(label: S.of(context).email),
            CustomTextFormField(
              controller: _emailController,
              hintText: S.of(context).enterEmailHere,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.validateEmail(context, value),
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: AppPadding.medium),
            TextFieldCustomLabel(label: S.of(context).password),
            CustomTextFormField(
              controller: _passwordController,
              hintText: S.of(context).enterPasswordHere,
              validator: (value) => Validators.validatePassword(context, value),
              isPassword: true,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.forgetPassword);
                },
                child: Text(
                  S.of(context).forgotPassword,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            AuthPrimaryButton(
              title: S.of(context).login,
              onPressed: _submit,
            ),
            const SizedBox(height: 24),
            AuthFooterLink(
              prompt: S.of(context).dontHaveAnAccount,
              action: S.of(context).createAccount,
              onTap: () => Navigator.pushNamed(context, Routes.signup),
            ),
          ],
        ),
      ),
    );
  }
}
