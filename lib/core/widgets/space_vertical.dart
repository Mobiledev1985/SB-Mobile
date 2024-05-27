import 'package:flutter/widgets.dart';

class SpaceVertical extends StatelessWidget {
  final double height;

  /// Use to add vertical space between widgets
  const SpaceVertical(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
