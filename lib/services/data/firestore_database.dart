import 'dart:async';

import 'package:find_my_tennis/services/data/firestore_service.dart';
import 'package:find_my_tennis/services/data/models/tennis_club.dart';
import 'package:find_my_tennis/services/data/models/tennis_location.dart';
import 'package:find_my_tennis/utlities/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

abstract class Database {
  Future<String> addTennisLocation(TennisLocation tennisLocation, String uid);
  Future<void> setTennisLocation(TennisLocation tennisLocation, String uid,
      {bool merge});
  Future<String> addTennisClub(TennisClub tennisClub, String uid);
  Future<void> setTennisClub(TennisClub tennisClub, String uid, {bool merge});
  Stream<List<TennisLocation>> tennisLocationsListStream();
  Stream<List<TennisLocation>> tennisLocationsByDistanceStream();
  Stream<List<TennisClub>> tennisClubsListStream(
      {TennisLocation tennisLocation});
  void updateQueryCentre({LatLng newCentre});
  Future<void> deleteTennisClub(TennisClub tennisClub);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase();

  final BehaviorSubject<LatLng> _queryCentreSubject = BehaviorSubject.seeded(
    LatLng(51.4183, -0.2206),
  );

  final FirestoreService _service = FirestoreService.instance;
  final Geoflutterfire _geo = Geoflutterfire();
  static const String errorMessage = 'Error - user needs ot be logged in to';
  static const String addAction = 'add a';
  static const String updateAction = 'update a';
  static const String overwriteAction = 'overwrite a';
  static const String tennisClubString = 'Tennis Club';
  static const String tennisLocationString = 'Tennis Location';

  @override
  void updateQueryCentre({@required LatLng newCentre}) {
    _queryCentreSubject.add(newCentre);
  }

  @override
  Future<String> addTennisClub(TennisClub tennisClub, String uid) {
    if (uid == null) {
      throw PlatformException(
        code: 'ADD_CLUB_INVALID_USER',
        message: '$errorMessage $addAction $tennisClubString',
      );
    }
    return _service.addData(
      collectionPath: APIPath.tennisClubs(),
      data: tennisClub.toMap(),
    );
  }

  @override
  Future<String> addTennisLocation(TennisLocation tennisLocation, String uid) {
    if (uid == null) {
      throw PlatformException(
        code: 'ADD_LOCATION_INVALID_USER',
        message: '$errorMessage $addAction $tennisLocationString',
      );
    }
    return _service.addData(
      collectionPath: APIPath.tennisLocations(),
      data: tennisLocation.toMap(),
    );
  }

  @override
  Future<void> setTennisClub(TennisClub tennisClub, String uid, {bool merge}) {
    if (uid == null) {
      String throwAction = merge == true ? updateAction : overwriteAction;
      throw PlatformException(
        code: 'SET_CLUB_INVALID_USER',
        message: '$errorMessage $throwAction $tennisClubString',
      );
    }
    if (tennisClub.id == null) {
      return _service.addData(
        collectionPath: APIPath.tennisClubs(),
        data: tennisClub.toMap(),
      );
    }
    return _service.setData(
      path: APIPath.tennisClub(tennisClub.id),
      data: tennisClub.toMap(),
    );
  }

  @override
  Future<void> setTennisLocation(
    TennisLocation tennisLocation,
    String uid, {
    bool merge = false,
  }) {
    if (uid == null) {
      String throwAction = merge == true ? updateAction : overwriteAction;
      throw PlatformException(
        code: 'SET_LOCATION_INVALID_USER',
        message: '$errorMessage $throwAction $tennisLocationString',
      );
    }
    GeoFirePoint tennisLocationGeo = _geo.point(
      latitude: tennisLocation.lat,
      longitude: tennisLocation.lng,
    );

    Map<String, dynamic> data = tennisLocation.toMap();
    data.putIfAbsent('position', () => tennisLocationGeo.data);

    if (tennisLocation.id == null) {
      return _service.addData(
        collectionPath: APIPath.tennisLocations(),
        data: data,
      );
    }
    return _service.setData(
      path: APIPath.tennisLocation(tennisLocation.id),
      data: data,
      merge: merge,
    );
  }

  @override
  Stream<List<TennisLocation>> tennisLocationsListStream() {
    return _service
        .collectionStream(
          path: APIPath.tennisLocations(),
          builder: (data, documentId) => TennisLocation.fromMap(
            data: data,
            id: documentId,
          ),
        )
        .shareValue();
  }

  @override
  Stream<List<TennisClub>> tennisClubsListStream(
      {TennisLocation tennisLocation}) {
    return _service
        .collectionStream<TennisClub>(
          path: APIPath.tennisClubs(),
          queryBuilder: tennisLocation?.id != null
              ? (query) {
                  print('building tennis club list query');
                  return query.where('locationId',
                      isEqualTo: tennisLocation.id);
                }
              : null,
          builder: (data, documentID) {
            print('building tennis clubs');
            return TennisClub.fromMap(data: data, id: documentID);
          },
        )
        .shareValue();
  }

  @override
  Stream<List<TennisLocation>> tennisLocationsByDistanceStream() {
    if (_queryCentreSubject == null) {
      throw PlatformException(
          code: 'UNKNOWN_QUERY_CENTRE',
          message:
              'queryCentreSubject is null. Please ensure a suitable Behavior Subject containing an object with Lat & Lng attributes is passed to the tennisLocationsByDistanceStream method');
    }
    return _queryCentreSubject.switchMap(
      (LatLng value) {
        print('triggering geoquery');
        return _geo
            .collection(
              collectionRef: _service.collectionReference(
                APIPath.tennisLocations(),
              ),
            )
            .within(
              center: _geo.point(
                  latitude: value.latitude, longitude: value.longitude),
              radius: 8.0,
              field: 'position',
              strictMode: true,
            )
            .map<List<TennisLocation>>(
              (event) => event
                  .map<TennisLocation>(
                    (e) => TennisLocation.fromMap(
                      data: e.data,
                      id: e.documentID,
                    ),
                  )
                  .toList(),
            )
            .shareValue();
      },
    );
  }

  @override
  Future<void> deleteTennisClub(TennisClub tennisClub) async {
    _service.deleteData(
      path: APIPath.tennisClub(tennisClub.id),
    );
  }
}
