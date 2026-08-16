import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_text_style.dart';
import 'package:elkawther/core/widgets/guest_user_dialog.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.available,
    required this.image,
    required this.title,
    required this.size,
    required this.price,
    required this.productId,
    required this.sizeId,
  });

  final bool available;
  final String image;
  final String title;
  final String size;
  final String price;
  final int productId;
  final int sizeId;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadInitialQuantity();
  }

  void _loadInitialQuantity() {
    final cart = context.read<CartCubit>().cart;
    final index = cart.indexWhere(
      (item) =>
          item.productId == widget.productId &&
          item.size == widget.sizeId.toString(),
    );
    if (index != -1) {
      quantity = cart[index].quantity;
    } else {
      quantity = 1;
    }
  }

  void _increment() {
    setState(() => quantity += 1);
    context.read<CartCubit>().updateQuantityLocally(
      widget.productId,
      "increment",
      widget.sizeId,
      title: widget.title,
      image: widget.image,
      price: double.tryParse(widget.price),
    );
  }

  void _decrement() {
    if (quantity <= 1) return;
    setState(() => quantity -= 1);
    context.read<CartCubit>().updateQuantityLocally(
      widget.productId,
      "decrement",
      widget.sizeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.available) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greyCarsoul,
              disabledBackgroundColor: AppColors.greyCarsoul,
              foregroundColor: AppColors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              S.of(context).productNotAvailable,
              style: AppTextStyles.noto14w400.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.grey,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          _QuantityControl(
            quantity: quantity,
            onIncrement: _increment,
            onDecrement: _decrement,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoggedIn = state.status == AuthStatus.authenticated;
                return SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!isLoggedIn) {
                        showGuestLoginDialog(context);
                        return;
                      }
                      context.read<CartCubit>().addItem(
                        widget.productId,
                        quantity,
                        widget.sizeId,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).addedToCart),
                          backgroundColor: AppColors.primaryColor,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    icon: SvgPicture.asset(
                      Assets.iconsBag,
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: Text(
                      S.of(context).addToCart,
                      style: AppTextStyles.noto14w400.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _roundButton(icon: Icons.remove_rounded, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: AppTextStyles.noto16w400.copyWith(
                color: AppColors.darkColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          _roundButton(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, size: 18, color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
