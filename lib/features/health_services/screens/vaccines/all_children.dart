import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/features/health_services/cubit/health_service_cubit.dart';
import 'package:elkawther/features/health_services/models/vaccines.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/generated/l10n.dart';

class AllChildren extends StatefulWidget {
  const AllChildren({super.key});

  @override
  State<AllChildren> createState() => _AllChildrenState();
}

class _AllChildrenState extends State<AllChildren> {
  List<Child> _children = [];

  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadChildren();
    }
  }

  Future<void> _loadChildren() async {
    final cubit = context.read<HealthServiceCubit>();
    await cubit.fetchVaccineFullData(context: context);
    final state = cubit.state;
    if (!mounted) return;
    if (state is HealthServicesVaccineFullLoaded) {
      setState(() => _children = state.fullVaccinesModel.children);
    } else if (state is HealthServicesError) {
      AppSnackBar.error(state.message.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return HealthServiceScaffold(
      title: S.of(context).childred,
      subtitle: isAr ? 'جدول تطعيمات الأطفال' : 'Kids vaccine schedule',
      bottom: HealthPrimaryButton(
        title: S.of(context).addChild,
        onPressed: () async {
          await Navigator.pushNamed(context, Routes.vaccines);
          if (mounted) setState(() {});
        },
      ),
      body: _children.isEmpty
          ? Center(
              child: Text(
                S.of(context).no_childred,
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.grey,
                  fontSize: 15,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _children.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final child = _children[index];
                final isGirl = child.gender == 'أنثى';
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        Routes.vaccinesTest,
                        arguments: {'child': child},
                      );
                      if (mounted) setState(() {});
                    },
                    onLongPress: () => _confirmDelete(child.id),
                    child: Ink(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: (isGirl
                                      ? const Color(0xFFEC4899)
                                      : AppColors.primaryColor)
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              isGirl ? Assets.female : Assets.male,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  child.childName,
                                  style: AppTextStyles.noto16w400.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  child.birthDate,
                                  style: AppTextStyles.noto14w400.copyWith(
                                    fontSize: 12,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: AppColors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _confirmDelete(int id) {
    final stateContext = context;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).are_you_sure_to_delete,
                textAlign: TextAlign.center,
                style: AppTextStyles.noto16w400.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkColor,
                ),
              ),
              const SizedBox(height: 16),
              HealthPrimaryButton(
                title: S.of(context).yes_delete,
                color: const Color(0xFFEF4444),
                onPressed: () async {
                  Navigator.pop(context);
                  await stateContext
                      .read<HealthServiceCubit>()
                      .deleteChild(id);
                  _loadChildren();
                },
              ),
              const SizedBox(height: 8),
              HealthPrimaryButton(
                title: S.of(context).cancel,
                color: AppColors.grey,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
