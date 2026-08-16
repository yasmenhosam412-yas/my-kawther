import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/widgets/home_product_card.dart';
import 'package:flutter/material.dart';

class HomeNewArrivalProductsList extends StatelessWidget {
  const HomeNewArrivalProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeProductsRow(products: HomeDemoData.newArrivals);
  }
}
