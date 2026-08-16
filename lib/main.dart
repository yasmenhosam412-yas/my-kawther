import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:elkawther/core/di/service_locator.dart';
import 'package:elkawther/core/providers/locale_provider.dart';
import 'package:elkawther/core/routes/app_router.dart';
import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/services/local_notifications.dart';
import 'package:elkawther/core/services/secure_storage_helper.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/utils/bloc_observer.dart';
import 'package:elkawther/features/addresses/cubit/addresses_cubit.dart';
import 'package:elkawther/features/auth/cubit/account_delete_cubit.dart';
import 'package:elkawther/features/auth/cubit/auth_cubit.dart';
import 'package:elkawther/features/cart/cubit/cart_cubit.dart';
import 'package:elkawther/features/favorites/cubit/favourite_cubit.dart';
import 'package:elkawther/features/home/cubit/home_cubit.dart';
import 'package:elkawther/features/home/cubit/home_state.dart';
import 'package:elkawther/features/notifications/cubit/notification_cubit.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/profile/cubit/reviews_cubit.dart';
import 'package:elkawther/firebase_options.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

export 'package:elkawther/core/services/local_notifications.dart'
    show flutterLocalNotificationsPlugin;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message received: ${message.notification?.title}');
}

class _AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent = 'ElKawtherPharmacy/1.0 (Flutter; catalog images)';
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _AppHttpOverrides();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initLocalNotifications();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await createNotificationChannel(
    channelId: 'high_importance_channel',
    channelName: 'High Importance Notifications',
    channelDescription: 'Used for important notifications',
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  Bloc.observer = MyBlocObserver();
  await setupServiceLocator();

  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();
  await S.load(localeProvider.locale);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()..loadUser()),
        BlocProvider<FavouriteCubit>(create: (_) => getIt<FavouriteCubit>()),
        BlocProvider<AddressCubit>(create: (_) => getIt<AddressCubit>()),
        BlocProvider<CartCubit>(create: (_) => getIt<CartCubit>()),
        BlocProvider<HomeCubit>(create: (_) => HomeCubit(const HomeState())),
        BlocProvider<ReviewCubit>(create: (_) => getIt<ReviewCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        BlocProvider(create: (_) => getIt<NotificationCubit>()),
        BlocProvider(create: (_) => getIt<AccountDeleteCubit>()),
      ],
      child: ChangeNotifierProvider.value(
        value: localeProvider,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _askNotificationPermission();
    setupFCM();
    _setupDeepLinks();
  }

  void _setupDeepLinks() {
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleDeepLink(uri);
    });
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  Future<void> _askNotificationPermission() async {
    var status = await Permission.notification.status;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.notification.request();
      if (result.isGranted) {
        debugPrint('Notification permission granted');
      } else {
        debugPrint('Notification permission denied');
      }
    } else if (status.isGranted) {
      debugPrint('Notification permission already granted');
    }
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('Deep link: $uri');
    if (uri.scheme == 'elkawther') {
      int productId = int.parse(uri.pathSegments.last);
      debugPrint('Product ID from deep link: $productId');

      bool fav = context.read<FavouriteCubit>().isProductFavourite(productId);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushNamed(
          Routes.productDetails,
          arguments: {
            'id': productId,
            'click': () {
              setState(() {
                fav = !fav;
              });
              context.read<FavouriteCubit>().toggleFavourite(
                productId: productId,
                context: context,
              );
            },
            'isFav': fav,
            "isView": true,
          },
        );
      });
    }
  }

  Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    SecureStorageHelper secureHelper = SecureStorageHelper();

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    String? token = await messaging.getToken();
    await secureHelper.safeWrite("fcm_token", token);
    debugPrint('FCM Token: $token');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message opened app: ${message.data}');
      _handleMessageNavigation(message);
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageNavigation(initialMessage);
    }
  }

  void _handleMessageNavigation(RemoteMessage message) {
    if (message.data.containsKey('route')) {
      String route = message.data['route'];
      navigatorKey.currentState?.pushNamed(route);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No title',
      message.notification?.body ?? 'No body',
      platformDetails,
      payload: message.data['route'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.onboarding,
            onGenerateRoute: RouteGenerator.generateRoute,
            title: 'El Kawther',
            theme: ThemeData(
              fontFamily: 'NotoSansArabic',
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryColor,
              ),
              scaffoldBackgroundColor: Colors.white,
              actionIconTheme: ActionIconThemeData(
                backButtonIconBuilder: (context) {
                  return IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  );
                },
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
              ),
            ),
            locale: localeProvider.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          ),
    );
  }
}
