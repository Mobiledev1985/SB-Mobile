import 'package:flutter/material.dart';
import 'package:sb_mobile/features/fishery_profile/view/widgets.dart/sb_close_button.dart';

import '../../../../core/widgets/alert.dart';

class FullScreenImage extends StatelessWidget {
  final NetworkImage imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStyles.sbGrey,
      body: Stack(
        children: [
          InteractiveViewer(
            child: Center(
              child: Image(
                image: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SbCloseButton()
        ],
      ),
    );
  }
}
