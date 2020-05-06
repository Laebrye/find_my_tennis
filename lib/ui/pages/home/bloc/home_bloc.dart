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
    @required this.database,
    @required this.placesRepository,
    @required this.markerProvider,
  }) {
    _tennisLocationsListStream = database.tennisLocationsByDistanceStream();
    _tennisPlaces = placesRepository.placesSearchResultStream;
    _markerStream = markerProvider.markerBitmapStream;
  }
  final Database database;
  final TennisPlacesRepository placesRepository;
  final MarkerProvider markerProvider;

  Stream<List<TennisLocation>> _tennisLocationsListStream;
  Stream<List<PlacesSearchResult>> _tennisPlaces;
  Stream<BitmapDescriptor> _markerStream;

  void updateMapCentre(LatLng newCentre) async {
    database.updateQueryCentre(newCentre: newCentre);
    placesRepository.updateCentre(centre: newCentre);
  }

  void dispose() {}
}

class HomePageState extends Equatable {
  final bool isLoading;
  final bool isMarkerBitmapCreated;
  final List<TennisLocation> tennisLocationsList;

  HomePageState({
    @required this.isLoading,
    @required this.isMarkerBitmapCreated,
    @required this.tennisLocationsList,
  });

  HomePageState copyWith({
    bool isLoading,
    bool isMarkerBitmapCreated,
    List<TennisLocation> tennisLocationsList,
  }) {
    return HomePageState(
      isLoading: isLoading ?? this.isLoading,
      isMarkerBitmapCreated:
          isMarkerBitmapCreated ?? this.isMarkerBitmapCreated,
      tennisLocationsList: tennisLocationsList ?? this.tennisLocationsList,
    );
  }

  @override
  List<Object> get props => [
        isLoading,
        isMarkerBitmapCreated,
        tennisLocationsList,
      ];
}
