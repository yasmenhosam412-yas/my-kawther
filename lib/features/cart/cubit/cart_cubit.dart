import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/features/cart/models/cart_model.dart';
import 'package:elkawther/features/cart/services/cart_services.dart';
import 'package:elkawther/features/orders/models/order_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartItemAdded extends CartState {
  final CartItemData cartItemData;

  const CartItemAdded({required this.cartItemData});
}

class CartLoading extends CartState {}

class OrderConfirmLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> cart;
  final Cubon? coupon;
  final Errors? errorMessage;
  final double subtotal;
  final double discount;
  final double total;

  CartLoaded({required this.cart, this.coupon, this.errorMessage})
    : subtotal = cart.fold(
        0.0,
        (sum, item) => sum + item.discountedPrice * item.quantity,
      ),
      discount = coupon?.discount ?? 0.0,
      total =
          cart.fold(
            0.0,
            (sum, item) => sum + item.discountedPrice * item.quantity,
          ) -
          (coupon?.discount ?? 0.0);

  @override
  List<Object?> get props => [
    cart,
    coupon ?? '',
    errorMessage ?? '',
    subtotal,
    discount,
    total,
  ];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CouponApplied extends CartState {
  final Cubon? coupon;
  final List<CartModel> cart;

  const CouponApplied({required this.cart, this.coupon});

  @override
  List<Object?> get props => [cart, coupon ?? ''];
}

class OrderConfirmed extends CartState {
  final OrderModel data;

  const OrderConfirmed(this.data);

  @override
  List<Object?> get props => [data];
}

class CartCubit extends Cubit<CartState> {
  final CartServices _cartServices;

  CartCubit(this._cartServices) : super(CartInitial());

  List<CartModel> _cart = [];
  Cubon? _coupon;

  List<CartModel> get cart => _cart;

  double get subtotal =>
      _cart.fold(0, (sum, item) => sum + item.discountedPrice * item.quantity);

  double get discount => _coupon?.discount ?? 0;

  double get totalAfterDiscount => subtotal - discount;

  bool get isCouponApplied => _coupon != null;

  final Map<String, bool> _updatingItems = {};

  bool isItemUpdating(int productId, String size) {
    return _updatingItems['$productId-$size'] ?? false;
  }

  Future<void> loadCart(BuildContext context) async {
    emit(CartLoading());
    try {
      final cartItems = await _cartServices.getCart();
      _cart = cartItems;
      emit(CartLoaded(cart: _cart, coupon: _coupon));
    } on DioError catch (e) {
      final error = Errors.fromDioError(e);
      if (!context.mounted) return;
      emit(CartError(error.localizedMessage(context)));
    } catch (e) {
      final error = Errors(message: e.toString());
      if (!context.mounted) return;
      emit(CartError(error.localizedMessage(context)));
    }
  }

  Future<Either<Errors, CartItemData>> addItem(
    int productId,
    int quantity,
    int size,
  ) async {
    final result = await _cartServices.addItemToCart(productId, quantity, size);

    return result.fold(
      (error) {
        emit(CartError(error.message));
        return Left(error);
      },
      (newItem) {
        final sizeStr = size.toString();
        final existingIndex = _cart.indexWhere(
          (item) => item.productId == productId && (item.size) == sizeStr,
        );

        if (existingIndex != -1) {
          final existing = _cart[existingIndex];
          final newQuantity = existing.quantity + quantity;
          _cart[existingIndex] = existing.copyWith(
            quantity: newQuantity,
            lineTotal: existing.discountedPrice * newQuantity,
          );
        } else {
          _cart.add(
            CartModel(
              productId: productId,
              id: newItem.id,
              name: "",
              originalPrice: newItem.originalPrice,
              discountedPrice: newItem.priceAtTime,
              discountPercentage: 0,
              quantity: quantity,
              mainImage: "",
              lineTotal: (newItem.totalPrice) * quantity,
              size: sizeStr,
            ),
          );
        }
        emit(CartItemAdded(cartItemData: newItem));
        emit(CartLoaded(cart: List.from(_cart), coupon: _coupon));
        return Right(newItem);
      },
    );
  }

  Future<void> removeItem(
    BuildContext context,
    int cartId, {
    int? sizeId,
  }) async {
    final index = _cart.indexWhere(
      (item) =>
          item.id == cartId &&
          (sizeId != null ? item.size == sizeId.toString() : true),
    );
    if (index == -1) return;

    final removedItem = _cart[index];
    _cart.removeAt(index);
    emit(CartLoaded(cart: List.from(_cart), coupon: _coupon));

    try {
      await _cartServices.removeItemFromCart(cartId);
    } on DioError catch (e) {
      final error = Errors.fromDioError(e);
      _cart.insert(index, removedItem);
      emit(CartLoaded(cart: List.from(_cart), coupon: _coupon));
      if (!context.mounted) return;
      emit(CartError(error.localizedMessage(context)));
    } catch (e) {
      final error = Errors(message: e.toString());
      _cart.insert(index, removedItem);
      emit(CartLoaded(cart: List.from(_cart), coupon: _coupon));
      if (!context.mounted) return;
      emit(CartError(error.localizedMessage(context)));
    }
  }

