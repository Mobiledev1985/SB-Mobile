
import 'package:flutter/material.dart';

class SbBackButton extends StatelessWidget {
  const SbBackButton({
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
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
        ),
      ),
    );
  }
}
