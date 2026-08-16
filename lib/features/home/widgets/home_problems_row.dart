import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/screens/home_navigation.dart';
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
      height: 132,
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
    final card = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                problem.color.withOpacity(0.16),
                problem.color.withOpacity(0.06),
                Colors.white,
              ],
            ),
            border: Border.all(color: problem.color.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: problem.color.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: problem.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(problem.icon, color: Colors.white, size: 20),
                ),
                const Spacer(),
                Text(
                  problem.name(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: expanded ? 15 : 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  problem.subtitle(context),
                  maxLines: expanded ? 2 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.noto14w400.copyWith(
                    fontSize: 11,
                    height: 1.25,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (expanded) return card;
    return SizedBox(width: 156, child: card);
  }
}
