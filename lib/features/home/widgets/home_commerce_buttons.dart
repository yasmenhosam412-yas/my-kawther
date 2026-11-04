import 'dart:async';

import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeFavoriteButton extends StatefulWidget {
  const HomeFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.size = 32,
    this.iconSize = 15,
  });

  final bool isFavorite;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;

  @override
  State<HomeFavoriteButton> createState() => _HomeFavoriteButtonState();
}

class _HomeFavoriteButtonState extends State<HomeFavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.38), weight: 42),
      TweenSequenceItem(tween: Tween(begin: 1.38, end: 0.88), weight: 28),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(HomeFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite == widget.isFavorite) return;
    if (MediaQuery.disableAnimationsOf(context)) return;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: widget.onPressed,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final burst = widget.isFavorite ? _controller.value : 0.0;
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  if (burst > 0 && burst < 1)
                    Opacity(
                      opacity: (1 - burst).clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.7 + (burst * 1.15),
                        child: Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE11D48).withOpacity(0.4),
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Transform.scale(scale: _scale.value, child: child),
                ],
              );
            },
            child: SvgPicture.asset(
              widget.isFavorite ? Assets.iconsFav2 : Assets.iconsFav,
              width: widget.iconSize,
              height: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}

class HomeCartAddButton extends StatefulWidget {
  const HomeCartAddButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<HomeCartAddButton> createState() => _HomeCartAddButtonState();
}

class _HomeCartAddButtonState extends State<HomeCartAddButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.86), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.86, end: 1.14), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.14, end: 1), weight: 35),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    widget.onPressed();
    if (MediaQuery.disableAnimationsOf(context)) return;
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: AppColors.primaryColor.withOpacity(0.4),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final showCheck =
                  _controller.value > 0.08 && _controller.value < 0.78;
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  if (_controller.value > 0 && _controller.value < 1)
                    Positioned(
                      top: -6 - (16 * _controller.value),
                      child: Opacity(
                        opacity: (1 - _controller.value).clamp(0.0, 1.0),
                        child: Text(
                          '+1',
                          style: AppTextStyles.noto14w400.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  Transform.scale(
                    scale: _scale.value,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 160),
                      child: Icon(
                        showCheck ? Icons.check_rounded : Icons.add_rounded,
                        key: ValueKey(showCheck),
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeAddToCartButton extends StatefulWidget {
  const HomeAddToCartButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  State<HomeAddToCartButton> createState() => _HomeAddToCartButtonState();
}

class _HomeAddToCartButtonState extends State<HomeAddToCartButton> {
  bool _confirmed = false;
  bool _pressed = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onTap() {
    widget.onPressed();
    if (MediaQuery.disableAnimationsOf(context)) return;
    setState(() => _confirmed = true);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 850), () {
      if (mounted) setState(() => _confirmed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: _confirmed ? AppColors.teal : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: _onTap,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Row(
                  key: ValueKey(_confirmed),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      if (_confirmed) ...[
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.ibmPlexSans16w500.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
