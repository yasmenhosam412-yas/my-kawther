import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/widgets/pin_code.dart';
import 'package:elkawther/features/auth/widgets/auth_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: S.of(context).enterVerificationCode,
      subtitle: S.of(context).verificationCodeDescription,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            PinCode(controller: _otpController),
            const SizedBox(height: AppPadding.medium),
            AuthFooterLink(
              prompt: S.of(context).didntReceiveCode,
              action: S.of(context).resendOTP,
              onTap: () {},
            ),
            const SizedBox(height: 28),
            AuthPrimaryButton(
              title: S.of(context).send,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final email = ModalRoute.of(context)?.settings.arguments;
                  Navigator.pushNamed(
                    context,
                    Routes.resetPassword,
                    arguments: email is String ? email : '',
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
