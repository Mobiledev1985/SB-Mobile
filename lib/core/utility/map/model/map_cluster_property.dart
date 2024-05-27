import 'package:flutter/widgets.dart';

class ClusterProperty {
  final int minClusterZoom;
  final int maxClusterZoom;
  final Color clusterColor;
  final Color clusterTextColor;
  double? currentZoom;
  final int clusterWidth;

  ClusterProperty({
    required this.minClusterZoom,
    required this.maxClusterZoom,
    required this.clusterColor,
    required this.clusterWidth,
    this.currentZoom,
    required this.clusterTextColor,
  });
}
