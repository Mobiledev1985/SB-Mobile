import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sb_mobile/core/constant/app_images.dart';

class CustomIcons {
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor?> getGenericFisheryMarker() async {
    try {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/search/green_fish.png', 100);
      final BitmapDescriptor customIcon =
          BitmapDescriptor.fromBytes(markerIcon);
      return customIcon;
    } on Exception {
      return null;
    }
  }

  Future<BitmapDescriptor?> getSelectedIcon() async {
    try {
      final Uint8List markerIcon =
          await getBytesFromAsset(AppImages.fishWithCircleBlack, 100);
      final BitmapDescriptor customIcon =
          BitmapDescriptor.fromBytes(markerIcon);
      return customIcon;
    } on Exception {
      return null;
    }
  }

  Future<BitmapDescriptor?> getBookableMarker() async {
    try {
      final Uint8List markerIcon =
          await getBytesFromAsset(AppImages.fishWithCircle, 100);
      final BitmapDescriptor customIcon =
          BitmapDescriptor.fromBytes(markerIcon);
      return customIcon;
    } on Exception {
      return null;
    }
  }
}

class QuickFactsIconMapping {
  final Map<String, AssetImage> quickFacts = {
    'Guests Allowed':
        const AssetImage('assets/fishery_profile/guestsallowed.png'),
    'Members Only': const AssetImage('assets/fishery_profile/memon.png'),
    'Young Anglers':
        const AssetImage('assets/fishery_profile/facilities/YoungAnglers.png'),
    'Night Fishing':
        const AssetImage('assets/fishery_profile/nightfishing.png'),
    'Lake exclusive': const AssetImage('assets/fishery_profile/lakeex.png'),
    'Day Ticket':
        const AssetImage('assets/fishery_profile/facilities/DayTicket.png'),
    'Matches Allowed':
        const AssetImage('assets/fishery_profile/matchesallowed.png'),
    'Disabled Access':
        const AssetImage('assets/fishery_profile/disabledaccess.png'),
    'Tackle Shop': const AssetImage('assets/fishery_profile/tackleshop.png'),
  };

  AssetImage? getQuickFactAssetByName(String name) {
    if (quickFacts.containsKey(name)) {
      return quickFacts[name];
    } else {
      return const AssetImage('assets/fishery_profile/facilities/Hook.png');
    }
  }
}

class FacilitiesIconMapping {
  final Map<String, AssetImage> quickFacts = {
    'Café': const AssetImage('assets/fishery_profile/cafe.png'),
    'Cafe': const AssetImage('assets/fishery_profile/cafe.png'),
    'Car Park': const AssetImage('assets/fishery_profile/carpark.png'),
    'Electric Hookup':
        const AssetImage('assets/fishery_profile/electrichookup.png'),
    'Disabled Parking':
        const AssetImage('assets/fishery_profile/disabledparking.png'),
    'Showers': const AssetImage('assets/fishery_profile/showers.png'),
    'Tackle Shop': const AssetImage('assets/fishery_profile/tackleshop.png'),
    'Toilets': const AssetImage('assets/fishery_profile/toilets.png'),
    'WiFi Access': const AssetImage('assets/fishery_profile/wifi.png'),
    'Pets Allowed': const AssetImage('assets/fishery_profile/petsallowed.png'),
    'Wifi Access': const AssetImage('assets/fishery_profile/wifi.png'),
    '24 Hour Access': const AssetImage('assets/fishery_profile/24.png'),
  };

  AssetImage? getQuickFactAssetByName(String name) {
    if (quickFacts.containsKey(name)) {
      return quickFacts[name];
    } else {
      return const AssetImage('assets/fishery_profile/facilities/Hook.png');
    }
  }
}
