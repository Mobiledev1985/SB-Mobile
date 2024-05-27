import 'package:flutter/widgets.dart';

class TopPadding extends StatelessWidget {
  const TopPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.viewPaddingOf(context).top,
    );
  }
}
