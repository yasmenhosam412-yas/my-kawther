import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/features/ads/models/ads_model.dart';
import 'package:elkawther/features/ads/services/open_ads_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth/cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static final Set<int> _shownThisSession = {};

  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    _controller.repeat(reverse: true);
    _completeStartup();
  }

  Future<void> _completeStartup() async {
    final openingAdsFuture = GetIt.I<OpenAdsService>().getOpeningAds();
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final result = await openingAdsFuture;
    if (!mounted) return;
    await result.fold<Future<void>>((error) async {
      debugPrint('Opening ad request failed: ${error.message}');
    }, _showOpeningAd);
    if (!mounted) return;

    final hasSession = await context.read<AuthCubit>().restoreSession();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      hasSession ? Routes.home : Routes.onboarding,
      (route) => false,
    );
  }

  Future<void> _showOpeningAd(List<AdsModel> ads) async {
    final preferences = GetIt.I<SharedPreferences>();
    final selectedAds =
        ads
            .where(
              (ad) =>
                  ad.isActive &&
                  ad.isScheduled &&
                  ad.imageUrl != null &&
                  _shouldShowAd(ad, preferences),
            )
            .toList();
    if (selectedAds.isEmpty) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xE60B1F33),
      builder: (_) => _OpeningAdDialog(ads: selectedAds),
    );
    for (final selectedAd in selectedAds) {
      await _markAdShown(selectedAd, preferences);
    }
  }

  bool _shouldShowAd(AdsModel ad, SharedPreferences preferences) {
    final id = ad.id;
    if (id == null) return true;

    switch (ad.displayFrequency) {
      case 'once':
        return preferences.getBool('opening_ad_seen_$id') != true;
      case 'once_per_day':
        return preferences.getString('opening_ad_seen_date_$id') != _todayKey();
      case 'once_per_session':
        return !_shownThisSession.contains(id);
      case 'every_open':
      default:
        return true;
    }
  }

  Future<void> _markAdShown(AdsModel ad, SharedPreferences preferences) async {
    final id = ad.id;
    if (id == null) return;

    switch (ad.displayFrequency) {
      case 'once':
        await preferences.setBool('opening_ad_seen_$id', true);
        break;
      case 'once_per_day':
        await preferences.setString('opening_ad_seen_date_$id', _todayKey());
        break;
      case 'once_per_session':
        _shownThisSession.add(id);
        break;
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final viewPadding = MediaQuery.paddingOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFF085A94),
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF085A94),
                AppColors.primaryColor,
                Color(0xFF0C8A78),
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const Positioned(
                top: -80,
                right: -60,
                child: _BackgroundOrb(size: 220, color: Color(0x22FFFFFF)),
              ),
              const Positioned(
                bottom: -90,
                left: -70,
                child: _BackgroundOrb(size: 240, color: Color(0x18FFFFFF)),
              ),
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final logoSize = math.min(
                      168.0,
                      math.min(
                        constraints.maxWidth * 0.46,
                        constraints.maxHeight * 0.28,
                      ),
                    );

                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        28,
                        viewPadding.top + 28,
                        28,
                        viewPadding.bottom + 28,
                      ),
                      child: Column(
                        children: [
                          const Spacer(),
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) => Transform.scale(
                              scale: _pulseAnimation.value,
                              child: child,
                            ),
                            child: Container(
                              width: logoSize + 28,
                              height: logoSize + 28,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.45),
                                  width: 1.5,
                                ),
                              ),
                              child: PharmacyLogo(size: logoSize),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            isArabic
                                ? 'رعايتك الصحية، بكل عناية'
                                : 'Your health, cared for every day',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.noto16w400.copyWith(
                              color: Colors.white.withOpacity(0.92),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                minHeight: 4,
                                backgroundColor: Colors.white.withOpacity(0.22),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            isArabic
                                ? 'لحظات ونكون معك'
                                : 'Getting things ready',
                            style: AppTextStyles.noto14w400.copyWith(
                              color: Colors.white.withOpacity(0.78),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OpeningAdDialog extends StatefulWidget {
  const _OpeningAdDialog({required this.ads});

  final List<AdsModel> ads;

  @override
  State<_OpeningAdDialog> createState() => _OpeningAdDialogState();
}

class _OpeningAdDialogState extends State<_OpeningAdDialog> {
  late final PageController _pageController;
  Timer? _autoClose;
  int _current = 0;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

 

  
  void _close() {
    if (_closed || !mounted) return;
    _closed = true;
    _autoClose?.cancel();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _autoClose?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final ads = widget.ads;
    final size = MediaQuery.sizeOf(context);
    final ad = ads[_current];
    final title = ad.title?.trim();
    final content = ad.content?.trim();
    final link = Uri.tryParse(ad.link ?? '');
    final canOpenLink = link != null && link.hasScheme;
    final cardWidth = math.min(420.0, size.width - 36);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 28),
            child: child,
          ),
        );
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        child: SizedBox(
          width: cardWidth,
          height: math.min(size.height * 0.78, 640),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 36,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Column(
                children: [
                  Expanded(child: _buildGallery(ads, isArabic)),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: size.height * 0.28),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                      child: _buildCopy(
                        context,
                        isArabic: isArabic,
                        title: title,
                        content: content,
                        canOpenLink: canOpenLink,
                        link: link,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _close,
                        child: Text(
                          isArabic ? 'متابعة التسوق' : 'Continue shopping',
                          style: AppTextStyles.noto14w400.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGallery(List<AdsModel> ads, bool isArabic) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: ads.length,
          onPageChanged: (index) {
            setState(() => _current = index);
          },
          itemBuilder: (context, index) => _adImage(ads[index]),
        ),
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0x00000000),
                  Color(0x99000000),
                ],
                stops: [0, 0.42, 1],
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: 14,
          start: 14,
          child: _OfferChip(label: isArabic ? 'عرض' : 'Offer'),
        ),
        PositionedDirectional(
          top: 14,
          end: 14,
          child: _CloseButton(
            tooltip: isArabic ? 'إغلاق' : 'Close',
            onPressed: _close,
          ),
        ),
        if (ads.length > 1)
          Positioned(
            left: 0,
            right: 0,
            bottom: 14,
            child: _buildDots(ads.length),
          ),
      ],
    );
  }

  Widget _adImage(AdsModel ad) {
    return CachedNetworkImage(
      imageUrl: ad.imageUrl!,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 240),
      placeholder:
          (_, __) => const ColoredBox(
            color: Color(0xFF12324A),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.2,
              ),
            ),
          ),
      errorWidget:
          (_, __, ___) => const ColoredBox(
            color: Color(0xFF12324A),
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 42,
                color: Colors.white70,
              ),
            ),
          ),
    );
  }

  Widget _buildDots(int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = _current == index;
        return GestureDetector(
          onTap:
              () => _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOut,
              ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: isActive ? 18 : 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: isActive ? Colors.white : Colors.white54,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCopy(
    BuildContext context, {
    required bool isArabic,
    required String? title,
    required String? content,
    required bool canOpenLink,
    required Uri? link,
  }) {
    if (title == null && content == null && !canOpenLink) {
      return const SizedBox(height: 4);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Column(
        key: ValueKey(_current),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: AppTextStyles.headlineLarge.copyWith(
                fontSize: 22,
                height: 1.3,
                color: AppColors.darkColor,
              ),
            ),
          if (content != null) ...[
            if (title != null) const SizedBox(height: 6),
            Text(
              content,
              style: AppTextStyles.noto14w400.copyWith(
                fontSize: 13.5,
                height: 1.5,
                color: AppColors.grey,
              ),
            ),
          ],
          if (canOpenLink) ...[
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _openLink(context, link),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isArabic ? 'شوف العرض' : 'View offer',
                      style: AppTextStyles.noto14w400.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.arrow_back_rounded
                          : Icons.arrow_forward_rounded,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openLink(BuildContext context, Uri? link) async {
    if (link == null) return;
    final opened = await launchUrl(link, mode: LaunchMode.externalApplication);
    if (!opened) {
      debugPrint('Could not open opening ad link: $link');
    }
  }
}

class _OfferChip extends StatelessWidget {
  const _OfferChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.noto14w400.copyWith(
          color: AppColors.primaryColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x66000000),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Tooltip(
          message: tooltip,
          child: const SizedBox(
            width: 36,
            height: 36,
            child: Icon(Icons.close_rounded, size: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _BackgroundOrb extends StatelessWidget {
  const _BackgroundOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
