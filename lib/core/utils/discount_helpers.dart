import 'package:elkawther/features/categories/models/category_products_model.dart';
import 'package:elkawther/features/favorites/models/favourite_model.dart';
import 'package:elkawther/features/products/models/best_selling_products_model.dart';
import 'package:elkawther/features/products/models/big_discount_products_model.dart';
import 'package:elkawther/features/products/models/brand_products_model.dart';
import 'package:elkawther/features/products/models/health_issue_products_model.dart';
import 'package:elkawther/features/products/models/latest_products_model.dart';
import 'package:elkawther/features/products/models/product_model.dart';
import 'package:elkawther/features/products/models/related_product_model.dart';
import 'package:elkawther/features/products/models/special_packages_model.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatDiscountLabel({
  required BuildContext context,
  required String? discountType,
  required double originalPrice,
  required double currentPrice,
}) {
  if (originalPrice <= 0) return '';

  final numberFormat = NumberFormat('#,##0');
  if (discountType == 'fixed') {
    final discount = originalPrice - currentPrice;
    return "${numberFormat.format(discount)} ${S.of(context).currency}";
  }
  if (discountType == 'percent' || discountType == 'flash') {
    final discountPercent =
        ((originalPrice - currentPrice) / originalPrice) * 100;
    return "${discountPercent.toStringAsFixed(0)} %";
  }
  return '';
}

String getDiscount(CategoryProductsData product, BuildContext context) {
  if (product.availableSizes == null || product.availableSizes!.isEmpty) {
    return '';
  }
  return formatDiscountLabel(
    context: context,
    discountType: product.discountType,
    originalPrice:
        double.tryParse('${product.availableSizes![0].originalPrice}') ?? 0.0,
    currentPrice:
        double.tryParse('${product.availableSizes?.first.price}') ?? 0.0,
  );
}

String getDiscountBrand(BrandProduct product, BuildContext context) {
  if (product.availableSizes == null || product.availableSizes!.isEmpty) {
    return '';
  }
  return formatDiscountLabel(
    context: context,
    discountType: product.discountType,
    originalPrice:
        double.tryParse('${product.availableSizes![0].originalPrice}') ?? 0.0,
    currentPrice:
        double.tryParse('${product.availableSizes?.first.price}') ?? 0.0,
  );
}

String getDiscountReltaed(
  RelatedProductDataModel product,
  BuildContext context,
) {
  if (product.availableSizes.isEmpty) {
    return '';
  }
  return formatDiscountLabel(
    context: context,
    discountType: product.discountType,
    originalPrice:
        double.tryParse('${product.availableSizes[0].originalPrice}') ?? 0.0,
    currentPrice:
        double.tryParse('${product.availableSizes.first.price}') ?? 0.0,
  );
}

String getDiscountHealth(HealthIssueProducts product, BuildContext context) {
  if (product.avaiableSize == null || product.avaiableSize!.isEmpty) {
    return '';
  }
  return formatDiscountLabel(
    context: context,
    discountType: product.discountType,
    originalPrice:
        double.tryParse('${product.avaiableSize![0].originalPrice}') ?? 0.0,
    currentPrice:
        double.tryParse('${product.avaiableSize?.first.price}') ?? 0.0,
  );
}

String getDiscountBestSelling(
  BestSellingProductsData product,
  BuildContext context,
) {
  if (product.product!.availableSizes == null ||
      product.product!.availableSizes!.isEmpty) {
    return '';
  }
  return formatDiscountLabel(
    context: context,
    discountType: product.product!.discountType,
    originalPrice:
        double.tryParse(
          '${product.product!.availableSizes![0].originalPrice}',
        ) ??
        0.0,
    currentPrice:
        double.tryParse('${product.product!.availableSizes?.first.price}') ??
        0.0,
  );
}

String getDiscountLatest(LatestProductsData product, BuildContext context) {
  if (product.availableSizes == null || product.availableSizes!.isEmpty) {
    return '';
  }
  return formatDiscountLabel(
    context: context,
    discountType: product.discountType,
    originalPrice:
        double.tryParse('${product.availableSizes![0].originalPrice}') ?? 0.0,
    currentPrice: double.tryParse('${product.availableSizes?[0].price}') ?? 0.0,
  );
}

String getDiscountSpecial(SpecialPackagesData product, BuildContext context) {
  if (product.availableSizes == null || product.availableSizes!.isEmpty) {
    return '';
  }
  return formatDiscountLabel(
    context: context,
    discountType: product.discountType,
    originalPrice:
        double.tryParse('${product.availableSizes![0].originalPrice}') ?? 0.0,
    currentPrice: double.tryParse('${product.availableSizes![0].price}') ?? 0.0,
  );
}

String getDiscountProductModel(ProductModel product, BuildContext context) {
  if (product.availableSizes == null || product.availableSizes!.isEmpty) {
    return '';
  }
  return formatDiscountLabel(
    context: context,
    discountType: product.discountType,
    originalPrice:
        double.tryParse('${product.availableSizes![0].originalPrice}') ?? 0.0,
    currentPrice:
        double.tryParse('${product.availableSizes?.first.price}') ?? 0.0,
  );
}

String getDiscountBig(BigDiscountData product, BuildContext context) {
  if (product.availableSizes == null || product.availableSizes!.isEmpty) {
    return '';
  }
  return formatDiscountLabel(
    context: context,
    discountType: product.discountType,
    originalPrice:
        double.tryParse('${product.availableSizes![0].originalPrice}') ?? 0.0,
    currentPrice: double.tryParse('${product.availableSizes![0].price}') ?? 0.0,
  );
}

String getDiscountFav(FavouriteProductData product, BuildContext context) {
  if (product.availableSize.isEmpty) {
    return '';
  }
  return formatDiscountLabel(
    context: context,
    discountType: product.discountType,
    originalPrice:
        double.tryParse('${product.availableSize[0].originalPrice}') ?? 0.0,
    currentPrice: double.tryParse('${product.finalPrice}') ?? 0.0,
  );
}
