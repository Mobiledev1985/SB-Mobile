import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';

class CustomExpansionPanel extends StatefulWidget {
  const CustomExpansionPanel({
    Key? key,
    required this.header,
    this.isOpenDefault = false,
    this.isBorder = false,
    required this.body,
    this.onTap,
  }) : super(key: key);

  final Widget header;
  final Widget body;
  final bool isOpenDefault;
  final bool isBorder;
  final GestureTapCallback? onTap;

  @override
  State<CustomExpansionPanel> createState() => _CustomExpansionPanelState();
}

class _CustomExpansionPanelState extends State<CustomExpansionPanel>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (widget.isOpenDefault) {
      _toggleExpanded();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.isBorder
          ? null
          : const EdgeInsets.symmetric(
              horizontal: defaultSidePadding, vertical: 5),
      decoration: widget.isBorder
          ? null
          : BoxDecoration(
              border: Border.all(
                color: const Color(0xffEAEAEA),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              widget.onTap?.call();
              _toggleExpanded.call();
            },
            child: widget.header,
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: Padding(
              padding:
                  widget.isBorder ? EdgeInsets.zero : const EdgeInsets.all(16),
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }
}
