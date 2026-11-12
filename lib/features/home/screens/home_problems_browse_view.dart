import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/features/home/widgets/home_section_empty.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeProblemsBrowseView extends StatefulWidget {
  const HomeProblemsBrowseView({super.key});

  @override
  State<HomeProblemsBrowseView> createState() => _HomeProblemsBrowseViewState();
}

class _HomeProblemsBrowseViewState extends State<HomeProblemsBrowseView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeCubit>().loadHealthIssues();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 220) {
      context.read<HomeCubit>().loadHealthIssues(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 8, 20, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF067A62), AppColors.teal, Color(0xFF14C4A0)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).shopByProblem,
                          style: AppTextStyles.noto16w400.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isAr
                              ? 'اختر العرض ثم شاهد المنتجات المناسبة'
                              : 'Pick a concern and see matching products',
                          style: AppTextStyles.noto14w400.copyWith(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.82),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                  if (state.status == HomeStatus.loading ||
                      state.isLoadingHealthIssuesMore) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.teal),
                    );
                  }
                  final isAr =
                      Localizations.localeOf(context).languageCode == 'ar';
                  return HomePageEmpty(
                    message:
                        isAr
                            ? 'لا توجد مشاكل صحية'
                            : 'No health issues found',
                  );
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
                            color: AppColors.teal,
                            productIds: const [],
                            imageUrl: issue.imageUrl ?? issue.image ?? '',
                          ),
                        )
                        .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                      child: Text(
                        isAr
                            ? '${state.healthIssues?.count ?? problems.length} حالة صحية'
                            : '${state.healthIssues?.count ?? problems.length} health concerns',
                        style: AppTextStyles.noto14w400.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount:
                            problems.length +
                            (state.isLoadingHealthIssuesMore ? 1 : 0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                        itemBuilder: (context, index) {
                          if (index >= problems.length) {
                            return const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: AppColors.teal,
                                ),
                              ),
                            );
                          }
                          final problem = problems[index];
                          return _IssueTile(
                            problem: problem,
                            onTap:
                                () => HomeNavigation.openProblem(
                                  context,
                                  problem,
                                ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IssueTile extends StatelessWidget {
  const _IssueTile({required this.problem, required this.onTap});

  final HomeDemoProblem problem;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE6EEF5)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.teal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child:
                        problem.imageUrl.trim().isEmpty
                            ? const Icon(
                              Icons.health_and_safety_rounded,
                              color: AppColors.teal,
                              size: 28,
                            )
                            : HomeCatalogImage(
                              assetPath: problem.imageUrl,
                              fit: BoxFit.contain,
                            ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  problem.name(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: AppColors.darkColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

