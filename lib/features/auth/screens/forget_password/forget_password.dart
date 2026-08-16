import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/auth/widgets/auth_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: S.of(context).forgotPassword,
      subtitle: S.of(context).dontWorry,
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
            const SizedBox(height: AppPadding.xLarge),
            AuthPrimaryButton(
              title: S.of(context).next,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pushNamed(
                    context,
                    Routes.verifyEmail,
                    arguments: _emailController.text,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
