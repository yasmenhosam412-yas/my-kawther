import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/cart/widgets/delete_from_cart_bottom_sheet.dart';

class CartItemWidget extends StatefulWidget {
  final String assetImage;
  final String title;
  final String size;
  final double price;
  final int quantity;

  final Future<bool> Function()? onIncrease;
  final Future<bool> Function()? onDecrease;
  final Future<bool> Function()? onDelete;

  const CartItemWidget({
    super.key,
    required this.assetImage,
    required this.title,
    required this.size,
    required this.price,
    required this.quantity,
    this.onIncrease,
    this.onDecrease,
    this.onDelete,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  final numberFormat = NumberFormat('#,##0');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppPadding.small),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: widget.assetImage,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppPadding.medium),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed:
                        widget.onDelete == null
                            ? null
                            : () async {
                              final shouldDelete =
                                  await showModalBottomSheet<bool>(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder:
                                        (context) => DeleteFromCartBottomSheet(
                                          image: widget.assetImage,
                                          title: widget.title,
                                          price: widget.price,
                                          qunitity: "${widget.quantity}",
                                        ),
                                  );

                              if (shouldDelete == true) {
                                final success =
                                    await widget.onDelete?.call() ?? false;
                                if (!success && mounted) {}
                              }
                            },
                    icon: SvgPicture.asset(Assets.iconsDelete),
                  ),
                ],
              ),
              Text(
                "${S.of(context).size} : ${widget.size}",
                style: AppTextStyles.noto14w400.copyWith(
                  color: AppColors.loginBlack,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${S.of(context).quantity} : ${widget.quantity}",
                style: AppTextStyles.noto14w400.copyWith(color: AppColors.grey),
              ),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${numberFormat.format(widget.price.round())} ${S.of(context).currency}",
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        onPressed:
                            widget.onDecrease == null
                                ? null
                                : () async {
                                  final success =
                                      await widget.onDecrease?.call() ?? false;
                                  if (!success && mounted) {}
                                },
                        icon: SvgPicture.asset(
                          Assets.iconsMinus,
                          width: 30,
                          height: 30,
                        ),
                      ),

                      Text(
                        "${widget.quantity}",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed:
                            widget.onIncrease == null
                                ? null
                                : () async {
                                  final success =
                                      await widget.onIncrease?.call() ?? false;
                                  if (!success && mounted) {}
                                },
                        icon: SvgPicture.asset(
                          Assets.iconsAdd,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
