import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';

typedef Validator = String? Function(String?)?;

class TextFieldItem extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool readOnly;
  final bool? obscureText;
  final Validator validator;
  final TextInputAction? textInputAction;
  const TextFieldItem({
    super.key,
    required this.title,
    required this.controller,
    required this.readOnly,
    this.obscureText,
    this.validator,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Visibility(
            visible: title.isNotEmpty,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 240,
            child: TextFormField(
              obscureText: obscureText ?? false,
              controller: controller,
              readOnly: readOnly,
              textInputAction: textInputAction ?? TextInputAction.next,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: readOnly ? const Color(0xff787878) : Colors.black,
                  ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                filled: true,
                fillColor: readOnly ? const Color(0xffEDEDED) : AppColors.white,
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
