import 'package:elkawther/features/home/data/home_demo_data.dart';
import 'package:elkawther/features/home/models/banners_model.dart';
import 'package:flutter/foundation.dart';

class HomeBanners {
  const HomeBanners._();

  static String device() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      default:
        return 'all';
    }
  }

  static List<HomeDemoBanner> of(
    BannersModel? model,
    String position, {
    DateTime? now,
  }) {
    return model
            ?.bannersFor(position, now: now, device: device())
            .map(
              (banner) => HomeDemoBanner(
                titleAr: banner.title ?? '',
                titleEn: banner.title ?? '',
                imageUrl: banner.imageUrl ?? banner.image ?? '',
                link: banner.link,
                description: banner.description,
              ),
            )
            .toList() ??
        const [];
  }
}
