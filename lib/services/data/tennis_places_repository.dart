import 'dart:async';

import 'package:find_my_tennis/utlities/app_secrets.dart';
import 'package:find_my_tennis/utlities/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:rxdart/rxdart.dart';

class TennisPlacesRepository {
  TennisPlacesRepository({
    this.initialCentre = Constants.wimbledon,
  }) {
    updateCentre(centre: initialCentre);
  }

  final LatLng initialCentre;

  BehaviorSubject<List<PlacesSearchResult>> _placesSearchResultSubject =
      BehaviorSubject<List<PlacesSearchResult>>.seeded([]);

  Stream<List<PlacesSearchResult>> get placesSearchResultStream =>
      _placesSearchResultSubject.stream;

  final GoogleMapsPlaces _googleMapsPlaces = GoogleMapsPlaces(
    apiKey: AppSecrets.mapsWebApiKey,
  );

//  final GoogleMapsPlaces _googleMapsPlaces = GoogleMapsPlaces(
//    apiKey: Platform.isIOS
//        ? AppSecrets.mapsIosAPIKey
//        : AppSecrets.mapsAndroidAPIKey,
//  );

  void updateCentre({@required LatLng centre}) async {
    if (centre != null) {
      _placesSearchResultSubject.add(await getTennisCourtPlaces(centre));
    }
  }

  Future<List<PlacesSearchResult>> getTennisCourtPlaces(LatLng centre) async {
    PlacesSearchResponse response =
        await _googleMapsPlaces.searchNearbyWithRadius(
      Location(centre.latitude, centre.longitude),
      3000,
      keyword: 'tennis+courts',
    );

    if (!response.isOkay) {
      print('error returning results');
      print(response.errorMessage);
    }

    if (response.isOkay) {
      print('places query returned ${response.results.length} tennis places');
      return response.results;
    }

    return null;
  }

  void dispose() {
    _placesSearchResultSubject.close();
  }
}
