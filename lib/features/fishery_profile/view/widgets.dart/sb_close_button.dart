
import 'package:flutter/material.dart';

class SbCloseButton extends StatelessWidget {
  const SbCloseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      top: 38,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black.withOpacity(.2))),
          child: const Icon(
            Icons.close,
            size: 24,
          ),
        ),
      ),
    );
  }
}
