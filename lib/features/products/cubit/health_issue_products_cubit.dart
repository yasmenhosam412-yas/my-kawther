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

  Future<void> fetchHealthIssueProducts(
    int issueId,
    BuildContext context,
  ) async {
    emit(HealthIssueProductsLoading());
    try {
      final model = await _healthIssueProductsService.getHealthIssueProducts(
        issueId,
      );
      healthIssueProducts = model.data!.products ?? [];
      emit(HealthIssueProductsLoaded(healthIssueProducts: healthIssueProducts));
    } catch (_) {
      if (!context.mounted) return;
      emit(HealthIssueProductsError(message: S.of(context).unexpectedError));
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
      healthIssueProducts = model.dataHealth ?? [];
      emit(HealthIssueProductsLoaded(healthIssueProducts: healthIssueProducts));
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
      healthIssueProducts = model.dataHealth ?? [];
      emit(HealthIssueProductsLoaded(healthIssueProducts: healthIssueProducts));
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
      emit(HealthIssueProductsLoaded(healthIssueProducts: searchResults));
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

  const HealthIssueProductsLoaded({required this.healthIssueProducts});

  @override
  List<Object> get props => [healthIssueProducts];
}

class HealthIssueProductsError extends HealthIssueProductsState {
  final String message;

  const HealthIssueProductsError({required this.message});

  @override
  List<Object> get props => [message];
}