  Future<void> updateQuantitySafe(
    BuildContext context,
    int productId,
    String operation,
    String size,
  ) async {
    final key = '$productId-$size';

    if (_updatingItems[key] == true) return;
    _updatingItems[key] = true;

    final index = _cart.indexWhere(
      (cartItem) => cartItem.productId == productId && (cartItem.size) == size,
    );

    if (index == -1) {
      _updatingItems[key] = false;
      return;
    }

    final List<CartModel> previousCart = List.from(_cart);
    final item = _cart[index];
    int newQuantity = item.quantity;

    if (operation == "increment") {
      newQuantity++;
    } else if (operation == "decrement") {
      newQuantity = newQuantity > 1 ? newQuantity - 1 : 1;
    }

    _cart[index] = item.copyWith(
      quantity: newQuantity,
      lineTotal: item.discountedPrice * newQuantity,
    );

    emit(
      CartLoaded(cart: List.from(_cart), coupon: _coupon, errorMessage: null),
    );

    try {
      final result = await _cartServices.updateQuantity(
        item.productId,
        operation,
      );
      result.fold(
        (error) {
          _cart = previousCart;
          emit(
            CartLoaded(
              cart: List.from(_cart),
              coupon: _coupon,
              errorMessage: Errors(message: error.localizedMessage(context)),
            ),
          );
        },
        (r) {
          emit(
            CartLoaded(
              cart: List.from(_cart),
              coupon: _coupon,
              errorMessage: null,
            ),
          );
        },
      );
    } finally {
      _updatingItems[key] = false;
    }
  }

  Future<void> applyCoupon(BuildContext context, String code) async {
    try {
      final cubon = await _cartServices.applyCubon(code);

      if (!cubon.success) {
        _coupon = null;
        emit(
          CartLoaded(
            cart: List.from(_cart),
            coupon: null,
            errorMessage: Errors(message: cubon.message),
          ),
        );
        return;
      }

      _coupon = cubon;
      emit(CouponApplied(cart: List.from(_cart), coupon: cubon));
    } on DioError catch (e) {
      final error = Errors.fromDioError(e);
      emit(
        CartLoaded(
          cart: List.from(_cart),
          coupon: _coupon,
          errorMessage: error,
        ),
      );
    } catch (e) {
      final error = Errors(message: e.toString());
      emit(
        CartLoaded(
          cart: List.from(_cart),
          coupon: _coupon,
          errorMessage: error,
        ),
      );
    }
  }

  Future<void> confirmOrder(
    BuildContext context,
    int addressId,
    String method,
    String coupon,
    String notes, {
    File? image,
  }) async {
    emit(OrderConfirmLoading());

    final result = await _cartServices.confirmOrder(
      addressId,
      method,
      coupon,
      notes,
      image: method != "cash" ? image : null,
    );

    result.fold(
      (error) {
        emit(CartError(error.localizedMessage(context)));
        emit(CartLoaded(cart: _cart, coupon: _coupon));
      },
      (order) {
        _cart.clear();
        _coupon = null;
        emit(OrderConfirmed(order));
      },
    );
  }

  void updateQuantityLocally(
    int productId,
    String operation,
    int sizeId, {
    String? title,
    String? image,
    double? price,
  }) {
    final sizeStr = sizeId.toString();
    final index = _cart.indexWhere(
      (item) => item.productId == productId && item.size == sizeStr,
    );

    if (index != -1) {
      final oldItem = _cart[index];
      int newQuantity = oldItem.quantity;

      if (operation == "increment") {
        newQuantity++;
      } else if (operation == "decrement") {
        newQuantity = newQuantity > 1 ? newQuantity - 1 : 1;
      }

      _cart[index] = oldItem.copyWith(
        quantity: newQuantity,
        lineTotal: oldItem.discountedPrice * newQuantity,
      );
    } else if (operation == "increment") {
      _cart.add(
        CartModel(
          productId: productId,
          id: DateTime.now().millisecondsSinceEpoch,
          name: title ?? '',
          originalPrice: price ?? 0,
          discountedPrice: price ?? 0,
          discountPercentage: 0,
          quantity: 1,
          mainImage: image ?? '',
          lineTotal: price ?? 0,
          size: sizeStr,
        ),
      );
    }

    emit(
      CartLoaded(cart: List.from(_cart), coupon: _coupon, errorMessage: null),
    );
  }

  void removeCoupon() {
    _coupon = null;
    emit(CartLoaded(cart: List.from(_cart), coupon: null, errorMessage: null));
  }

  void clearError() {
    emit(
      CartLoaded(cart: List.from(_cart), coupon: _coupon, errorMessage: null),
    );
  }
}
