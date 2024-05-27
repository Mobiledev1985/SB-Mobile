import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/notification/notification_handler.dart';
import 'package:sb_mobile/core/notification/web_view_screen.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_plus_purchase_screen.dart';
// import 'package:sb_mobile/features/authentication/ui/widgets/feature_list_screen.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';
import 'package:sb_mobile/features/home_page/data/models/notification_model.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  static MaterialPageRoute<dynamic> buildRouter() {
    return MaterialPageRoute(
      builder: (context) => const NotificationListScreen(),
    );
  }

  static Future<void> navigateTo(
    BuildContext context,
  ) async {
    await Navigator.pushNamed(
      context,
      RoutePaths.notificationListScreen,
    );
  }

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final ValueNotifier<bool> isLoading = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    notificationStatusBar();
    refreshNotification();
  }

  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }

  Future<void> refreshNotification() async {
    try {
      await context.read<HomePageCubit>().refreshNotification();
    } finally {
      isLoading.value = false;
    }
  }

  void notificationStatusBar() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: AppColors.blue,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(AppColors.blue);
    }
  }

  Future<void> onNavigation(Map<String, dynamic> dataMap, String? title) async {
    if (dataMap.containsKey('article_id')) {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
        );
      } else {
        FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
        FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
      }
      Navigator.of(context).pushNamed(
        '/social/blog',
        arguments: {'id': dataMap['article_id']},
      );
    } else if (dataMap.containsKey('url')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(
            url: dataMap['url'],
            isGoBackToHomeScreen: false,
            title: title ?? '',
          ),
        ),
      ).then((value) {
        Future.delayed(const Duration(milliseconds: 400)).then((value) {
          notificationStatusBar();
        });
      });
    } else if (dataMap.containsKey('section')) {
      final NotificationHandler notificationHandler =
          NotificationHandler.getInstance();
      final String section = dataMap['section']!;
      if (notificationHandler.homeNavigationItems.contains(section)) {
        Future.delayed(const Duration(milliseconds: 400)).then((value) {
          if (Platform.isAndroid) {
            SystemChrome.setSystemUIOverlayStyle(
              const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
              ),
            );
          } else {
            FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
            FlutterStatusbarcolor.setStatusBarColor(Colors.white);
          }
        });

        await notificationHandler.homeScreenExtendedScreenNavigation(
            context, section);
        Future.delayed(const Duration(milliseconds: 400)).then((value) {
          notificationStatusBar();
        });
      } else if (section == 'sb_plus_signup') {
        await SbPlusPurchaseScreen.navigateTo(
          context,
          (
            // ignore: use_build_context_synchronously
            email: (context.read<HomePageCubit>().state as HomePageLoaded)
                    .profile
                    ?.email ??
                '',
            isLoggedIn:
                // ignore: use_build_context_synchronously
                (context.read<HomePageCubit>().state as HomePageLoaded)
                        .profile !=
                    null
          ),
        );
        Future.delayed(const Duration(milliseconds: 400)).then((value) {
          notificationStatusBar();
        });
      } else if (notificationHandler.mySBNavigationItems.contains(section)) {
        if (Platform.isAndroid) {
          Future.delayed(const Duration(milliseconds: 400)).then(
            (value) {
              SystemChrome.setSystemUIOverlayStyle(
                const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                ),
              );
            },
          );
        }

        notificationHandler.mySbNotificationHandler(context, section);
      } else if (notificationHandler.sbPlusNavigation.contains(section)) {
        notificationHandler.sbPlusNotificationHandler(context, section);
      } else if (notificationHandler.bottomBarItems.contains(section)) {
        notificationHandler.bottomBarNotificationHandler(context, section);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blue,
          title: Text(
            'Notifications',
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          centerTitle: false,

          actions: [
            BlocBuilder<HomePageCubit, HomePageState>(
              builder: (context, state) {
                bool shouldShowButton = state is HomePageLoaded &&
                    state.notifications != null &&
                    state.notifications!.isNotEmpty &&
                    state.notifications!.any((element) =>
                        element.isRead != null ? !element.isRead! : false);

                return Visibility(
                  visible: shouldShowButton,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: () {
                        context.read<HomePageCubit>().onReadNotification(
                              (state as HomePageLoaded)
                                  .notifications!
                                  .map((e) => e.id!)
                                  .toList(),
                            );
                      },
                      child: Text(
                        'Mark all as read',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xffD9EEFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],

          // bottom: TabBar(
          //   tabs: [
          //     Tab(
          //       icon: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             'New',
          //             style: context.textTheme.bodyLarge?.copyWith(
          //               fontWeight: FontWeight.w600,
          //               color: AppColors.white,
          //             ),
          //           ),
          //           const SpaceHorizontal(4),
          //           BlocBuilder<HomePageCubit, HomePageState>(
          //             builder: (context, state) {
          //               return Visibility(
          //                 visible: context
          //                     .read<HomePageCubit>()
          //                     .getNotification(false)
          //                     .isNotEmpty,
          //                 child: Container(
          //                   padding: const EdgeInsets.symmetric(
          //                       horizontal: 6, vertical: 2),
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(5),
          //                     color: const Color(0xffAAD2F2),
          //                   ),
          //                   child: Text(
          //                     context
          //                         .read<HomePageCubit>()
          //                         .getNotification(false)
          //                         .length
          //                         .toString(),
          //                     style: context.textTheme.bodySmall?.copyWith(
          //                       color: const Color(0xff062640),
          //                       fontWeight: FontWeight.w600,
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             },
          //           )
          //         ],
          //       ),
          //     ),
          //     Tab(
          //       icon: Text(
          //         'Read',
          //         style: context.textTheme.bodyLarge?.copyWith(
          //           fontWeight: FontWeight.w600,
          //           color: AppColors.white,
          //         ),
          //       ),
          //     ),
          //   ],
          //   indicatorWeight: 6,
          //   indicatorColor: const Color(0xff8ABCE5),
          // ),
        ),
        body: ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, loading, __) {
            return loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                    ),
                  )
                : BlocBuilder<HomePageCubit, HomePageState>(
                    builder: (context, state) {
                      return (state as HomePageLoaded).notifications != null &&
                              state.notifications!.isEmpty
                          ? Center(
                              child: Text(
                                'No new notifications at the moment.',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : NotificationItem(
                              notifications: state.notifications ?? [],
                              onTap: (NotificationModel notificationModel) {
                                onNavigation(notificationModel.data!,
                                    notificationModel.title);
                                context
                                    .read<HomePageCubit>()
                                    .onReadNotification([notificationModel]
                                        .map((e) => e.id!)
                                        .toList());
                              },
                            );
                    },
                  );
          },
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem(
      {super.key, required this.notifications, required this.onTap});

  final List<NotificationModel> notifications;
  final ValueChanged<NotificationModel> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int index) {
        final NotificationModel notificationModel = notifications[index];

        return ListTile(
          onTap: () {
            onTap.call(notificationModel);
          },
          tileColor: !(notificationModel.isRead ?? false)
              ? const Color(0xffF9F9F8)
              : Colors.white,
          leading: CircleAvatar(
            backgroundColor: const Color(0xff062640),
            radius: 20,
            child: SvgPicture.asset(
              AppImages.fish,
              width: 24,
              height: 10,
              colorFilter: const ColorFilter.mode(
                Color(0xffD9EEFF),
                BlendMode.srcIn,
              ),
            ),
          ),
          title: Text(
            notificationModel.title ?? '',
            style: context.textTheme.bodyMedium?.copyWith(
              color: const Color(0xff174A73),
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            DateFormat("dd/MM/yyyy hh:mma")
                .format(DateTime.parse(notificationModel.createdAt!)),
            style: context.textTheme.bodySmall?.copyWith(
              color: const Color(0xff8ABCE5),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
