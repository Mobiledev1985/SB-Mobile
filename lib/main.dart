import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/routes/route_generator.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/theme/app_theme.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';
import 'package:sb_mobile/features/authentication/cubit/auth_helper_cubit.dart';
import 'package:sb_mobile/features/authentication/cubit/authentication_status_cubit.dart';

import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/authentication/providers/subscription_provider.dart';
import 'package:sb_mobile/features/exclusiveMedia/cubit/exclusive_media_cubit.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_screen.dart';
import 'package:sb_mobile/features/my_profile/cubit/catches_cubit.dart';

import 'package:sb_mobile/features/my_profile/cubit/favourite_cubit.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_profile_cubit.dart';
import 'package:sb_mobile/features/my_profile/cubit/session/session_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/view/introdcution_screen.dart';
import 'package:sb_mobile/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

// Feature imports
import 'core/config/user_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> initiateHive() async {
  Directory appPath = await getApplicationDocumentsDirectory();
  Hive
    ..init(appPath.path)
    ..registerAdapter(UserCredentialsAdapter());
  await Hive.openBox<UserCredentials>(authBoxName);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initiateHive();
  runApp(SwimBookerApp());
}

class SwimBookerApp extends StatefulWidget with AppThemeMixin {
  SwimBookerApp({super.key});

  @override
  State<SwimBookerApp> createState() => _SwimBookerAppState();
}

class _SwimBookerAppState extends State<SwimBookerApp>
    with AppThemeMixin, SingleTickerProviderStateMixin {
  final AppStyles appStyles = AppStyles();
  ValueNotifier<int> selectedBottomBarItem = ValueNotifier(0);
  late TabController tabController;

  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();
  BuildContext? _context; // Store the context in a variable

  // Offset _offset = Offset.zero;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    _context = context;

    // FirebaseMessaging.instance.getToken().then((value) => print(value));
    super.initState();
  }

  @override
  void dispose() {
    selectedBottomBarItem.dispose();
    super.dispose();
  }

  Future<void> preloadGif() async {
    if (_context != null) {
      final ByteData data = await rootBundle.load(AppImages.swimbooker);
      await precacheImage(MemoryImage(data.buffer.asUint8List()), _context!);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 805),
      builder: (context, child) {
        return ChangeNotifierProvider(
          create: (context) => SubscriptionProvider(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AuthHelperCubit()..fetchAuthStatus(),
              ),
              BlocProvider(
                create: (context) => HomePageCubit(),
              ),
              BlocProvider(
                create: (context) =>
                    AuthenticationStatusCubit(apiProvider: apiProvider),
              ),
              BlocProvider(
                create: (context) => MyProfileCubit(),
              ),
              BlocProvider(
                create: (context) => FavouriteCubit(),
              ),
              BlocProvider(
                create: (context) => ExclusiveMediaCubit(),
              ),
              BlocProvider(
                create: (context) => SessionCubit(),
              ),
              BlocProvider(
                create: (context) => CatchesCubit(),
              ),
            ],
            child: BottomBarProvider(
              selectedBottomBarItem: selectedBottomBarItem,
              // tabController: tabController,
              child: OverlaySupport(
                child: MaterialApp(
                  navigatorKey: navigatorKey,
                  onUnknownRoute: (RouteSettings settings) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomBarScreen(),
                      ),
                    );
                    return null;
                    // open your app when is executed from outside when is terminated.
                  },
                  debugShowCheckedModeBanner: false,
                  title: "SwimBooker",
                  onGenerateRoute: RouteGenerator.generateRoute,
                  home: UpgradeAlert(
                    upgrader: Upgrader(
                      minAppVersion: '1.1.10',
                      dialogStyle: Platform.isAndroid
                          ? UpgradeDialogStyle.material
                          : UpgradeDialogStyle.cupertino,
                      showIgnore: false,
                      showLater: true,
                    ),
                    child: FutureBuilder(
                      future: initialScreen(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!;
                        }
                        return Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          color: AppColors.white,
                        );
                      },
                    ),
                  ),
                  theme: appTheme(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Widget> initialScreen() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final bool? isFirstTime = preferences.getBool(isFirstTimeKey);
    if (isFirstTime != null && !isFirstTime) {
      return const BottomBarScreen();
    } else {
      await preloadGif();
      return const IntroductionScreens();
    }
  }
}
