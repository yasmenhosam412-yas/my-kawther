import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/features/products/services/brand_products_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/products/models/health_issue_products_model.dart';
import 'package:elkawther/features/products/services/health_issue_products_service.dart';

class HealthIssueProductsCubit extends Cubit<HealthIssueProductsState> {
  HealthIssueProductsCubit(
    this._healthIssueProductsService,
    this.brandProductsService,
  ) : super(HealthIssueProductsInitial());

  final HealthIssueProductsService _healthIssueProductsService;
  final BrandProductsService brandProductsService;

  List<HealthIssueProducts> healthIssueProducts = [];
  List<HealthIssueProducts> searchResults = [];
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get canLoadMore => _hasMore && !_isLoadingMore;

  Future<void> fetchHealthIssueProducts(
    int issueId,
    BuildContext context,
  ) async {
    _hasMore = true;
    healthIssueProducts = [];
    emit(HealthIssueProductsLoading());
    try {
      final model = await _healthIssueProductsService.getHealthIssueProducts(
        issueId,
        limit: _limit,
        offset: 0,
      );
      healthIssueProducts = model.data?.products ?? model.dataHealth ?? [];
      _hasMore = healthIssueProducts.length >= _limit;
      emit(
        HealthIssueProductsLoaded(
          healthIssueProducts: healthIssueProducts,
          hasMore: _hasMore,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      emit(HealthIssueProductsError(message: S.of(context).unexpectedError));
    }
  }

  Future<void> fetchHealthIssueProductsMore(
    int issueId,
    BuildContext context,
  ) async {
    if (!_hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    try {
      final model = await _healthIssueProductsService.getHealthIssueProducts(
        issueId,
        limit: _limit,
        offset: healthIssueProducts.length,
      );
      final fetched = model.data?.products ?? model.dataHealth ?? [];
      healthIssueProducts = [
        ...healthIssueProducts,
        ...fetched.where(
          (product) =>
              product.id == null ||
              !healthIssueProducts.any((current) => current.id == product.id),
        ),
      ];
      _hasMore = fetched.length >= _limit;
      emit(
        HealthIssueProductsLoaded(
          healthIssueProducts: healthIssueProducts,
          hasMore: _hasMore,
          isLoadMore: true,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      emit(HealthIssueProductsError(message: S.of(context).unexpectedError));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> fetchHealthProductsNewArrival(
    int healthId,
    BuildContext context,
  ) async {
    emit(HealthIssueProductsLoading());
    try {
      final model = await _healthIssueProductsService
          .getHealthProductsNewArrival(healthId);
      healthIssueProducts = model.data?.products ?? model.dataHealth ?? [];
      _hasMore = false;
      emit(
        HealthIssueProductsLoaded(
          healthIssueProducts: healthIssueProducts,
          hasMore: false,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      emit(HealthIssueProductsError(message: S.of(context).unexpectedError));
    }
  }

  Future<void> fetchHealthProductsBestSelling(
    int healthId,
    BuildContext context,
  ) async {
    emit(HealthIssueProductsLoading());
    try {
      final model = await _healthIssueProductsService
          .getHealthProductsBestSelling(healthId);
      healthIssueProducts = model.data?.products ?? model.dataHealth ?? [];
      _hasMore = false;
      emit(
        HealthIssueProductsLoaded(
          healthIssueProducts: healthIssueProducts,
          hasMore: false,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      emit(HealthIssueProductsError(message: S.of(context).unexpectedError));
    }
  }

  Future<void> searchProducts(String query, {BuildContext? context}) async {
    try {
      final products = await brandProductsService.searchProduct(query);
      searchResults =
          products
              .map(
                (p) => HealthIssueProducts(
                  id: p.id,
                  name: p.name,
                  description: p.description,
                  imageUrl: p.imageUrl,
                  avaiableSize: p.availableSizes,
                  discountType: p.discountType,
                  averageRating: p.rate,
                  ratingsCount: p.ratingsCount,
                  price: p.price?.toDouble(),
                ),
              )
              .toList();
      emit(
        HealthIssueProductsLoaded(
          healthIssueProducts: searchResults,
          hasMore: false,
        ),
      );
    } catch (_) {
      if (context == null || !context.mounted) return;
      emit(HealthIssueProductsError(message: S.of(context).unexpectedError));
    }
  }
}

abstract class HealthIssueProductsState extends Equatable {
  const HealthIssueProductsState();

  @override
  List<Object> get props => [];
}

class HealthIssueProductsInitial extends HealthIssueProductsState {}

class HealthIssueProductsLoading extends HealthIssueProductsState {}

class HealthIssueProductsLoaded extends HealthIssueProductsState {
  final List<HealthIssueProducts> healthIssueProducts;
  final bool hasMore;
  final bool isLoadMore;

  const HealthIssueProductsLoaded({
    required this.healthIssueProducts,
    this.hasMore = true,
    this.isLoadMore = false,
  });

  @override
  List<Object> get props => [healthIssueProducts, hasMore, isLoadMore];
}

class HealthIssueProductsError extends HealthIssueProductsState {
  final String message;

  const HealthIssueProductsError({required this.message});

  @override
  List<Object> get props => [message];
}
