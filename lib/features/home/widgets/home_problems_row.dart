import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
import 'package:elkawther/features/home/widgets/home_catalog_image.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeProblemsRow extends StatelessWidget {
  const HomeProblemsRow({
    super.key,
    this.problems = HomeDemoData.catalogProblems,
  });

  final List<HomeDemoProblem> problems;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 154,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: problems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final problem = problems[index];
          return HomeProblemCard(
            problem: problem,
            onTap: () => HomeNavigation.openProblem(context, problem),
          );
        },
      ),
    );
  }
}

class HomeProblemCard extends StatelessWidget {
  const HomeProblemCard({
    super.key,
    required this.problem,
    required this.onTap,
    this.expanded = false,
  });

  final HomeDemoProblem problem;
  final VoidCallback onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final subtitle = problem.subtitle(context).trim();
    final card = Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.lightDarker.withOpacity(0.8)),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkColor.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child:
              expanded
                  ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _problemIcon(104),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                problem.name(context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.noto16w400.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  color: AppColors.darkColor,
                                ),
                              ),
                              if (subtitle.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                Text(
                                  subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.noto14w400.copyWith(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    S.of(context).viewMore,
                                    style: AppTextStyles.noto14w400.copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    isAr
                                        ? Icons.arrow_back_rounded
                                        : Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          isAr
                              ? Icons.arrow_back_rounded
                              : Icons.arrow_forward_rounded,
                          size: 20,
                          color: problem.color,
                        ),
                      ],
                    ),
                  )
                  : Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:
                            problem.imageUrl.isEmpty
                                ? ColoredBox(
                                  color: problem.color.withOpacity(0.15),
                                  child: Center(
                                    child: Icon(
                                      problem.icon,
                                      color: problem.color,
                                      size: 72,
                                    ),
                                  ),
                                )
                                : HomeCatalogImage(
                                  assetPath: problem.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x11000000),
                              Color(0x22000000),
                              Color(0xCC000000),
                            ],
                            stops: [0, 0.42, 1],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isAr
                                      ? Icons.arrow_back_rounded
                                      : Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: problem.color,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              problem.name(context),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.noto14w400.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(color: Colors.black54, blurRadius: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );

    if (expanded) return card;
    return SizedBox(width: 184, child: card);
  }

  Widget _problemIcon(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: problem.color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child:
          problem.imageUrl.isEmpty
              ? Icon(problem.icon, color: problem.color, size: size * 0.48)
              : Padding(
                padding: const EdgeInsets.all(5),
                child: HomeCatalogImage(
                  assetPath: problem.imageUrl,
                  fit: BoxFit.contain,
                  width: size,
                  height: size,
                ),
              ),
    );
  }
}
