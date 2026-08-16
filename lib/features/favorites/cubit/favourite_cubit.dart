import 'package:dio/dio.dart';
import 'package:elkawther/features/categories/models/category_products_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/favorites/models/favourite_model.dart';
import 'package:elkawther/core/utils/helper_functions.dart';
import 'package:elkawther/features/favorites/services/favourite_service.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit(this._service) : super(FavouriteInitial());

  final FavouriteService _service;

  final Map<int, FavouriteProductData> _favouritesMap = {};

  List<FavouriteProductData> get favourites => _favouritesMap.values.toList();

  bool isProductFavourite(int productId) =>
      _favouritesMap.containsKey(productId);

  Future<void> fetchFavourites(BuildContext context) async {
    emit(FavouriteFetchLoading());
    try {
      final favouriteModel = await _service.getFavourites();
      _favouritesMap
        ..clear()
        ..addEntries(
          (favouriteModel?.data ?? []).map((e) => MapEntry(e.id, e)),
        );
      emit(FavouriteFetchSuccess(favourites));
    } on DioException catch (dioError) {
      if (!context.mounted) return;
      emit(
        FavouriteFetchError(HelperFunctions.handleDioError(dioError, context)),
      );
    } catch (_) {
      if (!context.mounted) return;
      emit(FavouriteFetchError(S.of(context).unexpectedError));
    }
  }

  Future<void> toggleFavourite({
    required int productId,
    required BuildContext context,
  }) async {
    final currentlyFav = isProductFavourite(productId);

    if (currentlyFav) {
      _favouritesMap.remove(productId);
    } else {
      _favouritesMap[productId] = FavouriteProductData.placeholder(productId);
    }
    emit(FavouriteFetchSuccess(favourites));

    try {
      final message = await _service.toggleFavourite(productId);

      if (context.mounted) {
        if (currentlyFav) {
          emit(FavouriteRemoved(message));
        } else {
          emit(FavouriteAdded(message));
        }
        emit(FavouriteFetchSuccess(favourites));
      }
    } on DioException catch (dioError) {
      if (currentlyFav) {
        _favouritesMap[productId] = FavouriteProductData.placeholder(productId);
      } else {
        _favouritesMap.remove(productId);
      }

      emit(FavouriteFetchSuccess(favourites));

      if (context.mounted) {
        final errorMessage = HelperFunctions.handleDioError(dioError, context);
        emit(FavouriteToggleError(errorMessage));
      }
    } catch (error) {
      if (currentlyFav) {
        _favouritesMap[productId] = FavouriteProductData.placeholder(productId);
      } else {
        _favouritesMap.remove(productId);
      }

      emit(FavouriteFetchSuccess(favourites));

      if (context.mounted) {
        emit(FavouriteToggleError(S.of(context).unexpectedError));
      }
    }
  }

  void clearFavorites() {
    _favouritesMap.clear();
    emit(FavouriteInitial());
  }
}

extension FavouriteProductDataPlaceholder on FavouriteProductData {
  static FavouriteProductData placeholder(int productId) {
    return FavouriteProductData(
      id: productId,
      name: '',
      description: '',
      mainImageUrl: '',
      images: [],
      finalPrice: 0,
      discountType: '',
      categoryName: '',
      rate: 0,
      averageRating: null,
      ratingsCount: null,
      totalStock: 0,
      isFavorite: true,
      sizes: [],
      availableSize: [],
      saleable: Saleable(),
    );
  }
}

abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}

class FavouriteAdded extends FavouriteState {
  final String message;

  FavouriteAdded(this.message);
}

class FavouriteRemoved extends FavouriteState {
  final String message;

  FavouriteRemoved(this.message);
}

class FavouriteToggleError extends FavouriteState {
  final String error;

  FavouriteToggleError(this.error);
}

class FavouriteFetchLoading extends FavouriteState {}

class FavouriteFetchSuccess extends FavouriteState {
  final List<FavouriteProductData> favourites;

  FavouriteFetchSuccess(this.favourites);
}

class FavouriteFetchError extends FavouriteState {
  final String error;

  FavouriteFetchError(this.error);
}
