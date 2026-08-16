class Routes {
  static const String splash = '/splash';

  static const String onboarding = '/onboarding';
  static const String chooseUserType = '/choose-user-type';

  static const String login = '/auth/login';
  static const String signup = '/auth/signup';

  // Password recovery routes (under login)
  static const String forgetPassword = '/auth/login/forget-password';
  static const String verifyEmail = '/auth/login/verify-email';
  static const String resetPassword = '/auth/login/reset-password';

  // OTP (under signup)
  static const String otpScreen = '/auth/signup/otp';

  // Main App Tabs
  static const String home = '/home';
  static const String categories = '/categories';
  static const String dose = '/my_dose';
  static const String services = '/services';
  static const String profile = '/profile';

  // Pages under home (no bottom nav)
  static const String search = '/home/search';
  static const String notifications = '/home/notifications';
  static const String viewMoreProducts = '/home/view_more_products';
  // Cart and Checkout
  static const String cart =
      '/home/cart'; // الأفضل جعله مباشر لتوافقه مع GoRoute
  static const String checkout = '$cart/checkout';
  static const String checkoutSuccess = '$home/checkout-success';

  // Other pages

  // Product pages
  static const String categoryProducts = '/categories-products';

  static const String brandProducts = '$home/brand-products';

  static const String healthIssueProducts = '$home/healthIssue-products';

  static const String productDetails = '/product-details';

  // Dose pages
  static const String addDose = '$dose/add-dose';
  static const String calendar = '$dose/calendar';

  // Services Pages

  // Pages under services (no bottom nav)
  static const String pregnancyServices = '/services/pregnancy';
  static const String pregnancyTest = '/pregnancy-result';

  static const String healthServices = '/services/health';
  static const String healthTest = '/health-result';

  static const String bloodSugar = '/services/bloodSugar';
  static const String bloodPressure = '/services/bloodPressure';
  static const String bodyWeight = '/services/bodyWeight';
  static const String vaccines = '/services/vaccines';
  static const String beautyConsultation = '/services/beauty-consultation';
  static const String vaccinesTest = '/vaccines-result';
  static const String scheduleVaccine = '/scheduleVaccine';
  static const String allChildren = '/AllChildren';
  static const String fertilityCalendar = '/FertilityCalendar';

  // Pregnancy and Childbirth Calculator

  // Profile Pages (under profile)
  static const String addresses = '/profile/addresses';
  static const String addNewAddress = '/profile/addresses/add_new_address';
  static const String editAddress = '/profile/addresses/edit_address';
  static const String contactUs = '/profile/contact_us';
  static const String returns = '/profile/returns';
  static const String returnProduct = '$orderDetails/return_product';
  static const String successRefund = '$returnProduct/success_refund';
  static const String returnProductDetails = '$returns/return_product_details';

  static const String returnProductSecondStep =
      '$returnProduct/return_product_details';

  static const String termsAndConditions = '/profile/terms_and_conditions';
  static const String privacyAndPolicy = '/profile/privacy_and_policy';
  static const String editPersonalInfo = '/profile/edit_personal_info';

  static const String editEmail = '/profile/edit_personal_info/edit_email';
  static const String editPhone = '/profile/edit_personal_info/edit_phone';
  static const String editPassword =
      '/profile/edit_personal_info/edit_password';

  static const String paymentMethods = '/profile/payment-methods';
  static const String myOrders = '/profile/my_orders';
  static const String thanksRate = '$myOrders/thanks_rate';

  static const String orderDetails = '$myOrders/order_details';

  static const String favourite = '/profile/favourite';
  static const String autoReply = '/profile/auto-reply';
  static const String profilePoints = '/profile/profilePoints';
  static const String chatbot = '/chatbot';
  static const String filterScreen = '/filterScreen';
  static const String alarm = '/alarm';
}
