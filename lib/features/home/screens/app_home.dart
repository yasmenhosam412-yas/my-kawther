import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/categories/screens/categories_view.dart';
import 'package:elkawther/features/home/screens/home_view.dart';
import 'package:elkawther/features/health_services/screens/services_view.dart';
import 'package:elkawther/features/my_dose/screens/my_dose_view.dart';
import 'package:elkawther/features/profile/screens/profile_view.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _currentIndex = 0;
  final Set<int> _openedTabs = {0};

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: List.generate(5, _page),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.10),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: Row(
              children: List.generate(items.length, (index) {
                return Expanded(
                  child: _HomeNavItem(
                    destination: items[index],
                    selected: _currentIndex == index,
                    onTap: () => setState(() {
                      _currentIndex = index;
                      _openedTabs.add(index);
                    }),
                  ),
                );
              }),
            ),
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

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.light : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              destination.icon,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.noto14w400.copyWith(
                fontSize: 11,
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
