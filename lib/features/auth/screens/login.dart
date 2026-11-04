import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/auth/widgets/auth_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

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
    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadedLogin) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.home,
            (route) => false,
          );
        } else if (state is AuthErrorLogin) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              _buildErrorSnackBar(_loginErrorMessage(state.error, context)),
            );
        }
      },
      builder: (context, state) {
        return AuthScaffold(
          title: S.of(context).login,
          subtitle: S.of(context).welcomeBackPleaseEnterYourDetails,
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
                      const SizedBox(height: 16),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.forgetPassword);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: const Size(0, 36),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            S.of(context).forgotPassword,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthPrimaryButton(
                        title: S.of(context).login,
                        onPressed: _submit,
                        isLoading: state is AuthLoading,
                      ),
                    ],
                  ),
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
      },
    );
  }

  SnackBar _buildErrorSnackBar(String message) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFFB42318),
      elevation: 8,
      duration: const Duration(seconds: 5),
      dismissDirection: DismissDirection.horizontal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _loginErrorMessage(Errors error, BuildContext context) {
    final normalizedMessage = error.message.trim().toLowerCase();
    final isInvalidCredentials =
        error.statusCode == 401 ||
        normalizedMessage == 'unauthorized' ||
        normalizedMessage.contains('invalid credential') ||
        normalizedMessage.contains('incorrect email') ||
        normalizedMessage.contains('wrong password');

    return isInvalidCredentials
        ? S.of(context).wrong_email_pass
        : error.localizedMessage(context);
  }
}
