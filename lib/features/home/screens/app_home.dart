import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/categories/screens/categories_view.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/features/home/screens/home_view.dart';
import 'package:elkawther/features/health_services/screens/services_view.dart';
import 'package:elkawther/features/my_dose/screens/my_dose_view.dart';
import 'package:elkawther/features/profile/screens/profile_view.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _currentIndex = 0;
  final Set<int> _openedTabs = {0};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncCartWithAuth(context.read<AuthCubit>().state);
    });
  }

  void _syncCartWithAuth(AuthState state) {
    final isAuthenticated =
        state is AuthLoadedLogin || state is AuthLoadedRegister;
    if (isAuthenticated) {
      context.read<CartCubit>().loadCart(context);
    } else if (state is AuthInitial || state is AuthVisitor) {
      context.read<CartCubit>().clearCart();
    }
  }

  Widget _page(int index) {
    if (!_openedTabs.contains(index)) {
      return const SizedBox.shrink();
    }

    switch (index) {
      case 1:
        return const CategoriesView(key: ValueKey('categories'));
      case 2:
        return const MyDoseView(key: ValueKey('dose'));
      case 3:
        return const ServicesView(key: ValueKey('services'));
      case 4:
        return const ProfileView(key: ValueKey('profile'));
      default:
        return const HomeView(key: ValueKey('home'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavDestination(icon: Assets.iconsHomeIcon, label: S.of(context).home),
      _NavDestination(
        icon: Assets.iconsSectionsIcon,
        label: S.of(context).categories,
      ),
      _NavDestination(
        icon: Assets.iconsDosageIcon,
        label: S.of(context).myDosage,
      ),
      _NavDestination(
        icon: Assets.iconsServicesIcon,
        label: S.of(context).services,
      ),
      _NavDestination(
        icon: Assets.iconsProfileIcon,
        label: S.of(context).profile,
      ),
    ];

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) => _syncCartWithAuth(state),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _currentIndex,
            children: List.generate(5, _page),
          ),
        ),
        bottomNavigationBar: _HomeNavBar(
          items: items,
          currentIndex: _currentIndex,
          onTap:
              (index) => setState(() {
                _currentIndex = index;
                _openedTabs.add(index);
              }),
        ),
      ),
    );
  }
}

class _HomeNavBar extends StatelessWidget {
  const _HomeNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<_NavDestination> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: SizedBox(
          height: 86,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE6EEF5)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.12),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _HomeNavItem(
                      destination: items[0],
                      selected: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                    _HomeNavItem(
                      destination: items[1],
                      selected: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                    const SizedBox(width: 72),
                    _HomeNavItem(
                      destination: items[3],
                      selected: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                    _HomeNavItem(
                      destination: items[4],
                      selected: currentIndex == 4,
                      onTap: () => onTap(4),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: _DoseNavButton(
                  destination: items[2],
                  selected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({required this.icon, required this.label});

  final String icon;
  final String label;
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryColor : const Color(0xff6c7381);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 36,
              height: 28,
              decoration: BoxDecoration(
                color: selected ? AppColors.light : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  destination.icon,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.noto14w400.copyWith(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoseNavButton extends StatelessWidget {
  const _DoseNavButton({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: selected ? 1.05 : 1,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryColor : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: selected ? 0 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  destination.icon,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    selected ? Colors.white : AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            destination.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.noto14w400.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
