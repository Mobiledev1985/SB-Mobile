import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomBarProvider extends InheritedWidget {
  final ValueNotifier<int> selectedBottomBarItem;
  // final TabController tabController;
  const BottomBarProvider({
    super.key,
    required this.selectedBottomBarItem,
    required Widget child,
    // required this.tabController,
  }) : super(child: child);

  static BottomBarProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BottomBarProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
