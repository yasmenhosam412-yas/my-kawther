import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:flutter/foundation.dart';

class HomeFavoritesStore extends ChangeNotifier {
  HomeFavoritesStore._() {
    _items.addAll(HomeDemoData.bestSelling.take(4));
  }

  static final HomeFavoritesStore instance = HomeFavoritesStore._();

  final List<HomeDemoProduct> _items = [];

  List<HomeDemoProduct> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool contains(int productId) => _items.any((item) => item.id == productId);

  void toggle(HomeDemoProduct product) {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.insert(0, product);
    }
    notifyListeners();
  }

  void removeById(int productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
}
