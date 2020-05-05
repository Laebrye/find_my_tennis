import 'dart:async';

import 'package:find_my_tennis/services/data/models/tennis_club.dart';
import 'package:find_my_tennis/services/data/models/tennis_location.dart';

abstract class Database {
  Future<String> addTennisLocation(TennisLocation tennisLocation);
  Future<void> setTennisLocation(TennisLocation tennisLocation, {bool merge});
  Future<String> addTennisClub(TennisClub tennisClub);
  Future<void> setTennisClub(TennisClub tennisClub, {bool merge});
  Stream<List<TennisLocation>> tennisLocationsListStream();
  Stream<List<TennisClub>> tennisClubsListStream(
      {TennisLocation tennisLocation});
}

class FirestoreDatabase implements Database {
  @override
  Future<String> addTennisClub(TennisClub tennisClub) {
    // TODO: implement addTennisClub
    throw UnimplementedError();
  }

  @override
  Future<String> addTennisLocation(TennisLocation tennisLocation) {
    // TODO: implement addTennisLocation
    throw UnimplementedError();
  }

  @override
  Future<void> setTennisClub(TennisClub tennisClub, {bool merge}) {
    // TODO: implement setTennisClub
    throw UnimplementedError();
  }

  @override
  Future<void> setTennisLocation(TennisLocation tennisLocation, {bool merge}) {
    // TODO: implement setTennisLocation
    throw UnimplementedError();
  }

  @override
  Stream<List<TennisLocation>> tennisLocationsListStream() {
    // TODO: implement tennisLocationsListStream
    throw UnimplementedError();
  }

  @override
  Stream<List<TennisClub>> tennisClubsListStream(
      {TennisLocation tennisLocation}) {
    // TODO: implement tennisClubsListStream
    throw UnimplementedError();
  }
}
