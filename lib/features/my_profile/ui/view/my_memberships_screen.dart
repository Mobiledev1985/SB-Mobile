import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_membership_cubit.dart';
import 'package:sb_mobile/features/my_profile/data/models/my_membership_model.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:sb_mobile/features/submit_catch_report/ui/widgets/outside_touch_hide_keyboard.dart';
import 'package:url_launcher/url_launcher.dart';

class MyMembershipsScreen extends StatefulWidget {
  final AnglerProfile? profile;
  const MyMembershipsScreen({super.key, required this.profile});

  @override
  State<MyMembershipsScreen> createState() => _MyMembershipsScreenState();

  static PageRouteBuilder<dynamic> buildRouter(AnglerProfile? profile) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) => MyMembershipCubit(),
        child: MyMembershipsScreen(profile: profile),
      ),
      settings: const RouteSettings(name: RoutePaths.myMembershipsScreen),
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.ease),
        );
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static void navigateTo(BuildContext context, AnglerProfile? profile) {
    Navigator.pushNamed(context, RoutePaths.myMembershipsScreen,
        arguments: profile);
  }
}

class _MyMembershipsScreenState extends State<MyMembershipsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<MyMembershipCubit>().getMemberships();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OutSideTouchHideKeyboard(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileBar(profile: widget.profile),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              left: defaultSidePadding, top: 34, bottom: 22),
                          child: BackButtonWidget(),
                        ),
                        BlocBuilder<MyMembershipCubit, MyMembershipState>(
                          builder: (context, state) {
                            if (state is MyMembershipsLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.blue,
                                ),
                              );
                            } else if (state is MyMembershipsLoaded) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultSidePadding),
                                    child: Text(
                                      [
                                        ...state.memberships,
                                        ...state.seasonTickets
                                      ].isEmpty
                                          ? 'No Memberships Available'
                                          : 'My Memberships',
                                      style: context.textTheme.headlineMedium
                                          ?.copyWith(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SpaceVertical(18),
                                  ...state.memberships.map(
                                    (e) => MemberShipCard(
                                      membershipAndSeasonTicketModel: e,
                                    ),
                                  ),
                                  ...state.seasonTickets.map(
                                    (e) => MemberShipCard(
                                      membershipAndSeasonTicketModel: e,
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        const SpaceVertical(40),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MemberShipCard extends StatelessWidget {
  const MemberShipCard(
      {super.key, required this.membershipAndSeasonTicketModel});

  final MembershipAndSeasonTicketModel membershipAndSeasonTicketModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: defaultSidePadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color(0xffEAEAEA),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: membershipAndSeasonTicketModel.fisheryImage ?? '',
                  width: 116,
                  fit: BoxFit.cover,
                ),
              ),
              const SpaceHorizontal(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SpaceVertical(12),
                    Builder(
                      builder: (context) {
                        final bool isActive = membershipAndSeasonTicketModel
                                    .renewalDate ==
                                null ||
                            DateTime.parse(
                                    membershipAndSeasonTicketModel.renewalDate!)
                                .isAfter(
                              DateTime.now(),
                            );

                        return Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(
                                      0xffC2F2DE,
                                    )
                                  : const Color(0xffFFB2B2),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: Text(
                              isActive ? 'ACTIVE' : 'EXPIRED',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: isActive
                                    ? const Color(0xff064028)
                                    : const Color(0xff590000),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                    const SpaceVertical(5),
                    Text(
                      membershipAndSeasonTicketModel.fishery ?? '',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0D3759),
                      ),
                    ),
                    const SpaceVertical(4),
                    Text(
                      membershipAndSeasonTicketModel.lakes != null
                          ? 'SEASON TICKET HOLDER'
                          : 'LAKE MEMBER',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 10,
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceVertical(12),
                    if (membershipAndSeasonTicketModel.renewalDate != null) ...[
                      Text(
                        'Renewal Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(membershipAndSeasonTicketModel.renewalDate!))}',
                        style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff5C6166)),
                      ),
                      const SpaceVertical(4),
                    ],
                    if (membershipAndSeasonTicketModel.lakes != null)
                      Row(
                        children: [
                          Text(
                            'Applies to: ${membershipAndSeasonTicketModel.lakes?.length} Lakes',
                            style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff5C6166)),
                          ),
                          const SpaceHorizontal(4),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => LakeAccessDialog(
                                  access:
                                      membershipAndSeasonTicketModel.lakes ??
                                          [],
                                ),
                              );
                            },
                            child: const Icon(
                              CupertinoIcons.info,
                              size: 15,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    const SpaceVertical(18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            try {
                              await launchUrl(Uri.parse(
                                  'tel:${membershipAndSeasonTicketModel.fisheryPhone}'));
                            } catch (e) {
                              //
                            }
                          },
                          child: Text(
                            'Contact Fishery',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SpaceHorizontal(14),
                        SizedBox(
                          height: 28,
                          child: IntrinsicWidth(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  '/fishery/profile',
                                  arguments: {
                                    'id': '',
                                    'publicId': membershipAndSeasonTicketModel
                                        .fisheryId,
                                  },
                                ).then(
                                  (value) {
                                    Future.delayed(
                                      const Duration(milliseconds: 400),
                                    ).then(
                                      (value) {
                                        if (Platform.isAndroid) {
                                          SystemChrome.setSystemUIOverlayStyle(
                                            const SystemUiOverlayStyle(
                                              statusBarColor:
                                                  Colors.transparent,
                                              statusBarIconBrightness:
                                                  Brightness.light,
                                            ),
                                          );
                                        } else {
                                          FlutterStatusbarcolor
                                              .setStatusBarWhiteForeground(
                                                  true);
                                          FlutterStatusbarcolor
                                              .setStatusBarColor(
                                            Colors.transparent,
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'View Profile',
                                style: context.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SpaceVertical(14),
                  ],
                ),
              ),
              const SpaceHorizontal(14),
            ],
          ),
        ),
      ),
    );
  }
}

class LakeAccessDialog extends StatelessWidget {
  const LakeAccessDialog({super.key, required this.access});

  final List<String> access;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: AppColors.secondaryBlue,
          width: 3,
        ),
      ),
      backgroundColor: AppColors.blue,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Text(
                        'Lake Access',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceVertical(10),
              ...access
                  .map(
                    (e) => Text(
                      e,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        height: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
