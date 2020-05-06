import 'dart:async';

import 'package:find_my_tennis/services/data/firestore_service.dart';
import 'package:find_my_tennis/services/data/models/tennis_club.dart';
import 'package:find_my_tennis/services/data/models/tennis_location.dart';
import 'package:find_my_tennis/utlities/api_path.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

abstract class Database {
  Future<String> addTennisLocation(TennisLocation tennisLocation);
  Future<void> setTennisLocation(TennisLocation tennisLocation, {bool merge});
  Future<String> addTennisClub(TennisClub tennisClub);
  Future<void> setTennisClub(TennisClub tennisClub, {bool merge});
  Stream<List<TennisLocation>> tennisLocationsListStream();
  Stream<List<TennisLocation>> tennisLocationsByDistanceStream();
  Stream<List<TennisClub>> tennisClubsListStream(
      {TennisLocation tennisLocation});
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({this.uid});
  final String uid;

  final FirestoreService _service = FirestoreService.instance;
  final Geoflutterfire _geo = Geoflutterfire();
  static const String errorMessage = 'Error - user needs ot be logged in to';
  static const String addAction = 'add a';
  static const String updateAction = 'update a';
  static const String overwriteAction = 'overwrite a';
  static const String tennisClubString = 'Tennis Club';
  static const String tennisLocationString = 'Tennis Location';

  @override
  Future<String> addTennisClub(TennisClub tennisClub) {
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
  Future<String> addTennisLocation(TennisLocation tennisLocation) {
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
  Future<void> setTennisClub(TennisClub tennisClub, {bool merge}) {
    if (uid == null) {
      String throwAction = merge == true ? updateAction : overwriteAction;
      throw PlatformException(
        code: 'SET_CLUB_INVALID_USER',
        message: '$errorMessage $throwAction $tennisClubString',
      );
    }
    return _service.setData(
      path: APIPath.tennisClub(tennisClub.id),
      data: tennisClub.toMap(),
    );
  }

  @override
  Future<void> setTennisLocation(
    TennisLocation tennisLocation, {
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

    return _service.setData(
      path: APIPath.tennisLocation(tennisLocation.id),
      data: data,
      merge: merge,
    );
  }

  @override
  Stream<List<TennisLocation>> tennisLocationsListStream() {
    return _service.collectionStream(
      path: APIPath.tennisLocations(),
      builder: (data, documentId) => TennisLocation.fromMap(
        data: data,
        id: documentId,
      ),
    );
  }

  @override
  Stream<List<TennisClub>> tennisClubsListStream(
      {TennisLocation tennisLocation}) {
    // TODO: implement tennisClubsListStream
    throw UnimplementedError();
  }

  @override
  Stream<List<TennisLocation>> tennisLocationsByDistanceStream() {
    // TODO: implement tennisLocationsByDistanceStream
    throw UnimplementedError();
  }
}
