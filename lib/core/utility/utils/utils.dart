import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:timeago/timeago.dart' as timeago;

DateTime? parseDateTime({required String dateTimeStr}) {
  try {
    return DateTime.parse(dateTimeStr);
  } on Exception {
    return null;
  }
}

DateTime? parseDateTimeStandard({required String dateTimeStr}) {
  try {
    return DateTime.parse(dateTimeStr);
  } on Exception {
    return null;
  }
}

DateTime? timeFromString({required String dateTimeStr}) {
  try {
    return DateTime.parse(dateTimeStr);
  } on Exception {
    return null;
  }
}

DateTime? dateFromString({required String dateTimeStr}) {
  try {
    return DateTime.parse(dateTimeStr);
  } on Exception {
    return null;
  }
}

String dateFormat(String date) {
  final apiDateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final desiredFormat = DateFormat('dd/MM/yy HH:mm');
  final parsedDate = apiDateFormat.parse(date);
  final formattedDate = desiredFormat.format(parsedDate);
  return formattedDate;
}

String? getDateStr({required DateTime dateTimeObj}) {
  try {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dateTimeObj);
    return formatted;
  } on Exception {
    return null;
  }
}

String? parseStandardDate({required DateTime dateTimeObject}) {
  try {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(dateTimeObject);
    return formatted;
  } on Exception {
    return null;
  }
}

String? getDateString({required String datetime}) {
  String dateFormat = 'EEEE, do MMMM ';
  DateTime date = parseDateTime(dateTimeStr: datetime)!;
  return Jiffy(date).format(dateFormat);
}

Future<File?> pickImage(ImageSource imageSource, BuildContext context) async {
  try {
    final XFile? image = await ImagePicker().pickImage(source: imageSource);
    if (image != null) {
      return File(image.path);
    }
  } catch (e) {
    showAlert(
      'Image type not supported - please upload a different image',
    );
  }
  return null;
}

Future<File?> showImagePickBottomSheet(BuildContext context) async {
  FocusScope.of(context).unfocus();
  File? file;
  await showModalBottomSheet(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    await pickImage(ImageSource.camera, context).then((value) {
                      file = value;
                      Navigator.pop(context);
                    });
                  },
                  child: Column(
                    children: [
                      const Icon(
                        CupertinoIcons.camera_fill,
                        size: 40,
                        color: AppColors.blue,
                      ),
                      Text(
                        'Camera',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: AppColors.blue,
                            ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    await pickImage(ImageSource.gallery, context).then((value) {
                      file = value;
                      Navigator.pop(context);
                    });
                  },
                  child: Column(
                    children: [
                      const Icon(
                        Icons.photo_library,
                        size: 40,
                        color: AppColors.blue,
                      ),
                      Text(
                        "Gallery",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: AppColors.blue),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
  return file;
}

String bookingConfirmationDate({required String datetime}) {
  String dateFormat = 'E do MMM h a';
  DateTime date = parseDateTimeStandard(dateTimeStr: datetime)!;
  return Jiffy(date).format(dateFormat);
}

String getDate(DateTime date) {
  final formatter = DateFormat('EEE dd MMM yyyy');
  return formatter.format(date);
}

DateTime parseStringToDate(String dateString) {
  final formatter = DateFormat('EEE dd MMM yyyy');
  return formatter.parse(dateString);
}

String getFullDate(DateTime date) {
  final formatter = DateFormat('EEEE dd MMMM yyyy');
  return formatter.format(date);
}

DateTime? parseDate({required String dateTimeStr}) {
  try {
    return DateFormat('dd-mm-yyyy').parse(dateTimeStr.split("T")[0]);
  } on Exception {
    return null;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

List<DateTime>? parseListOfDate({List<String>? dates}) {
  if (dates == null) {
    return [];
  }
  List<DateTime> results = [];
  try {
    for (var date in dates) {
      results.add(DateTime.parse(date));
    }
    return results;
  } on Exception {
    return null;
  }
}

bool isPastTime(String dateTime) {
  DateTime now = DateTime.now();
  DateTime arrival = DateTime.parse(dateTime);

  return now.isAfter(arrival);
}

bool isFutureTime(String dateTime) {
  DateTime now = DateTime.now();
  DateTime arrival = DateTime.parse(dateTime);

  return now.isBefore(arrival);
}

String truncateWithEllipsis({required int cutoff, required String myString}) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

String timeAgoSinceDate(
    {bool numericDates = false, required String dateString}) {
  final date = DateTime.parse(dateString);
  return timeago.format(date);
}

String convertTimeOfDayToString(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dateTime =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  final twentyFourHourFormat =
      DateFormat.Hm().format(dateTime); // Format as 24-hour time
  return twentyFourHourFormat;
}

TimeOfDay convertStringToTimeOfDay(String timeString) {
  List<String> parts = timeString.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  return TimeOfDay(hour: hour, minute: minute);
}

String convertDateWithSuffix(String date) {
  DateTime dateTime = DateTime.parse(date);
  return DateFormat('d\'${getSuffix(dateTime.day)}\' MMMM y').format(dateTime);
}

// A helper function to get the correct suffix for the day
String getSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

void openUrlInWebBrowser(String url) {
  InAppBrowserClassOptions options = InAppBrowserClassOptions(
    crossPlatform: InAppBrowserOptions(
      toolbarTopBackgroundColor: Colors.grey[350],
    ),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
      ),
    ),
  );
  final InAppBrowser browser = InAppBrowser();

  //Navigate to in app web browser
  browser.openUrlRequest(
    urlRequest: URLRequest(
      url: Uri.parse(url),
    ),
    options: options,
  );
}
