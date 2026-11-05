import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/services/home_service.dart';
import 'package:elkawther/features/products/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeService extends Fake implements HomeService {
  final requests = <({String query, int limit, int offset})>[];

  @override
  Future<List<ProductModel>> searchProduct(
    String query, {
    int limit = 10,
    int offset = 0,
    String sort = 'ASC',
    String sortBy = 'id',
  }) async {
    requests.add((query: query, limit: limit, offset: offset));
    return List.generate(
      limit,
      (index) => ProductModel(id: offset + index + 1, name: 'Product $index'),
    );
  }
}

void main() {
  test('searches trimmed query and appends the next result page', () async {
    final service = _FakeHomeService();
    final cubit = HomeCubit(service);
    addTearDown(cubit.close);

    await cubit.searchProducts('  panadol  ');
    await cubit.searchProducts('panadol', loadMore: true);

    expect(service.requests, [
      (query: 'panadol', limit: 10, offset: 0),
      (query: 'panadol', limit: 10, offset: 10),
    ]);
    expect(cubit.state.searchResults, hasLength(20));
    expect(cubit.state.isSearching, isFalse);
    expect(cubit.state.isLoadingSearchMore, isFalse);
  });

  test('clearing the query clears results and invalidates further pages', () async {
    final service = _FakeHomeService();
    final cubit = HomeCubit(service);
    addTearDown(cubit.close);

    await cubit.searchProducts('panadol');
    await cubit.searchProducts('');
    await cubit.searchProducts('panadol', loadMore: true);

    expect(service.requests, hasLength(1));
    expect(cubit.state.searchResults, isEmpty);
    expect(cubit.state.isSearching, isFalse);
  });
}
