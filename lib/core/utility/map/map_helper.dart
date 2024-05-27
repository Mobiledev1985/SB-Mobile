import 'dart:async';
import 'dart:ui';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';

import 'model/map_cluster_property.dart';
import 'model/map_marker.dart';

part './map_cluster.dart';

class MapHelper {
  static final MapHelper _instance = MapHelper._init();
  AppStyles appStyles = AppStyles();

  static MapHelper get instance {
    MapHelper._init();
    return _instance;
  }

  MapHelper._init();

  ClusterProperty get clusterProperty => ClusterProperty(
      minClusterZoom: 0,
      maxClusterZoom: 19,
      clusterColor: const Color(0xff174A73),
      currentZoom: 15,
      clusterWidth: 100,
      clusterTextColor: Colors.white);

  Future<BitmapDescriptor> bitmapToasset(
      String assetName, bool isSelected) async {
    final icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), assetName);

    return icon;
  }

  Future<Fluster<MapMarker>> initClusterManager(
    List<MapMarker> markers,
    int minZoom,
    int maxZoom,
  ) async {
    return Fluster<MapMarker>(
      minZoom: minZoom,
      maxZoom: maxZoom,
      radius: 150,
      extent: 2048,
      nodeSize: 64,
      points: markers,
      createCluster: (cluster, lng, lat) {
        return MapMarker(
          id: cluster.id.toString(),
          position: LatLng(lat, lng),
          isCluster: cluster.isCluster,
          clusterId: cluster.id,
          pointsSize: cluster.pointsSize,
          childMarkerId: cluster.childMarkerId,
        );
      },
    );
  }

  Future<List<Marker>> getClusterMarkers(
    Fluster<MapMarker> clusterManager,
    double currentZoom,
    Color clusterColor,
    Color clusterTextColor,
    int clusterWidth,
  ) {
    // if (clusterManager) return Future.value([]);

    return Future.wait(clusterManager.clusters(
        [-180, -90, 180, 90], currentZoom.toInt()).map((mapMarker) async {
      if (mapMarker.isCluster!) {
        mapMarker.icon = await _getClusterMarker(
          mapMarker.pointsSize!,
          clusterColor,
          clusterTextColor,
          clusterWidth,
        );
      }

      return mapMarker.toMarker();
    }).toList());
  }
}
