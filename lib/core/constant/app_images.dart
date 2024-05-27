/// The class [AppImages] provides a convenient way to access image paths within the app.
///
/// To use this class, import 'package:flutter/material.dart' and 'package:your_app_name/app_images.dart'.
/// Once imported, you can use the static constant 'logo' to display an image in your Flutter app.
///
/// Example usage:
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:your_app_name/app_images.dart';
///
/// // ...
///
/// Image.asset(
///   AppImages.logo,
///   width: 100,
///   height: 100,
/// )
/// ```
///
/// In this example, the static constant 'logo' is assumed to be the path to the logo image, such as 'assets/images/logo.png'.
/// You can adjust the width and height properties to fit your desired image size.
///
/// Please ensure that you have the necessary imports and that the app_images.dart file is located correctly within your project.
abstract final class AppImages {
  static const String _prefixImages = "assets/images/";
  static const String _prefixGIF = "assets/gif/";
  static const String _prefixIcons = "assets/icons/";
  static const String logo = "${_prefixImages}swimbooker_logo.png";
  static const String teamSB = "${_prefixImages}team_SB.png";
  static const String onYourWay = "${_prefixImages}on_your_way.png";
  static const String animationImage = "${_prefixImages}animation_image.png";
  static const String sbSlider1 = "${_prefixImages}sb_slider_1.png";
  static const String sbSlider2 = "${_prefixImages}sb_slider_2.png";
  static const String sbSlider3 = "${_prefixImages}sb_slider_3.png";
  static const String sbSlider4 = "${_prefixImages}sb_slider_4.png";
  static const String noImageUploaded = "${_prefixImages}no-photo.jpg";
  static const String phoneBanner = "${_prefixImages}phone_banner.png";
  static const String phoneBanner2 = "${_prefixImages}phone_banner2.png";
  static const String banner = "${_prefixImages}banner.png";
  static const String youtube = "${_prefixImages}youtube.png";
  static const String rightArrow = "${_prefixIcons}right_arrow.svg";
  static const String scanProfile = "${_prefixIcons}scan_profile_icon.svg";
  static const String degrees = "${_prefixIcons}360-degrees.svg";
  static const String notificationIcon = "${_prefixIcons}notification_icon.svg";
  static const String drone = "${_prefixIcons}drone.svg";
  static const String notification = "${_prefixIcons}notification.svg";
  static const String fish = "${_prefixIcons}fish.svg";
  static const String fishPlus = "${_prefixIcons}fish_plus.svg";
  static const String search = "${_prefixIcons}search.svg";
  static const String favoriteBorder =
      "${_prefixIcons}favorite_icon_border.svg";
  static const String mapIcon = "${_prefixIcons}map.svg";
  static const String fishing = "${_prefixIcons}fishing.svg";
  static const String bell = "${_prefixIcons}bell.svg";
  static const String invite = "${_prefixIcons}invite.svg";
  static const String chat = "${_prefixIcons}chat.svg";
  static const String home = "${_prefixIcons}home.svg";
  static const String copy = "${_prefixIcons}copy.svg";
  static const String email = "${_prefixIcons}email.svg";
  static const String password = "${_prefixIcons}password.svg";
  static const String searchIcon = "${_prefixIcons}search_icon.svg";
  static const String dateIcon = "${_prefixIcons}date_icon.svg";
  static const String addIcon = "${_prefixIcons}add_icon.svg";
  static const String captureIcon = "${_prefixIcons}capture_icon.svg";
  static const String favouriteIcon = "${_prefixIcons}favorite_icon.svg";
  static const String emailInviteIcon = "${_prefixIcons}email_invite_icon.svg";
  static const String socialIcon = "${_prefixIcons}social_icon.svg";
  static const String liveSupportIcon = "${_prefixIcons}live_support_icon.svg";
  static const String arrowBackIcon = "${_prefixIcons}arrow_back_icon.svg";
  static const String statistics = "${_prefixIcons}Statistics.svg";
  static const String editImageIcon = "${_prefixIcons}edit_image_icon.svg";
  static const String catches = "${_prefixIcons}Catches.svg";
  static const String fishingIcon = "${_prefixIcons}fishing_icon.svg";
  static const String bookings = "${_prefixIcons}Bookings.png";
  static const String progress = "${_prefixIcons}Progress.svg";
  static const String myDetails = "${_prefixIcons}Details.svg";
  static const String myMemberships = "${_prefixIcons}membership.svg";
  static const String favourite = "${_prefixIcons}Favourites.svg";
  static const String checked = "${_prefixIcons}checked.svg";
  static const String weight = "${_prefixIcons}weight.svg";
  static const String swimbooker = "${_prefixGIF}swimbooker.gif";
  static const String fisheries = "${_prefixGIF}fisheries.json";
  static const String mysb = "${_prefixGIF}mysb.json";
  static const String notificationGIF = "${_prefixGIF}notification.json";
  static const String giveawaysIcon = "${_prefixIcons}giveaways_icon.svg";
  static const String percentIcon = "${_prefixIcons}percent.svg";
  static const String perks = "${_prefixIcons}perks.svg";
  static const String sessionIcon = "${_prefixIcons}sessions_icon.svg";
  static const String shopIcon = "${_prefixIcons}shop_icon.svg";
  static const String coinIcon1 = "${_prefixIcons}coin_1.svg";
  static const String coinIcon2 = "${_prefixIcons}coin_2.svg";
  static const String avivaLogo = "${_prefixImages}aviva_logo.png";
  static const String wallet = "${_prefixImages}wallet.svg";
  static const String fishingStats = "${_prefixImages}fishing_stats.svg";
  static const String gallery = "${_prefixImages}gallery.svg";
  static const String sessionDetails = "${_prefixImages}session_details.svg";
  static const String notes = "${_prefixImages}notes.svg";
  static const String filter = "${_prefixIcons}filter.svg";
  static const String share = "${_prefixIcons}share.png";
  static const String checkMark = "${_prefixIcons}check_mark.svg";
  static const String cross = "${_prefixIcons}cross.svg";
  static const String refresh = "${_prefixIcons}refresh.svg";
  static const String unloack = "${_prefixIcons}unlock.svg";
  static const String editNotes = "${_prefixIcons}edit_notes.svg";
  static const String insurance = "${_prefixIcons}insurance.svg";
  static const String eye = "${_prefixIcons}eye.svg";
  static const String gift = "${_prefixIcons}gift.svg";
  static const String cameraPlus = "${_prefixIcons}camera_plus.svg";
  static const String party = "${_prefixIcons}party.svg";
  static const String remove = "${_prefixIcons}remove.svg";
  static const String ticket = "${_prefixIcons}ticket.svg";
  static const String multipleFish = "${_prefixIcons}multiple_fish.svg";
  static const String bait = "${_prefixIcons}bait.svg";
  static const String ring = "${_prefixIcons}ring.svg";
  static const String phone = "${_prefixIcons}phone.svg";
  static const String filterIcon = "${_prefixIcons}filter_icon.svg";
  static const String fishWithEye = "${_prefixIcons}fish_with_eye.svg";
  static const String sea = "${_prefixIcons}sea.svg";
  static const String weightIcon = "${_prefixIcons}weight_icon.svg";
  static const String favouriteIcon1 = "${_prefixIcons}favourite_icon.svg";
  static const String unFavourite = "${_prefixIcons}unfavourite.svg";
  static const String fishWithCircle = "${_prefixIcons}fish_with_circle.png";
  static const String fishWithCircleBlack =
      "${_prefixIcons}fish_with_circle_black.png";
  static const String sbPlusBannerImage = "${_prefixImages}sb_plus.png";
  static const String sbPlusWhiteLogo = "${_prefixIcons}sb_plus_white_logo.png";
  static const String checkIcon = "${_prefixIcons}check_icon.svg";
  static const String googleIcon = "${_prefixIcons}google_icon.svg";
  static const String liveAvailibility = "${_prefixIcons}live_availability.svg";
  static const String howToBook = "${_prefixIcons}how_to_book.svg";
  static const String locationSiteMap = "${_prefixIcons}location_site_map.svg";
  static const String localWeather = "${_prefixIcons}weather.svg";
  static const String venueRules = "${_prefixIcons}venue_rules.svg";
  static const String food = "${_prefixIcons}food.svg";
  static const String trophy = "${_prefixIcons}trophy.svg";
  static const String notFound = "${_prefixImages}not_found.svg";
  static const String errorImage = "${_prefixImages}no_content.svg";
}
