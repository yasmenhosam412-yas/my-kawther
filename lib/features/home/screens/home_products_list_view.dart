import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/pharmacy_logo.dart';
import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:elkawther/features/home/widgets/home_sort_sheet.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeProductsListView extends StatefulWidget {
  const HomeProductsListView({
    super.key,
    required this.title,
    required this.products,
  });

  final String title;
  final List<HomeDemoProduct> products;

  @override
  State<HomeProductsListView> createState() => _HomeProductsListViewState();
}

class _HomeProductsListViewState extends State<HomeProductsListView> {
  HomeProductSort _sort = HomeProductSort.none;

  List<HomeDemoProduct> get _products {
    return sortedHomeProducts(widget.products, _sort);
  }

  @override
  Widget build(BuildContext context) {
    final products = _products;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
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
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.noto16w400.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                  Material(
                    color: _sort == HomeProductSort.none
                        ? AppColors.light
                        : AppColors.teal,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => showHomeSortSheet(
                        context: context,
                        selected: _sort,
                        onSelected: (sort) => setState(() => _sort = sort),
                      ),
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.iconsFilterIcon,
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                              _sort == HomeProductSort.none
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_sort != HomeProductSort.none)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: InputChip(
                    backgroundColor: AppColors.light,
                    label: Text(
                      _sort.label(context),
                      style: AppTextStyles.noto14w400.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkColor,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.lightDarker),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() {
                      _sort = HomeProductSort.none;
                    }),
                  ),
                ),
              ),
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PharmacyLogo(size: 72),
                          const SizedBox(height: 16),
                          Text(
                            S.of(context).no_products_found,
                            style: AppTextStyles.noto14w400.copyWith(
                              color: AppColors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.62,
                      ),
                      itemBuilder: (context, index) {
                        return HomeProductCard(product: products[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
