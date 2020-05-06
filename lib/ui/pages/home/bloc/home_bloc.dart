import 'dart:async';

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
  }) {
    _tennisLocationsListStream = database.tennisLocationsByDistanceStream();
    _tennisPlaces = placesRepository.placesSearchResultStream;
    _markerStream = markerProvider.markerBitmapStream;
    homePageStateStream = Rx.combineLatest3(
      _tennisLocationsListStream,
      _tennisPlaces,
      _markerStream,
      (
        List<TennisLocation> tennisLocations,
        List<PlacesSearchResult> placesSearchResults,
        BitmapDescriptor markerBitmap,
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

        return HomePageState(
          markerBitmap: markerBitmap,
          tennisLocationsList: finalLocations,
          excludedLocationsList: exludedLocations,
        );
      },
    );
  }
  final String uid;
  final Database database;
  final TennisPlacesRepository placesRepository;
  final MarkerProvider markerProvider;

  Stream<List<TennisLocation>> _tennisLocationsListStream;
  Stream<List<PlacesSearchResult>> _tennisPlaces;
  Stream<BitmapDescriptor> _markerStream;
  Stream<HomePageState> homePageStateStream;

  void updateMapCentre(LatLng newCentre) {
    database.updateQueryCentre(newCentre: newCentre);
    placesRepository.updateCentre(centre: newCentre);
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

  void dispose() {}
}

class HomePageState extends Equatable {
  final BitmapDescriptor markerBitmap;
  final List<TennisLocation> tennisLocationsList;
  final List<TennisLocation> excludedLocationsList;

  HomePageState({
    @required this.markerBitmap,
    @required this.tennisLocationsList,
    @required this.excludedLocationsList,
  });

  HomePageState copyWith({
    BitmapDescriptor markerBitmap,
    List<TennisLocation> tennisLocationsList,
    List<TennisLocation> excludedLocationsList,
  }) {
    return HomePageState(
      markerBitmap: markerBitmap ?? this.markerBitmap,
      tennisLocationsList: tennisLocationsList ?? this.tennisLocationsList,
      excludedLocationsList:
          excludedLocationsList ?? this.excludedLocationsList,
    );
  }

  @override
  List<Object> get props => [
        markerBitmap,
        tennisLocationsList,
        excludedLocationsList,
      ];
}
