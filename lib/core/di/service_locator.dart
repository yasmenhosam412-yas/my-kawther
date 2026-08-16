import 'package:dio/dio.dart';
import 'package:elkawther/features/auth/cubit/account_delete_cubit.dart';
import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/health_services/cubit/health_service_cubit.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/core/constants/app_constants.dart';
import 'package:elkawther/core/services/dio_service.dart';
import 'package:elkawther/core/services/auth_interceptor.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:elkawther/features/auth/services/auth_service.dart';
import 'package:elkawther/features/products/services/brand_products_service.dart';
import 'package:elkawther/features/categories/services/category_products_service.dart';
import 'package:elkawther/features/favorites/services/favourite_service.dart';
import 'package:elkawther/features/products/services/health_issue_products_service.dart';
import 'package:elkawther/features/health_services/services/health_services.dart';
import 'package:elkawther/features/home/services/home_service.dart';
import 'package:elkawther/features/my_dose/services/my_dose_service.dart';
import 'package:elkawther/features/orders/services/orders_services.dart';
import 'package:elkawther/features/products/services/product_details_service.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/features/cart/services/cart_services.dart';
import 'package:elkawther/features/categories/cubit/category_products_cubit.dart';
import 'package:elkawther/features/my_dose/cubit/my_dose_cubit.dart';
import 'package:elkawther/features/notifications/cubit/notification_cubit.dart';
import 'package:elkawther/features/notifications/services/main_notification_service.dart';
import 'package:elkawther/features/products/cubit/brand_products_cubit.dart';
import 'package:elkawther/features/profile/cubit/reviews_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<SecureStorageHelper>(SecureStorageHelper());

  final dio =
      Dio()
        ..options.baseUrl = AppConstants.baseUrl
        ..interceptors.add(AuthenticatorInterceptor());

  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<AuthenticatorInterceptor>(AuthenticatorInterceptor());

  await DioService.init();

  getIt
    ..registerLazySingleton(() => AuthService())
    ..registerLazySingleton(() => HomeService())
    ..registerLazySingleton(() => CartServices())
    ..registerLazySingleton(() => FavouriteService())
    ..registerLazySingleton(() => ProductDetailsService())
    ..registerLazySingleton(() => HealthIssueProductsService())
    ..registerLazySingleton(() => BrandProductsService())
    ..registerLazySingleton(() => MedicationService())
    ..registerLazySingleton(() => HealthService())
    ..registerLazySingleton(() => OrdersServices())
    ..registerLazySingleton(() => ProfileServices())
    ..registerLazySingleton(() => CategoryProductsService())
    ..registerLazySingleton(() => MainNotiService());

  getIt.registerFactory(() => AuthCubit());

  if (!getIt.isRegistered<HomeCubit>()) {
    getIt.registerFactory<HomeCubit>(() => HomeCubit(const HomeState()));
  }

  getIt.registerFactory<FavouriteCubit>(
    () => FavouriteCubit(getIt<FavouriteService>()),
  );
  getIt.registerFactory<MedicationCubit>(
    () => MedicationCubit(getIt<MedicationService>()),
  );
  getIt.registerFactory<HealthServiceCubit>(
    () => HealthServiceCubit(getIt<HealthService>()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getIt<ProfileServices>()),
  );
  getIt.registerFactory<OrdersCubit>(
    () => OrdersCubit(getIt<OrdersServices>()),
  );
  getIt.registerFactory<CartCubit>(() => CartCubit(getIt<CartServices>()));
  getIt.registerFactory<CategoryProductsCubit>(
    () => CategoryProductsCubit(getIt<CategoryProductsService>()),
  );
  getIt.registerFactory<BrandProductsCubit>(
    () => BrandProductsCubit(getIt<BrandProductsService>()),
  );
  getIt.registerFactory<ReviewCubit>(
    () => ReviewCubit(getIt<OrdersServices>()),
  );
  getIt.registerFactory<AddressCubit>(
    () => AddressCubit(getIt<ProfileServices>()),
  );
  getIt.registerFactory<AccountDeleteCubit>(
    () => AccountDeleteCubit(getIt<AuthService>()),
  );
  getIt.registerFactory<NotificationCubit>(
    () => NotificationCubit(getIt<MainNotiService>()),
  );
}
