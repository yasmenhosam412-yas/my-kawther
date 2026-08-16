import 'package:elkawther/features/profile/data/profile_local_store.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/core/toasts/toasts.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({super.key});

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: ProfileLocalStore.instance.email,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ProfileScaffold(
      title: S.of(context).editEmail,
      subtitle: isAr ? 'حدّث بريدك الإلكتروني' : 'Update your email address',
      bottom: ProfilePrimaryButton(
        title: S.of(context).confirm,
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          final updated = _emailController.text.trim();
          if (updated == ProfileLocalStore.instance.email) {
            ToastMessage().displayMessageToast(
              S.of(context).yourEmailAlready,
              Colors.red.shade800,
            );
            return;
          }
          ProfileLocalStore.instance.email = updated;
          ToastMessage().displayMessageToast(
            S.of(context).loaded,
            AppColors.primaryColor,
          );
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
                  TextFieldCustomLabel(label: S.of(context).email),
                  CustomTextFormField(
                    hintText: S.of(context).enterEmailHere,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) =>
                        Validators.validateEmail(context, value),
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
