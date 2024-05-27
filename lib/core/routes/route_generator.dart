import 'package:flutter/material.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/authentication/ui/views/login_screen.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_introduction_screen.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_plus_purchase_screen.dart';
import 'package:sb_mobile/features/authentication/ui/views/sb_purchased_screen.dart';
import 'package:sb_mobile/features/authentication/ui/widgets/tier_section_screen.dart';
import 'package:sb_mobile/features/exclusiveMedia/ui/view/exclusive_media_common_screen.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/views/catch_report_detail_screen.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/how_to_book.dart';
import 'package:sb_mobile/features/fishery_property_details/ui/widgets/location_site_map.dart';
import 'package:sb_mobile/features/home_page/data/models/promotion_model.dart';
import 'package:sb_mobile/features/home_page/data/models/user_statistics.dart';
import 'package:sb_mobile/features/home_page/ui/views/catch_report_listing_screen.dart';
import 'package:sb_mobile/features/home_page/ui/views/notification_list_screen.dart';
import 'package:sb_mobile/features/my_profile/data/models/credit_history_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/session_detail_model.dart';
import 'package:sb_mobile/features/my_profile/ui/view/bookings_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/catches_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/favorite_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/my_details_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/my_memberships_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/progress_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/statistics_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/giveaways/giveaways_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/insurance/insurance_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/offer/fishery_discount_list_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/offer/offer_detail_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/offer/offer_list_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/offer/offer_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/session/session_detail_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/session/session_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/session/view_note_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/wallet/all_earned_credit_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/wallet/wallet_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/view_ticket_screen.dart';
import 'package:sb_mobile/features/submit_catch_report/ui/views/submit_catch_report_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.submitCatchReport:
        return SubmitCatchReportScreen.buildRouter(
          settings.arguments as CatchReport?,
        );

      case RoutePaths.catchReport:
        return CatchReportDetailScreen.buildRouter(
            settings.arguments as CatchReportScreenData);

      case RoutePaths.exclusiveMedia:
        return ExclusiveMediaCommonScreen.buildRouter(
            settings.arguments as ExclusiveScreenItem);

      case RoutePaths.progressScreen:
        return ProgressScreen.buildRouter(
            settings.arguments as ProgressScreenData);

      case RoutePaths.catchesScreen:
        return CatchesScreen.buildRouter(settings.arguments as AnglerProfile?);

      case RoutePaths.statisticsScreen:
        return StatisticsScreen.buildRouter(
            settings.arguments as UserStatistics);

      case RoutePaths.myDetailsScreen:
        return MyDetailsScreen.buildRouter(
            settings.arguments as MyDetailScreenData);

      case RoutePaths.bookingsScreen:
        return BookingsScreen.buildRouter(settings.arguments as AnglerProfile?);

      case RoutePaths.viewTicketScreen:
        return ViewTicketScreen.buildRouter(
            settings.arguments as ViewTicketScreenData);

      case RoutePaths.favoritesScreen:
        return FavoriteScreen.buildRouter(settings.arguments as AnglerProfile?);

      case RoutePaths.walletScreen:
        return WalletScreen.buildRouter(settings.arguments as AnglerProfile?);

      case RoutePaths.allEarnedCreditScreen:
        return AllEarnedCredit.buildRouter(
            settings.arguments as List<CreditHistory>);

      case RoutePaths.offerScreen:
        return OfferScreen.buildRouter(settings.arguments as AnglerProfile?);

      case RoutePaths.offerDetailScreen:
        return OfferDetailScreen.buildRouter(
            settings.arguments as OfferDetailData);

      case RoutePaths.insuranceScreen:
        return InsuranceScreen.buildRouter(settings.arguments as InsuranceData);

      case RoutePaths.sessionScreen:
        return SessionScreen.buildRouter(settings.arguments as AnglerProfile?);

      case RoutePaths.sessionDetailScreen:
        return SessionDetailScreen.buildRouter(settings.arguments as String);

      case RoutePaths.sbPlusPurchaseScreen:
        return SbPlusPurchaseScreen.buildRouter(
            settings.arguments as SubscriptionData);

      // case RoutePaths.featureListScreen:
      // return FeatureListScreen.buildRouter(settings.arguments as String?);

      case RoutePaths.tierSectionScreen:
        return TierSectionScreen.buildRouter(
          settings.arguments as TierSectionData,
        );

      case RoutePaths.subscriptionPurchased:
        return SBPurchasedScreen.buildRouter(settings.arguments as String);

      case RoutePaths.sbIntroductionScreen:
        return SBIntroductionScreen.buildRouter();

      case RoutePaths.loginScreen:
        return LoginScreen.buildRouter(settings.arguments as bool);

      case RoutePaths.offerListScreen:
        return OfferListScreen.buildRouter(settings.arguments as OfferListData);

      case RoutePaths.myMembershipsScreen:
        return MyMembershipsScreen.buildRouter(
          settings.arguments as AnglerProfile?,
        );

      case RoutePaths.fisheryDisountListScreen:
        return FisheryDiscountListScreen.buildRouter(
            settings.arguments as List<PromotionModel>);

      case RoutePaths.yourNoteScreen:
        return ViewNoteScreen.buildRouter(settings.arguments as SessionNotes);

      case RoutePaths.giveawayScreen:
        return GiveawaysScreen.buildRouter(
            settings.arguments as AnglerProfile?);

      case RoutePaths.notificationListScreen:
        return NotificationListScreen.buildRouter();

      case RoutePaths.catchReportListingScreen:
        return CatchReportListingScreen.buildRouter();

      case RoutePaths.locationSiteMap:
        return LocationSiteMap.buildRouter(settings.arguments as String?);

      case RoutePaths.howToBook:
        return HowToBook.buildRouter(settings.arguments as int);

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    AppStyles appStyles = AppStyles();
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Error Generating this route',
              style: TextStyle(
                fontFamily: appStyles.fontGilroy,
              ),
            ),
          ),
          body: Center(
            child: Text(
              'Error Generating this route',
              style: TextStyle(
                fontFamily: appStyles.fontGilroy,
              ),
            ),
          ),
        );
      },
    );
  }
}
