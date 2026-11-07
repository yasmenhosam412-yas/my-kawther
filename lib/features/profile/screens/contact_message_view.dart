import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/profile/cubit/contact_messages_cubit.dart';
import 'package:elkawther/features/profile/models/contact_message.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactMessageView extends StatefulWidget {
  const ContactMessageView({super.key, required this.messageId});

  final int messageId;

  @override
  State<ContactMessageView> createState() => _ContactMessageViewState();
}

class _ContactMessageViewState extends State<ContactMessageView> {
  final _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ContactMessagesCubit>().open(widget.messageId);
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _reply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    final sent = await context.read<ContactMessagesCubit>().reply(text);
    if (!mounted || !sent) return;
    _replyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return BlocConsumer<ContactMessagesCubit, ContactMessagesState>(
      listenWhen: (previous, current) =>
          previous.threadError != current.threadError &&
          current.threadError != null &&
          !current.threadLoading,
      listener: (context, state) {
        AppSnackBar.error(
          Errors(message: state.threadError!).localizedMessage(context),
        );
      },
      builder: (context, state) {
        final thread = state.thread;
        return ProfileScaffold(
          title: S.of(context).message,
                        subtitle:
                            thread == null
                                ? null
                                : formatContactDate(thread.createdAt),
          bottom: TextField(
            controller: _replyController,
            minLines: 1,
            maxLines: 4,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _reply(),
            decoration: InputDecoration(
              hintText: isAr ? 'اكتب ردك' : 'Write a reply',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                onPressed: state.replying ? null : _reply,
                icon:
                    state.replying
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(
                          Icons.send_rounded,
                          color: AppColors.primaryColor,
                        ),
              ),
            ),
          ),
          body:
              state.threadLoading
                  ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                  : thread == null
                  ? _ThreadMessage(
                    title: isAr ? 'تعذر فتح الرسالة' : 'Could not open message',
                    onRetry:
                        () => context.read<ContactMessagesCubit>().open(
                          widget.messageId,
                        ),
                  )
                  : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      _Bubble(
                        text: thread.message,
                        name: thread.name,
                        date: formatContactDate(thread.createdAt),
                        mine: true,
                      ),
                      const SizedBox(height: 12),
                      if (state.replies.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            isAr ? 'لا توجد ردود بعد' : 'No replies yet',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.noto14w400.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        )
                      else
                        ...state.replies.map(
                          (reply) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _Bubble(
                              text: reply.message,
                              name:
                                  reply.isMine
                                      ? (isAr ? 'أنت' : 'You')
                                      : (isAr ? 'الدعم' : 'Support'),
                              date: formatContactDate(reply.createdAt),
                              mine: reply.isMine,
                            ),
                          ),
                        ),
                    ],
                  ),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.text,
    required this.name,
    required this.date,
    required this.mine,
  });

  final String text;
  final String name;
  final String date;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final color = mine ? AppColors.primaryColor : Colors.white;
    final textColor = mine ? Colors.white : AppColors.darkColor;
    return Align(
      alignment: mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.noto14w400.copyWith(
                  color: mine ? Colors.white70 : AppColors.primaryColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: AppTextStyles.noto14w400.copyWith(
                  color: textColor,
                  height: 1.4,
                ),
              ),
              if (date.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  date,
                  style: AppTextStyles.noto14w400.copyWith(
                    color: mine ? Colors.white70 : AppColors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ThreadMessage extends StatelessWidget {
  const _ThreadMessage({required this.title, required this.onRetry});

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(S.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }
}

