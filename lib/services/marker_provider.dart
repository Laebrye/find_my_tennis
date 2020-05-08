import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MarkerProvider {
  MarkerProvider._(this.context) {
    createBitmap();
  }

  factory MarkerProvider.instance(BuildContext context) =>
      MarkerProvider._(context);

  final BuildContext context;
  BitmapDescriptor _markerBitmap;

  final BehaviorSubject<BitmapDescriptor> _markerBitmapSubject =
      BehaviorSubject<BitmapDescriptor>();
  Stream<BitmapDescriptor> get markerBitmapStream =>
      _markerBitmapSubject.stream.distinct();

  Future<void> createBitmap() async {
    if (_markerBitmap == null) {
      _markerBitmap = await _getAssetIcon();
    }
    _markerBitmapSubject.add(_markerBitmap);
    return _markerBitmap;
  }

  Future<BitmapDescriptor> _getAssetIcon() async {
    final Completer<BitmapDescriptor> bitmapIcon =
        Completer<BitmapDescriptor>();
    final ImageConfiguration config = createLocalImageConfiguration(context);

    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/MapMarker.png', 50);

    return BitmapDescriptor.fromBytes(markerIcon);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
