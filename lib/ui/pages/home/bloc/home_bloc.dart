import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:find_my_tennis/services/data/firestore_database.dart';
import 'package:find_my_tennis/services/data/models/tennis_location.dart';
import 'package:find_my_tennis/services/data/tennis_places_repository.dart';
import 'package:find_my_tennis/services/marker_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  HomeBloc({
    @required this.uid,
    @required this.database,
    @required this.placesRepository,
    @required this.markerProvider,
    this.initialPosition = const LatLng(51.4183, -0.2206),
  }) {
    _mapCentreSubject = BehaviorSubject<LatLng>.seeded(initialPosition);
    _tennisLocationsListStream = database.tennisLocationsByDistanceStream();
    _tennisPlaces = placesRepository.placesSearchResultStream;
    _markerStream = markerProvider.markerBitmapStream;
    homePageStateStream = Rx.combineLatest4(
      _tennisLocationsListStream,
      _tennisPlaces,
      _markerStream,
      _mapCentreSubject.stream,
      (
        List<TennisLocation> tennisLocations,
        List<PlacesSearchResult> placesSearchResults,
        BitmapDescriptor markerBitmap,
        LatLng mapCentre,
      ) {
        // create a locations list with only the visible locations in it
        List<TennisLocation> finalLocations = tennisLocations
            .where((element) => element.isVisible == true)
            .toList();

        // extract the list of excluded locations
        List<TennisLocation> exludedLocations = tennisLocations
            .where((element) => element.isVisible == false)
            .toList();

        // remove anything in places search results that
        // is already included in the firestore query
        placesSearchResults.removeWhere(
          (place) =>
              tennisLocations.any((location) => location.placesId == place),
        );

        // convert any remaining placeSearchResults to a list of
        // TennisLocations
        List<TennisLocation> additionalLocations = placesSearchResults
            .map(
              (place) => TennisLocation.fromPlacesSearchResult(place),
            )
            .toList();

        // add the new TennisLocations to the final list and output
        finalLocations.addAll(additionalLocations);

        // identify if a court is currently selected
        TennisLocation _selectedLocation = null;
        if (finalLocations.isNotEmpty)
          finalLocations.forEach((f) {
            double distance = calculateDistance(
                f.lat, f.lng, mapCentre.latitude, mapCentre.longitude);
            if (distance < 0.01) _selectedLocation = f;
          });

        return HomePageState(
          markerBitmap: markerBitmap,
          tennisLocationsList: finalLocations,
          excludedLocationsList: exludedLocations,
          selectedTennisLocation: _selectedLocation,
        );
      },
    );
  }
  final String uid;
  final Database database;
  final TennisPlacesRepository placesRepository;
  final MarkerProvider markerProvider;
  BehaviorSubject<LatLng> _mapCentreSubject;
  final LatLng initialPosition;

  Stream<List<TennisLocation>> _tennisLocationsListStream;
  Stream<List<PlacesSearchResult>> _tennisPlaces;
  Stream<BitmapDescriptor> _markerStream;
  Stream<HomePageState> homePageStateStream;

  void updateMapCentre(LatLng newCentre) {
    database.updateQueryCentre(newCentre: newCentre);
    placesRepository.updateCentre(centre: newCentre);
    _mapCentreSubject.add(newCentre);
  }

  Future<void> removeLocation({
    @required TennisLocation tennisLocation,
  }) async {
    if (uid != null && uid.isNotEmpty) {
      tennisLocation = tennisLocation.copyWith(isVisible: false);
      database.setTennisLocation(tennisLocation);
    }
  }

  Future<void> addLocation({
    @required double lat,
    @required double lng,
    @required String name,
  }) async {
    if (uid != null && uid.isNotEmpty) {
      TennisLocation newLocation = TennisLocation(
        lat: lat,
        lng: lng,
        name: name,
        isVisible: true,
      );
      database.addTennisLocation(newLocation);
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void dispose() {
    _mapCentreSubject.close();
  }
}

class HomePageState extends Equatable {
  final BitmapDescriptor markerBitmap;
  final List<TennisLocation> tennisLocationsList;
  final List<TennisLocation> excludedLocationsList;
  final TennisLocation selectedTennisLocation;

  HomePageState({
    @required this.markerBitmap,
    @required this.tennisLocationsList,
    @required this.excludedLocationsList,
    @required this.selectedTennisLocation,
  });

  HomePageState copyWith({
    BitmapDescriptor markerBitmap,
    List<TennisLocation> tennisLocationsList,
    List<TennisLocation> excludedLocationsList,
    TennisLocation selectedLocation,
    bool clearLocation,
  }) {
    return HomePageState(
      markerBitmap: markerBitmap ?? this.markerBitmap,
      tennisLocationsList: tennisLocationsList ?? this.tennisLocationsList,
      excludedLocationsList:
          excludedLocationsList ?? this.excludedLocationsList,
      selectedTennisLocation: (clearLocation == true)
          ? null
          : selectedLocation ?? this.selectedTennisLocation,
    );
  }

  @override
  List<Object> get props => [
        markerBitmap,
        tennisLocationsList,
        excludedLocationsList,
        selectedTennisLocation,
      ];
}
