import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MarkerProvider {
  MarkerProvider._(this.context);

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

    const AssetImage('assets/images/MapMarker.png').resolve(config).addListener(
      ImageStreamListener(
        (ImageInfo image, bool sync) async {
          final ByteData bytes =
              await image.image.toByteData(format: ImageByteFormat.png);
          final BitmapDescriptor bitmap =
              BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
          bitmapIcon.complete(bitmap);
        },
      ),
    );

    return await bitmapIcon.future;
  }
}
