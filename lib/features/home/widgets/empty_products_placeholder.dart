import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:elkawther/features/home/widgets/home_section_empty.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Shown whenever a home product section has no products to display.
/// Keeps the same height as [HomeProductsRow] so the section layout
/// doesn't jump when products arrive or disappear.
class EmptyProductsPlaceholder extends StatelessWidget {
  const EmptyProductsPlaceholder({super.key});

  static const double _rowHeight = 158 / HomeProductCard.cardAspectRatio;

  @override
  Widget build(BuildContext context) {
    return HomeSectionEmpty(
      message: S.of(context).no_products_found,
      height: _rowHeight,
      iconSize: 52,
    );
  }
}
