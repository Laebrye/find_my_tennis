import 'dart:async';
import 'dart:io';

import 'package:find_my_tennis/utlities/app_secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:rxdart/rxdart.dart';

class TennisPlacesRepository {
  TennisPlacesRepository({
    this.initialCentre = const LatLng(51.4183, -0.2206),
  }) {
    updateCentre(centre: initialCentre);
  }

  final LatLng initialCentre;

  BehaviorSubject<List<PlacesSearchResult>> _placesSearchResultSubject =
      BehaviorSubject<List<PlacesSearchResult>>.seeded([]);

  Stream<List<PlacesSearchResult>> get placesSearchResultStream =>
      _placesSearchResultSubject.stream;

  final GoogleMapsPlaces _googleMapsPlaces = GoogleMapsPlaces(
    apiKey: Platform.isIOS
        ? AppSecrets.mapsIosAPIKey
        : AppSecrets.mapsAndroidAPIKey,
  );

  void updateCentre({@required LatLng centre}) async {
    _placesSearchResultSubject.add(await getTennisCourtPlaces(centre));
  }

  Future<List<PlacesSearchResult>> getTennisCourtPlaces(LatLng centre) async {
    PlacesSearchResponse response =
        await _googleMapsPlaces.searchNearbyWithRadius(
      Location(centre.latitude, centre.longitude),
      6000,
      keyword: 'tennis+courts',
    );

    if (response.isOkay) return response.results;

    return null;
  }

  void dispose() {
    _placesSearchResultSubject.close();
  }
}
