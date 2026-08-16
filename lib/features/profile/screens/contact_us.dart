import 'package:elkawther/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/success_dialog.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        imagePath: Assets.imagesSuccess2,
        name: S.of(context).successMessage,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.home);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final links = [
      _ContactLink(
        title: S.of(context).phone,
        icon: Icons.chat_rounded,
        color: const Color(0xFF16A34A),
        onTap: () => _launchUrl('https://wa.me/201012345678'),
      ),
      _ContactLink(
        title: S.of(context).location,
        icon: Icons.location_on_rounded,
        color: const Color(0xFFEF4444),
        onTap: () => _launchUrl('https://maps.google.com/?q=Cairo'),
      ),
      _ContactLink(
        title: S.of(context).insta,
        icon: Icons.camera_alt_rounded,
        color: const Color(0xFFDB2777),
        onTap: () => _launchUrl('https://instagram.com'),
      ),
      _ContactLink(
        title: S.of(context).facebook,
        icon: Icons.public_rounded,
        color: AppColors.primaryColor,
        onTap: () => _launchUrl('https://facebook.com'),
      ),
    ];

    return ProfileScaffold(
      title: S.of(context).contactUs,
      subtitle: isAr ? 'راسلنا أو تواصل عبر القنوات' : 'Message us or use our channels',
      bottom: ProfilePrimaryButton(
        title: S.of(context).send,
        onPressed: _submit,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            ProfileFormCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldCustomLabel(label: S.of(context).name),
                  CustomTextFormField(
                    hintText: S.of(context).enterName,
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                    validator: (v) => Validators.validateName(context, v),
                  ),
                  const SizedBox(height: AppPadding.medium),
                  TextFieldCustomLabel(label: S.of(context).email),
                  CustomTextFormField(
                    hintText: S.of(context).enterEmailHere,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (v) => Validators.validateEmail(context, v),
                  ),
                  const SizedBox(height: AppPadding.medium),
                  TextFieldCustomLabel(label: S.of(context).message),
                  CustomTextFormField(
                    hintText: S.of(context).enterMessage,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    controller: _messageController,
                    validator: (v) => Validators.validateName(context, v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isAr ? 'قنوات التواصل' : 'Contact channels',
              style: AppTextStyles.noto16w400.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.darkColor,
              ),
            ),
            const SizedBox(height: 10),
            ...links.map(
              (link) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: link.onTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: link.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(link.icon, color: link.color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              link.title,
                              style: AppTextStyles.noto14w400.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkColor,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: AppColors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactLink {
  const _ContactLink({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}
