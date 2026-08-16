import 'package:elkawther/features/ads/models/ads_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/features/ads/services/open_ads_service.dart';
import 'package:elkawther/core/errors/errors.dart';

abstract class AdsState {}

class AdsStateLoaded extends AdsState {
  final List<AdsModel> adsModel;

  AdsStateLoaded({required this.adsModel});
}

class AdsStateLoading extends AdsState {}

class AdsStateError extends AdsState {
  final Errors message;

  AdsStateError({required this.message});
}

class AdsController extends Cubit<AdsState> {
  AdsController(this._adsService) : super(AdsStateLoading());

  final OpenAdsService _adsService;

  Future<void> fetchAds() async {
    emit(AdsStateLoading());

    final result = await _adsService.getOpeningAds();
    result.fold(
      (error) => emit(AdsStateError(message: error)),
      (ads) => emit(
        AdsStateLoaded(
          adsModel: ads.where((ad) => ad.isActive == true).toList(),
        ),
      ),
    );
  }
}
