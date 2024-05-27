import 'package:flutter/material.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';

class SnackBarWidget extends StatelessWidget {
  final List<Widget> snackBarElements;

  final AppStyles appStyles = AppStyles() ;

  SnackBarWidget({Key? key,required this.snackBarElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check),
          Text(
              "Completed",
            style: TextStyle(
              fontFamily: appStyles.fontGilroy,
            ),
          ),
        ],
      ),
    );
  }
}
