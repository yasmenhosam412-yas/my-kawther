import 'dart:io';
import 'package:elkawther/features/health_services/models/monthly_period_calc_model.dart';
import 'package:elkawther/features/orders/cubit/orders_cubit.dart';
import 'package:elkawther/features/profile/cubit/points_cubit.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/profile/services/loyalty_service.dart';
import 'package:elkawther/features/profile/services/profile_services.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/routes/route_extras.dart';
import 'package:elkawther/features/health_services/models/pregnancy_calc_model.dart';
import 'package:elkawther/features/health_services/models/vaccines.dart';
import 'package:elkawther/features/profile/models/profile_models.dart';
import 'package:elkawther/features/checkout/screens/check_out_success_view.dart';
import 'package:elkawther/features/orders/models/order_model.dart';
import 'package:elkawther/features/notifications/screens/notifications_view.dart';
import 'package:elkawther/features/profile/screens/profile_points.dart';
import 'package:elkawther/features/returns/screens/refund_product_details_view.dart';
import 'package:elkawther/features/health_services/screens/vaccines/vaccine_calc.dart';
import 'package:elkawther/features/health_services/screens/vaccines/vaccine_result.dart';
import 'package:elkawther/features/health_services/screens/vaccines/vaccine_schedule.dart';
import 'package:elkawther/features/health_services/screens/beauty_consultation/beauty_consultation.dart';
import 'package:elkawther/features/health_services/screens/pregnancy/pregnancy_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/features/categories/cubit/category_products_cubit.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/orders/models/order_details_model.dart';
import 'package:elkawther/features/addresses/screens/add_new_address_view.dart';
import 'package:elkawther/features/addresses/screens/addresses_view.dart';
import 'package:elkawther/features/auth/screens/choose_user_type_view.dart';
import 'package:elkawther/features/auth/screens/login.dart';
import 'package:elkawther/features/auth/screens/otp.dart';
import 'package:elkawther/features/auth/screens/signup.dart';
import 'package:elkawther/features/auth/screens/forget_password/forget_password.dart';
import 'package:elkawther/features/auth/screens/forget_password/reset_password.dart';
import 'package:elkawther/features/auth/screens/forget_password/verify_email.dart';
import 'package:elkawther/features/cart/screens/cart_view.dart';
import 'package:elkawther/features/categories/screens/categories_view.dart';
import 'package:elkawther/features/categories/screens/category_products_view.dart';
import 'package:elkawther/features/checkout/screens/check_out_view.dart';
import 'package:elkawther/features/home/screens/app_home.dart';
import 'package:elkawther/features/products/screens/brand_products_view.dart';
import 'package:elkawther/features/products/screens/health_issue_products_view.dart';
import 'package:elkawther/features/products/screens/view_all_products.dart';
import 'package:elkawther/features/my_dose/screens/add_dose_view.dart';
import 'package:elkawther/features/my_dose/screens/my_dose_view.dart';
import 'package:elkawther/features/orders/screens/my_order_details.dart';
import 'package:elkawther/features/orders/screens/my_orders.dart';
import 'package:elkawther/features/orders/screens/thanks_rate_view.dart';
import 'package:elkawther/features/onboarding/screens/onboarding_view.dart';
import 'package:elkawther/features/onboarding/screens/splash_view.dart';
import 'package:elkawther/features/products/screens/product_details_view.dart';
import 'package:elkawther/features/profile/screens/contact_us.dart';
import 'package:elkawther/features/profile/screens/edit_personal_info/edit_email.dart';
import 'package:elkawther/features/profile/screens/edit_personal_info/edit_password.dart';
import 'package:elkawther/features/profile/screens/edit_personal_info/edit_personal_info_view.dart';
import 'package:elkawther/features/profile/screens/edit_personal_info/edit_phone.dart';
import 'package:elkawther/features/favorites/screens/favourite_view.dart';
import 'package:elkawther/features/profile/screens/privacy_and_policy.dart';
import 'package:elkawther/features/profile/screens/terms_and_conditions.dart';
import 'package:elkawther/features/returns/screens/refund_product_second_view.dart';
import 'package:elkawther/features/returns/screens/refunded_product.dart';
import 'package:elkawther/features/returns/screens/returns_view.dart';
import 'package:elkawther/features/returns/screens/success_refund_view.dart';
import 'package:elkawther/features/search/screens/search_view.dart';
import 'package:elkawther/features/health_services/screens/vaccines/all_children.dart';
import 'package:elkawther/features/health_services/screens/blood_pressure/pressure_calc.dart';
import 'package:elkawther/features/health_services/screens/blood_sugar/blood_sugar_calc.dart';
import 'package:elkawther/features/health_services/screens/health_calculator/current_health.dart';
import 'package:elkawther/features/health_services/screens/health_calculator/health_calculator.dart';
import 'package:elkawther/features/health_services/screens/health_calculator/health_result.dart';
import 'package:elkawther/features/health_services/screens/pregnancy/pregnancy_calc.dart';
import 'package:elkawther/features/health_services/screens/services_view.dart';
import 'package:elkawther/features/profile/screens/profile_view.dart';
import 'package:elkawther/features/health_services/screens/weight_calculator/weight_calc.dart';
import 'package:elkawther/features/health_services/cubit/health_service_cubit.dart';
import 'package:get_it/get_it.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final getIt = GetIt.I;

    switch (settings.name) {
      case Routes.splash:
        return _material(const SplashScreen(), settings);
      case Routes.onboarding:
        return _material(const OnboardingView(), settings);
      case Routes.chooseUserType:
        return _material(const ChooseUserTypeView(), settings);

      /// Auth
      case Routes.login:
        return _material(const Login(), settings);

      case Routes.forgetPassword:
        return _material(const ForgetPassword(), settings);

      case Routes.verifyEmail:
        return _material(const VerifyEmail(), settings);

      case Routes.resetPassword:
        final args = settings.arguments;
        final email = args is String ? args : '';
        return _material(ResetPassword(email: email), settings);

      case Routes.signup:
        return _material(const SignUp(), settings);

      case Routes.otpScreen:
        return _material(const OtpScreen(), settings);
      case Routes.home:
        return _material(const AppHome(), settings);

      case Routes.notifications:
        return _material(const NotificationsView(), settings);

      case Routes.search:
        return _material(
          BlocProvider(
            create: (context) => getIt<HomeCubit>(),
            child: const SearchView(),
          ),
          settings,
        );

      case Routes.cart:
        return _material(const CartView(), settings);

      case Routes.checkout:
        return _material(const CheckOutView(), settings);

      case Routes.viewMoreProducts:
        {
          final args = settings.arguments as ViewMoreProductsArgs;
          return _material(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => getIt<HomeCubit>()),
              ],
              child: ViewMoreProductsView(
                title: args.title,
                productType: args.productType,
              ),
            ),
            settings,
          );
        }

      case Routes.brandProducts:
        {
          final args = settings.arguments as BrandProductsArgs;
          return _material(
            BrandProductsView(brandName: args.name, brandId: args.id),
            settings,
          );
        }

      case Routes.healthIssueProducts:
        {
          final args = settings.arguments as HealthIssueProductsArgs;
          return _material(
            HealthIssueProductsView(issueId: args.id, issueName: args.name),
            settings,
          );
        }

      case Routes.checkoutSuccess:
        final order = settings.arguments is OrderModel
            ? settings.arguments as OrderModel
            : OrderModel(
                orderId: 0,
                totalPrice: 0,
                pointsEarned: 0,
                message: '',
              );
        return _material(CheckOutSuccessView(order: order), settings);

      case Routes.categories:
        return _material(const CategoriesView(showBanner: true), settings);

      /// Dose
      case Routes.dose:
        return _material(const MyDoseView(), settings);

      case Routes.addDose:
        final args = settings.arguments as Map<String, dynamic>;
        return _material(
          AddDoseView(
            times: args['times'],
            name: args['name'],
            details: args['details'],
            quantity: args['quantity'],
            medication: args['medication'],
            image: args['image'],
            isEdit: args['isEdit'],
            medicineId: args['Id'],
          ),
          settings,
        );

      /// Services
      case Routes.services:
        return _material(const ServicesView(), settings);

      case Routes.pregnancyServices:
        return _material(
          BlocProvider(
            create: (context) => getIt<HealthServiceCubit>(),
            child: const PregnancyCalc(),
          ),
          settings,
        );

      case Routes.healthServices:
        return _material(
          BlocProvider(
            create: (context) => getIt<HealthServiceCubit>(),
            child: const HealthCalculator(),
          ),
          settings,
        );

      case Routes.bloodSugar:
        return _material(
          BlocProvider(
            create: (context) => getIt<HealthServiceCubit>(),
            child: const BloodSugarCalc(),
          ),
          settings,
        );

      case Routes.bloodPressure:
        return _material(
          BlocProvider(
            create: (context) => getIt<HealthServiceCubit>(),
            child: const PressureCalc(),
          ),
          settings,
        );

      case Routes.bodyWeight:
        return _material(
          BlocProvider(
            create: (context) => getIt<HealthServiceCubit>(),
            child: WeightCalc(),
          ),
          settings,
        );

      case Routes.vaccines:
        return _material(
          BlocProvider(
            create: (context) => getIt<HealthServiceCubit>(),
            child: const VaccineCalc(),
          ),
          settings,
        );

      case Routes.beautyConsultation:
        return _material(const BeautyConsultation(), settings);

      /// Profile
      case Routes.profile:
        return _material(const ProfileView(), settings);

      case Routes.editPersonalInfo:
        return _material(const EditPersonalInfo(), settings);

      case Routes.editEmail:
        return _material(const EditEmail(), settings);

      case Routes.editPhone:
        return _material(const EditPhone(), settings);

      case Routes.editPassword:
        return _material(const EditPassword(), settings);

      case Routes.addresses:
        return _material(const AddressesView(), settings);

      case Routes.addNewAddress:
        return _material(const AddNewAddressView(), settings);

      case Routes.editAddress:
        final args = settings.arguments as AddressModel;
        return _material(EditAddressView(addNewAddress: args), settings);

      case Routes.myOrders:
        final args = settings.arguments as bool? ?? false;
        return _material(
          BlocProvider(
            create: (context) => getIt<OrdersCubit>()..loadGroupedOrders(),
            child: MyOrders(afterConfrim: args),
          ),
          settings,
        );

      case Routes.orderDetails:
        return _material(
          BlocProvider(
            create: (context) => getIt<OrdersCubit>(),
            child: const OrderDetails(),
          ),
          settings,
        );

      case Routes.returnProduct:
        {
          final args = settings.arguments as OrderDetailsModel;
          return _material(
            MultiBlocProvider(
              providers: [
                BlocProvider<OrdersCubit>(
                  create: (context) => getIt<OrdersCubit>(),
                ),
                BlocProvider<ProfileCubit>(
                  create: (context) => getIt<ProfileCubit>(),
                ),
              ],
              child: ReturnProduct(order: args),
            ),
            settings,
          );
        }

      case Routes.successRefund:
        return _material(const SuccessRefundView(), settings);

      case Routes.returnProductSecondStep:
        {
          final args = settings.arguments as Map<String, dynamic>;
          final orderDetails = args['details'] as OrderDetailsModel;
          final imageFiles = args['images'] as List<File>;
          final reason = args['reason'] as String;
          final note = args['notes'] as String;

          return _material(
            MultiBlocProvider(
              providers: [
                BlocProvider<OrdersCubit>(
                  create: (context) => getIt<OrdersCubit>(),
                ),
                BlocProvider<ProfileCubit>(
                  create: (context) => getIt<ProfileCubit>(),
                ),
              ],
              child: RefundProductSecondView(
                orderDetails: orderDetails,
                imageFiles: imageFiles,
                selectedReason: reason,
                note: note,
              ),
            ),
            settings,
          );
        }

      case Routes.thanksRate:
        return _material(const ThanksRateView(), settings);

      case Routes.profilePoints:
        return _material(
          BlocProvider(
            create: (context) => PointsCubit(
              getIt<ProfileServices>(),
              getIt<LoyaltyService>(),
            ),
            child: const ProfilePoints(),
          ),
          settings,
        );

      case Routes.favourite:
        return _material(const FavoritesView(), settings);

      case Routes.contactUs:
        return _material(const ContactUs(), settings);

      case Routes.termsAndConditions:
        return _material(const TermsAndConditions(), settings);

      case Routes.privacyAndPolicy:
        return _material(const PrivacyPolicy(), settings);

      case Routes.returns:
        return _material(
          BlocProvider(
            create: (context) => getIt<OrdersCubit>(),
            child: const ReturnsView(),
          ),
          settings,
        );

      case Routes.returnProductDetails:
        return _material(
          BlocProvider(
            create: (context) => getIt<OrdersCubit>(),
            child: const RefundProductDetailsView(),
          ),
          settings,
        );

      case Routes.categoryProducts:
        {
          final args = settings.arguments as CategoryProductsArgs;
          return _material(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) {
                    return getIt<CategoryProductsCubit>();
                  },
                ),
              ],
              child: CategoryProductsView(
                categoryName: args.name,
                categoryId: args.id,
                subcategory: args.subcategory,
                imageUrl: args.imageUrl,
              ),
            ),
            settings,
          );
        }

      case Routes.productDetails:
        {
          final args = settings.arguments as Map<String, dynamic>;
          return _material(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => getIt<OrdersCubit>()),
              ],
              child: ProductDetailsView(
                productId: args['id'],
                onFavClick: args['click'],
                isFav: args['isFav'],
                isView: args['isView'],
              ),
            ),
            settings,
          );
        }
      case Routes.pregnancyTest:
        final args = settings.arguments as PregnancyResultModel;
        return _material(PregnancyResult(result: args), settings);
      case Routes.healthTest:
        final args = settings.arguments as MonthlyPeriodCalc;
        return _material(HealthTestResult(monthlyPeriodCalc: args), settings);
      case Routes.vaccinesTest:
        final args = settings.arguments as Map<String, dynamic>;
        return _material(
          BlocProvider(
            create: (context) => getIt<HealthServiceCubit>(),
            child: VaccineResult(child: args['child']),
          ),
          settings,
        );
      case Routes.scheduleVaccine:
        final args = settings.arguments as Map<String, dynamic>;
        final List<FullVaccinesModel> upcoming =
            args['upcoming'] as List<FullVaccinesModel>;

        return _material(VaccineScedule(upcomingVaccines: upcoming), settings);

      case Routes.allChildren:
        return _material(
          BlocProvider(
            create: (context) => getIt<HealthServiceCubit>(),
            child: const AllChildren(),
          ),
          settings,
        );

      case Routes.fertilityCalendar:
        final periodArgs = settings.arguments;
        return _material(
          BlocProvider(
            create: (context) => getIt<HealthServiceCubit>(),
            child: FertilityCalendarScreen(
              period: periodArgs is MonthlyPeriodCalc ? periodArgs : null,
            ),
          ),
          settings,
        );

      default:
        return _material(
          const Scaffold(body: Center(child: Text("No Routes Available"))),
          settings,
        );
    }
  }

  static MaterialPageRoute _material(Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}
