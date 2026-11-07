import 'package:elkawther/core/di/service_locator.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/profile/data/app_settings.dart';
import 'package:elkawther/features/profile/cubit/contact_messages_cubit.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/profile/models/contact_message.dart';
import 'package:elkawther/features/profile/screens/contact_message_view.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactMessagesCubit(getIt<ProfileServices>())..load(),
      child: const _ContactUsForm(),
    );
  }
}

class _ContactUsForm extends StatefulWidget {
  const _ContactUsForm();

  @override
  State<_ContactUsForm> createState() => _ContactUsFormState();
}

class _ContactUsFormState extends State<_ContactUsForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileCubit>().userData;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
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
    final sent = await context.read<ContactMessagesCubit>().send(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      message: _messageController.text.trim(),
    );
    if (!mounted || !sent) return;
    _messageController.clear();
    AppSnackBar.success(S.of(context).successMessage);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _openMessage(ContactMessage message) {
    final cubit = context.read<ContactMessagesCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => BlocProvider.value(
              value: cubit,
              child: ContactMessageView(messageId: message.id),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final settings = context.watch<AppSettings>();
    final links = [
      if (settings.whatsAppUrl != null)
        _ContactLink(
          title: S.of(context).phone,
          icon: Icons.chat_rounded,
          color: const Color(0xFF16A34A),
          onTap: () => _launchUrl(settings.whatsAppUrl!),
        ),
      if (settings.mapUrl != null)
        _ContactLink(
          title: S.of(context).location,
          icon: Icons.location_on_rounded,
          color: const Color(0xFFEF4444),
          onTap: () => _launchUrl(settings.mapUrl!),
        ),
      if (settings.instagram != null)
        _ContactLink(
          title: S.of(context).insta,
          icon: Icons.camera_alt_rounded,
          color: const Color(0xFFDB2777),
          onTap: () => _launchUrl(settings.instagram!),
        ),
      if (settings.facebook != null)
        _ContactLink(
          title: S.of(context).facebook,
          icon: Icons.public_rounded,
          color: AppColors.primaryColor,
          onTap: () => _launchUrl(settings.facebook!),
        ),
      if (settings.tiktok != null)
        _ContactLink(
          title: 'TikTok',
          icon: Icons.music_note_rounded,
          color: const Color(0xFF111827),
          onTap: () => _launchUrl(settings.tiktok!),
        ),
      if (settings.youtube != null)
        _ContactLink(
          title: S.of(context).youtube,
          icon: Icons.smart_display_rounded,
          color: const Color(0xFFDC2626),
          onTap: () => _launchUrl(settings.youtube!),
        ),
    ];

    return BlocConsumer<ContactMessagesCubit, ContactMessagesState>(
      listenWhen:
          (previous, current) =>
              previous.sending && !current.sending && current.error != null,
      listener: (context, state) {
        AppSnackBar.error(
          Errors(message: state.error!).localizedMessage(context),
        );
      },
      builder: (context, state) {
        return ProfileScaffold(
          title: S.of(context).contactUs,
          subtitle:
              isAr ? 'راسلنا أو تواصل عبر القنوات' : 'Message us or use our channels',
          bottom: ProfilePrimaryButton(
            title: S.of(context).send,
            isLoading: state.sending,
            onPressed: state.sending ? null : _submit,
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
                        validator: (value) => Validators.validateName(context, value),
                      ),
                      const SizedBox(height: AppPadding.medium),
                      TextFieldCustomLabel(label: S.of(context).email),
                      CustomTextFormField(
                        hintText: S.of(context).enterEmailHere,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator:
                            (value) => Validators.validateEmail(context, value),
                      ),
                      const SizedBox(height: AppPadding.medium),
                      TextFieldCustomLabel(label: S.of(context).message),
                      CustomTextFormField(
                        hintText: S.of(context).enterMessage,
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        controller: _messageController,
                        validator: (value) => Validators.validateName(context, value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).messages,
                        style: AppTextStyles.noto16w400.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkColor,
                        ),
                      ),
                    ),
                    if (state.loading)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                if (state.error != null && state.messages.isEmpty)
                  _ListNotice(
                    text: Errors(message: state.error!).localizedMessage(context),
                    action: S.of(context).retry,
                    onTap: () => context.read<ContactMessagesCubit>().load(),
                  )
                else if (!state.loading && state.messages.isEmpty)
                  _ListNotice(
                    text: isAr ? 'لا توجد رسائل بعد' : 'No messages yet',
                  )
                else
                  ...state.messages.map(
                    (message) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _MessageCard(
                        message: message,
                        onTap: () => _openMessage(message),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
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
      },
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message, required this.onTap});

  final ContactMessage message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context).name == 'rtl';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatContactDate(message.createdAt),
                      style: AppTextStyles.noto14w400.copyWith(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isRtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: AppColors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListNotice extends StatelessWidget {
  const _ListNotice({required this.text, this.action, this.onTap});

  final String text;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
          ),
          if (action != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onTap, child: Text(action!)),
          ],
        ],
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
