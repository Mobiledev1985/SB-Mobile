import 'package:flutter/widgets.dart';

class SpaceHorizontal extends StatelessWidget {
  final double width;

  /// Use to add Horizontal space between widgets

  const SpaceHorizontal(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
