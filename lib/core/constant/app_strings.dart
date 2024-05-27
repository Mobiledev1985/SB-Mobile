/// The class [AppStrings] provides a convenient way to access string constants within the app.
///
/// To use this class, import 'package:flutter/material.dart' and 'package:your_app_name/app_strings.dart'.
/// Once imported, you can access the static constant 'login' to display a login text in your Flutter app.
///
/// Example usage:
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:your_app_name/app_strings.dart';
///
/// // ...
///
/// Text(
///   AppStrings.appName,
///   style: TextStyle(
///     fontSize: 16,
///     fontWeight: FontWeight.bold,
///   ),
/// )
/// ```
///
/// In this example, the static constant 'login' is set to the string "login". You can use it to display the login text
/// with the specified style in your Flutter app.
///
/// Please ensure that you have the necessary imports and that the app_strings.dart file is located correctly within your project.

abstract final class AppStrings {
  static const String appName = 'swimbooker';
  static const String swim = 'swim';
  static const String exclusiveMedia = 'booker™ Exclusive Media';
  static const String home = 'Home';
  static const String search = 'Search';
  static const String bookings = 'Bookings';
  static const String social = 'Social';
  static const String profile = 'Profile';
  static const String searchText = 'Search by Location or Fishery Name';
  static const String searchHintText = 'Where will your next session take you?';
  static const String bookableVenues = 'Bookable Venues';
  static const String liveCatchReports = 'Live Catch Reports';
  static const String swipForMore = 'Swipe for more';
  static const String seeMore = 'See more';
  static const String viewOnMap = 'View Venues On Map';
  static const String submitCatchReport = 'Submit Catch Report';
  static const String theAnglingSocial = 'The Angling Social';
  static const String inviteyour = 'Invite your angling buddies!';
  static const String enjoy =
      "If you’re enjoying the swimbooker™ experience, tap here to share the app with your angling squad!";
  static const String shareAppleAppStoreLink = 'Share Apple App Store Link';
  static const String shareGooglePlayStoreLink = 'Share Google Play Store Link';
  static const String hiAngler = 'Hi Angler!';
  static const String freeAccount =
      'Please login (or create a FREE account) for the complete swimbooker experience.';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String login = 'LOGIN';
  static const String forgotPasswordText = 'Forgot your password? Click ';
  static const String here = 'HERE';
  static const String toReset = ' to reset';
  static const String dontHaveAccount = 'Don’t have an account yet?';
  static const String signUp = 'SIGN UP HERE (IT’S FREE!)';
  static const String welcomeBack =
      'Welcome back! What would you like to do today?';
  static const String findFisheries = 'Find Fisheries';
  static const String myBooking = 'My Bookings';
  static const String addCatchReport = 'Add Catch Report';
  static const String myCapture = 'My Captures';
  static const String favourites = 'Favourites';
  static const String inviteFriends = 'Invite Friends';
  static const String anglingSocial = 'Angling Social';
  static const String liveSupport = 'Live Support';
  static const String logOut = 'LOG OUT';
  static const String welcome = 'Welcome Back';
  static const String yourStats = 'Your Stats';
  static const String standardMember = 'Standard Member';
  static const String catches = 'Catches';
  static const String sessionsBooked = 'Sessions';
  static const String reviews = 'Reviews';
  static const String progress = 'Angling Journey';
  static const String level = 'Level';
  static const String doYouEvenFishBro = 'Do You Even Fish Bro?';
  static const String statistics = 'Statistics';
  static const String myDetails = 'My Details';
  static const String myMembership = 'My\nMemberships';
  static const String myProfile = 'My Profile';
  static const String customiseYourSBProfile = 'Customise Your SB Profile';
  static const String changeProfilePicture = 'Change Profile Picture';
  static const String changeBackgroundImage = 'Change Background Image';
  static const String yourProgress = 'Your Progress';
  static const String howToProgress = 'How To Progress';
  static const String achievements = 'Achievements';
  static const String howDoIUnlock = 'How Do I Unlock Achievements?';
  static const String general = 'General';
  static const String specialist = 'Specialist';
  static const String catchReports = 'Catch Reports';
  static const String switchMetric = 'SWITCH METRIC';
  static const String editDetails = 'EDIT DETAILS';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String city = 'City';
  static const String address = 'Address';
  static const String anglingDetails = 'Angling Details';
  static const String sendPasswordReset = 'Send Password Reset';
  static const String yearsAngling = 'Years Angling';
  static const String species = 'Species';
  static const String weight = 'Weight';
  static const String bookerLoginDetails = 'booker Login Details';
  static const String saveChanges = 'Save Changes';
  static const String gotPicture = "I haven't got a picture";
  static const String enterFisheryName = "Enter Fishery Name";
  static const String enterLakeName = "Enter Lake Name";
  static const String selectLake = "Select Lake";
  static const String lengthOfSession = "Length of Session (optional)";
  static const String pleaseselectlake = "Please select lake";
  static const String pleaseEnterlake = "Please enter lake";
  static const String selectSwim = "Select Swim (optional)";
  static const String fishSpecies = "Fish Species";
  static const String fishWeightlbs = "Fish Weight (lbs)";
  static const String fishWeightoz = 'Fish Weight (oz)';
  static const String baitUsed = 'Bait Used (optional)';
  static const String rigUsed = 'Rig Used (optional)';
  static const String baiting = 'Baiting Tactics (optional)';
  static const String hookUsed = 'Hook Used (optional)';
  static const String hookLink = 'Hooklink Material Used (optional)';
  static const String fishName = 'Fish Name (optional)';
  static const String itNewPB = 'Is this a new PB?';
  static const String additionalInformation =
      'A few ideas: Wraps to spot, Features fished to, Depth of spot (optional)';
  static const String additionalFishInformation =
      'A few ideas: Any notable scale patterns, any scars or damage to the fish, is it the biggest fish in the lake? (optional)';

