// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
// import 'package:provider/provider.dart';
// import 'package:sb_mobile/core/constant/app_colors.dart';
// import 'package:sb_mobile/core/extension/context_extension.dart';
// import 'package:sb_mobile/core/routes/route_paths.dart';
// import 'package:sb_mobile/core/utility/utils/utils.dart';
// import 'package:sb_mobile/core/widgets/space_horizontal.dart';
// import 'package:sb_mobile/core/widgets/space_vertical.dart';
// import 'package:sb_mobile/features/authentication/providers/subscription_provider.dart';
// import 'package:sb_mobile/features/authentication/ui/views/login_screen.dart';
// import 'package:sb_mobile/features/authentication/ui/widgets/tier_section_screen.dart';
// import 'package:sb_mobile/features/authentication/ui/widgets/what_you_get.dart';

// class FeatureListScreen extends StatefulWidget {
//   const FeatureListScreen({super.key, required this.email});

//   final String? email;

//   static MaterialPageRoute<dynamic> buildRouter(String? email) {
//     return MaterialPageRoute(
//       builder: (context) => FeatureListScreen(email: email),
//     );
//   }

//   static Future<void> navigateTo(BuildContext context, String? email) async {
//     await Navigator.pushNamed(context, RoutePaths.featureListScreen,
//         arguments: email);
//   }

//   @override
//   State<FeatureListScreen> createState() => _FeatureListScreenState();
// }

// class _FeatureListScreenState extends State<FeatureListScreen> {
//   @override
//   void initState() {
//     if (Platform.isAndroid) {
//       SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(
//             statusBarColor: Color(0xffF2F2F2),
//             statusBarIconBrightness: Brightness.dark),
//       );
//     } else {
//       FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
//       FlutterStatusbarcolor.setStatusBarColor(
//         const Color(0xffF2F2F2),
//       );
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     if (Platform.isAndroid) {
//       SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(
//           statusBarColor: Colors.white,
//           statusBarIconBrightness: Brightness.dark,
//         ),
//       );
//     } else {
//       FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
//       FlutterStatusbarcolor.setStatusBarColor(Colors.white);
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF2F2F2),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SpaceVertical(20 + MediaQuery.paddingOf(context).top),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const CircleAvatar(
//                 radius: 16,
//                 backgroundColor: AppColors.black,
//                 child: Align(
//                   alignment: Alignment(0.99, 0.0),
//                   child: Icon(
//                     Icons.arrow_back_ios,
//                     color: AppColors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SpaceVertical(8),
//           SizedBox(
//             height: 130,
//             child: ScrollConfiguration(
//               behavior: MyBehavior(),
//               child: ListView.separated(
//                 padding: const EdgeInsets.only(top: 0, left: 10),
//                 itemCount: 6,
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.asset(
//                       'assets/images/slider${index + 1}.png',
//                       width: 260,
//                       height: 130,
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 },
//                 separatorBuilder: (context, index) => const SpaceHorizontal(4),
//               ),
//             ),
//           ),
//           const SpaceVertical(8),
//           const Expanded(child: WhatYouGet()),
//           const SpaceVertical(24),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: SizedBox(
//               width: double.infinity,
//               height: 46,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.black,
//                 ),
//                 onPressed: () {
//                   if (widget.email == null) {
//                     context.read<SubscriptionProvider>().isFromBanner = true;
//                     LoginScreen.navigateTo(context, true);
//                   } else {
//                     TierSectionScreen.navigateTo(
//                       context,
//                       (email: widget.email!, isFromFeatureScreen: true),
//                       false,
//                     );
//                   }
//                 },
//                 child: Text(
//                   'Get Started',
//                   style: context.textTheme.displaySmall?.copyWith(
//                     color: AppColors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SpaceVertical(24),
//         ],
//       ),
//     );
//   }
// }
