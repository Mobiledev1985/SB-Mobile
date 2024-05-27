import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';
import 'package:sb_mobile/features/authentication/cubit/angler_profile_page_cubit.dart';
import 'package:sb_mobile/features/authentication/cubit/authentication_status_cubit.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/authentication/providers/subscription_provider.dart';
import 'package:sb_mobile/features/authentication/ui/views/login_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/profile_screen.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  State<ProfileHomePage> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Center get buildCenterLoading =>
      Center(child: CircularProgressIndicator(color: appStyles.sbBlue));

  AppStyles appStyles = AppStyles();

  final LoginScreen loginHomePage = const LoginScreen(
    isBackButton: false,
  );
  // final AnglerProfilePage profilePage = const AnglerProfilePage();

  void fetchAuthStatus({required BuildContext context}) {
    Future.microtask(() {
      context.read<AuthenticationStatusCubit>().fetchAuthStatus();
    });
  }

  void reload({required BuildContext context}) {
    Future.microtask(() {
      context.read<AuthenticationStatusCubit>().fetchAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AuthenticationStatusCubit(apiProvider: apiProvider)),
        BlocProvider(
            create: (context) =>
                AnglerProfilePageCubit(apiProvider: apiProvider)),
      ],
      child: BlocConsumer<AuthenticationStatusCubit, AuthenticationStatusState>(
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case AuthenticationStatusInitial:
              fetchAuthStatus(context: context);
              return buildCenterLoading;

            case AuthenticationStatusIdentified:
              state as AuthenticationStatusIdentified;

              // WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.isAuthenticated) {
                // return const AnglerProfilePage();
                return const ProfileScreen();
                // Navigator.of(context).pushNamed('/angler/profile');
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => profilePage),
                // );
              } else {
                context.read<SubscriptionProvider>().isFromBanner = false;
                return loginHomePage;
                // Navigator.of(context).pushNamed('/angler/login/home');

                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => loginHomePage),
                // );
              }
            // });

            // return buildCenterLoading;

            case AuthenticationStatusFailed:
              // return Center(
              //   child: Text(
              //     "Error Loading the page",
              //     style: TextStyle(
              //         fontFamily: appStyles.fontGilroy,
              //         fontSize: 20.0,
              //         fontWeight: FontWeight.bold
              //     ),
              //   ),
              // );

              return Scaffold(
                body: RefreshIndicator(
                  onRefresh: () async {},
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: appStyles.sbBlue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          textStyle: TextStyle(
                              fontFamily: appStyles.fontGilroy,
                              color: Colors.black,
                              fontSize: 15)),
                      child: const AutoSizeText(
                        "Tap to refresh",
                        maxLines: 1,
                      ),
                      onPressed: () {
                        reload(context: context);
                      },
                    ),
                  ),
                ),
              );

            default:
              return Scaffold(
                body: RefreshIndicator(
                  onRefresh: () async {},
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appStyles.sbBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        textStyle: TextStyle(
                            fontFamily: appStyles.fontGilroy,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                      child: const AutoSizeText(
                        "Tap to refresh",
                        maxLines: 1,
                      ),
                      onPressed: () {
                        reload(context: context);
                      },
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