  static const String notes =
      'Notes (optional) Here you can keep track of things like: Wind Direction, Temperature, Air Pressure, Moon Phase etc.';

  static const String pleaseConfirm =
      'Please confirm the details of your catch report:';
  static const String fishCaugh = 'Fish Caught:';
  static const String using = 'Using:';
  static const String from = 'From:';
  static const String additional = 'Additional Info:';
  static const String on = 'On:';
  static const String newCatchReport = 'New Catch Report';
  static const String editCatchReport = 'Edit Catch Report';
  static const String next = 'NEXT';
  static const String back = 'BACK';
  static const String pleaseselectfishspecies = 'Please select fish species';
  static const String submit = 'SUBMIT';
  static const String selectDate = 'Select Date';
  static const String pleaseselectdate = 'Please select date';
  static const String selectTime = 'Select Time';
  static const String pleaseselecttime = 'Please select time';
  static const String basicInfo = 'Basic Info & Photo';
  static const String fishingDetails = 'Additional Capture Details';
  static const String summary = 'Summary';
  static const String submitted = 'Submitted';
  static const String updated = 'Updated';
  static const String catchReportSuccessfully =
      'Catch Report Submitted Successfully!';
  static const String catchUpdatedSuccessfully =
      'Catch Report Updated Successfully!';
  static const String whatHappensNext = 'What happens next?';
  static const String onceThe =
      'Once the fishery verifies the catch report it will automatically be added to the fishery profile. In the meantime you can view your personal catch reports below:';
  static const String visitFishery = 'VISIT FISHERY PROFILE';
  static const String backToHome = 'BACK TO HOME';
  static const String backToCatches = 'BACK TO CATCHES';
  static const String edit = 'Edit';
  static const String uploadPhoto = 'Upload Photo';
  static const String anglerTiers = 'Angler Tiers';
  static const String gainpoints = 'Gain points to unlock higher tiers!';
  static const String basicTiers = 'Basic Tiers';
  static const String tightlines = 'Tight lines';
  static const String yourAnglerJourney = 'Your Angler Journey';
  static const String earnPoints =
      'Earn points to progress through the ranks! Become the ultimate angler!';
  static const String howEarnPoints = 'How Do I Earn Points?';
  static const String or = 'OR';
  static const String unlockAchievements = 'Unlock Achievements';
  static const String tips = 'Tips:';
  static const String clickOn =
      'Click on an achievement for full details on how to unlock it.';
  static const String yourachievements =
      'Btw… Your achievements are automatically logged and you will be notified when you unlock new ones!';
  static const String howToUnlock = 'How To Unlock Achievements';
  static const String unlockAchievementsBy =
      'Unlock achievements by completing the action required.';
  static const String make = 'Make 5 bookings on swimbooker';
  static const String clickOnIcon =
      'Click on icon in order to see what it will take to unlock the achievement.';
  static const String onYourWay = 'On Your Way';
  static const String unlockDate = 'Unlock Date';
  static const String tosee =
      'To see full catch report details, simply click on the image.';
  static const String toSeeFull =
      'To see full booking details, click on the image tabs below.';
  static const String upcoming = 'Upcoming';
  static const String historical = 'Historical';
  static const String lake = 'Lake';
  static const String noOfAnlers = 'No. Of Anglers';
  static const String noOfGuests = 'No. Of Guests';
  static const String selected = 'Booked';
  static const String datesTimes = 'Dates & Times';
  static const String bookingDetails = 'Booking Details';
  static const String arrivalDetails = 'Arriving';
  static const String departureDetails = 'Departing';
  static const String gatecode = 'Gatecode(s)';
  static const String name = 'Name';
  static const String contactNumber = 'Contact Number';
  static const String emailAddress = 'Email';
  static const String paymentTotal = 'Payment Total: ';
}
