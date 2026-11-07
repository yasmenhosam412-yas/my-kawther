import 'package:dio/dio.dart';
import 'package:elkawther/core/di/service_locator.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/profile/models/setting_response.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class RemoteLegalBody extends StatefulWidget {
  const RemoteLegalBody({super.key, required this.select});

  final String? Function(BrandSettings settings) select;

  @override
  State<RemoteLegalBody> createState() => _RemoteLegalBodyState();
}

class _RemoteLegalBodyState extends State<RemoteLegalBody> {
  late Future<String?> _content;

  @override
  void initState() {
    super.initState();
    _content = _load();
  }

  Future<String?> _load() async {
    final settings = await getIt<ProfileServices>().fetchBrandSettings();
    if (settings == null) return null;
    final text = widget.select(settings)?.trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  void _retry() {
    setState(() => _content = _load());
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return FutureBuilder<String?>(
      future: _content,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          final message =
              error is DioException
                  ? Errors.fromDioError(error).localizedMessage(context)
                  : (isAr ? 'تعذر تحميل المحتوى' : 'Could not load this content');
          return _Notice(message: message, onRetry: _retry);
        }
        final text = snapshot.data;
        if (text == null) {
          return _Notice(
            message: isAr ? 'لا يوجد محتوى حالياً' : 'No content yet',
            onRetry: _retry,
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 5, color: AppColors.primaryColor),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      child: Text(
                        text,
                        style: AppTextStyles.noto14w400.copyWith(
                          color: const Color(0xFF4B5563),
                          height: 1.6,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: Text(S.of(context).retry)),
          ],
        ),
      ),
    );
  }
}
