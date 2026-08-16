import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:flutter/foundation.dart';

class HomeCartLine {
  HomeCartLine({required this.product, this.quantity = 1});

  final HomeDemoProduct product;
  int quantity;

  double get lineTotal => product.price * quantity;
}

class HomeCartStore extends ChangeNotifier {
  HomeCartStore._() {
    for (final product in HomeDemoData.bestSelling.take(2)) {
      _lines.add(HomeCartLine(product: product));
    }
  }

  static final HomeCartStore instance = HomeCartStore._();

  final List<HomeCartLine> _lines = [];

  List<HomeCartLine> get lines => List.unmodifiable(_lines);

  List<HomeDemoProduct> get items => [
        for (final line in _lines)
          for (var i = 0; i < line.quantity; i++) line.product,
      ];

  int get count => _lines.fold(0, (sum, line) => sum + line.quantity);

  double get total => _lines.fold(0, (sum, line) => sum + line.lineTotal);

  void add(HomeDemoProduct product) {
    final index = _lines.indexWhere((line) => line.product.id == product.id);
    if (index >= 0) {
      _lines[index].quantity++;
    } else {
      _lines.add(HomeCartLine(product: product));
    }
    notifyListeners();
  }

  void increment(int productId) {
    final index = _lines.indexWhere((line) => line.product.id == productId);
    if (index < 0) return;
    _lines[index].quantity++;
    notifyListeners();
  }

  void decrement(int productId) {
    final index = _lines.indexWhere((line) => line.product.id == productId);
    if (index < 0) return;
    if (_lines[index].quantity <= 1) {
      _lines.removeAt(index);
    } else {
      _lines[index].quantity--;
    }
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _lines.length) return;
    _lines.removeAt(index);
    notifyListeners();
  }

  void removeById(int productId) {
    _lines.removeWhere((line) => line.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
