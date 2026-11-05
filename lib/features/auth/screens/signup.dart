import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/core/widgets/auto_disappearing_dialog.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/auth/widgets/auth_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthLoadedRegister) {
          final successTitle = S.of(context).accountCreatedSuccessfully;
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AutoDisappearingDialog(title: successTitle),
          );
          if (!context.mounted) return;
          Navigator.pushReplacementNamed(context, Routes.login);
        } else if (state is AuthErrorRegister) {
          AppSnackBar.error(state.error.localizedMessage(context));
        }
      },
      builder: (context, state) {
        return AuthScaffold(
          title: S.of(context).createAccount,
          subtitle: S.of(context).createAccountNowAndEnjoyExclusiveFeatures,
          logoSize: 72,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.greyBorder),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldCustomLabel(label: S.of(context).name),
                      CustomTextFormField(
                        controller: _nameController,
                        hintText: S.of(context).enterName,
                        keyboardType: TextInputType.name,
                        validator:
                            (value) => Validators.validateName(context, value),
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: AppPadding.medium),
                      TextFieldCustomLabel(label: S.of(context).email),
                      CustomTextFormField(
                        controller: _emailController,
                        hintText: S.of(context).enterEmailHere,
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            (value) => Validators.validateEmail(context, value),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: AppPadding.medium),
                      TextFieldCustomLabel(
                        label: '${S.of(context).phoneNumber} *',
                      ),
                      CustomTextFormField(
                        controller: _phoneController,
                        hintText: S.of(context).enterPhoneNumberHere,
                        keyboardType: TextInputType.phone,
                        validator:
                            (value) => Validators.validatePhone(context, value),
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: AppPadding.medium),
                      TextFieldCustomLabel(label: S.of(context).password),
                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: S.of(context).enterPasswordHere,
                        validator:
                            (value) =>
                                Validators.validatePassword(context, value),
                        isPassword: true,
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: AppPadding.medium),
                      TextFieldCustomLabel(
                        label: S.of(context).confirmPassword,
                      ),
                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        hintText: S.of(context).enterPasswordHere,
                        validator:
                            (value) => Validators.validatePasswordConfirm(
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
                      const SizedBox(height: 24),
                      AuthPrimaryButton(
                        title: S.of(context).createAccount,
                        onPressed: _submit,
                        isLoading: state is AuthLoading,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AuthFooterLink(
                  prompt: S.of(context).alreadyHaveAccount,
                  action: S.of(context).login,
                  onTap: () => Navigator.pushNamed(context, Routes.login),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
