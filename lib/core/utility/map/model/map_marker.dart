import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarker extends Clusterable {
  final String id;
  final LatLng position;

  BitmapDescriptor? icon;
  String? title;

  dynamic markerIndex;
  dynamic tapFunction;
  @override
  // ignore: overridden_fields
  bool? isCluster;
  MapMarker({
    required this.id,
    required this.position,
    this.tapFunction,
    this.markerIndex,
    this.title,
    this.icon,
    this.isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
          markerId: id,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );
  Marker toMarker() => Marker(
        markerId: MarkerId(isCluster ?? true ? 'cl_$id' : id),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
        icon: icon ?? BitmapDescriptor.defaultMarker,
        onTap: () {
          tapFunction?.call(markerIndex);
        },
      );

  // Marker toMarker() => Marker(
  //     markerId: MarkerId(isCluster! ? 'cl_$id' : id),
  //     position: LatLng(
  //       position.latitude,
  //       position.longitude,
  //     ),
  //     icon: icon!,
  //     infoWindow: infoWindow!,
  //     onTap: () {
  //       tapFunction(markerIndex);
  //     });
}
