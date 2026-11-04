import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_problems_row.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeProblemsBrowseView extends StatelessWidget {
  const HomeProblemsBrowseView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.darkColor,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).shopByProblem,
                          style: AppTextStyles.noto16w400.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkColor,
                          ),
                        ),
                        Text(
                          isAr
                              ? 'اختر العرض ثم شاهد المنتجات المناسبة'
                              : 'Pick a concern and see matching products',
                          style: AppTextStyles.noto14w400.copyWith(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final issues =
                      state.healthIssues?.data
                          ?.where((issue) => issue.id != null)
                          .toList() ??
                      const [];
                  if (issues.isEmpty) {
                    if (state.status == HomeStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Center(child: Text(S.of(context).no_products_found));
                  }
                  final problems =
                      issues
                          .map(
                            (issue) => HomeDemoProblem(
                              id: issue.id!,
                              nameAr: issue.name ?? '',
                              nameEn: issue.name ?? '',
                              subtitleAr: '',
                              subtitleEn: '',
                              icon: Icons.health_and_safety_rounded,
                              color: const Color(0xFF06A786),
                              productIds: const [],
                              imageUrl: issue.imageUrl ?? issue.image ?? '',
                            ),
                          )
                          .toList();
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: problems.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 560,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          mainAxisExtent: 220,
                        ),
                    itemBuilder: (context, index) {
                      final problem = problems[index];
                      return HomeProblemCard(
                        problem: problem,
                        expanded: true,
                        onTap:
                            () => HomeNavigation.openProblem(context, problem),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
