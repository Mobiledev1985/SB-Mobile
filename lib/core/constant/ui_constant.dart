/// The class [UIConstants] provides a convenient way to access UI-related constants within the app.

///
/// Example usage:
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:your_app_name/app_strings.dart';
///
/// Container(
///   width: 200,
///   height: 50,
///   decoration: BoxDecoration(
///     borderRadius: BorderRadius.circular(UIConstants.borderRadius),
///     color: Colors.blue,
///   ),
///   child: Center(
///     child: Text(
///       'Button',
///       style: TextStyle(
///         fontSize: 16,
///         fontWeight: FontWeight.bold,
///         color: Colors.white,
///       ),
///     ),
///   ),
/// ),
/// ```
///

/// This code snippet demonstrates how to import the UIConstants class and use the static constant 'borderRadius'
/// to set the border radius of a container in your Flutter app. The value of 'borderRadius' is set to 8.0.

const double defaultBorderRadius = 20;
const double defaultPadding = 14;
const double defaultButtonRadius = 4;
const double defaultSidePadding = 12;
const String mfontFamily = 'Montserrat';
