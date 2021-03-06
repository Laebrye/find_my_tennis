import 'package:find_my_tennis/services/auth.dart';
import 'package:find_my_tennis/services/data/firestore_database.dart';
import 'package:find_my_tennis/services/data/models/tennis_club.dart';
import 'package:find_my_tennis/services/data/models/tennis_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class TennisLocationDetailsBloc {
  TennisLocationDetailsBloc({
    @required this.database,
    @required this.auth,
    @required this.tennisLocation,
  }) {
    _isUserAuthenticatedStream =
        auth.onAuthStateChanged.map((user) => user != null);
    _isUserAuthenticatedStream.listen((event) {
      print('user auth stream emitted');
    });
    _tennisClubListStream =
        database.tennisClubsListStream(tennisLocation: tennisLocation);
    _tennisClubListStream.listen((event) {
      print('clubs stream emitted');
    });
    _tennisLocationDetailsModelStream = Rx.combineLatest2(
      _isUserAuthenticatedStream,
      _tennisClubListStream,
      (
        bool isUserAuthenticated,
        List<TennisClub> clubsList,
      ) =>
          TennisLocationDetailsModel(
        isUserAuthenticated: isUserAuthenticated,
        tennisClubList: clubsList,
        tennisLocation: tennisLocation,
      ),
    );
  }

  final Database database;
  final AuthBase auth;
  final TennisLocation tennisLocation;

  Stream<bool> _isUserAuthenticatedStream;
  Stream<List<TennisClub>> _tennisClubListStream;

  Stream<TennisLocationDetailsModel> _tennisLocationDetailsModelStream;
  Stream<TennisLocationDetailsModel> get tennisLocationDetailsModelStream =>
      _tennisLocationDetailsModelStream;

  Future<void> addTennisCLub(String clubName) async {
    String locationId;
    final userId = (await auth.currentUser())?.uid;
    try {
      if (tennisLocation?.id == null) {
        locationId = await database.addTennisLocation(
          tennisLocation,
          userId,
        );
      } else {
        locationId = tennisLocation.id;
      }

      await database.addTennisClub(
        TennisClub(
          name: clubName,
          locationId: locationId,
        ),
        userId,
      );
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> removeTennisClub(TennisClub tennisClub) async {
    try {
      database.deleteTennisClub(tennisClub);
    } on PlatformException catch (e) {
      print(e);
    }
  }
}

class TennisLocationDetailsModel {
  final bool isUserAuthenticated;
  final List<TennisClub> tennisClubList;
  final TennisLocation tennisLocation;
  final bool isLoading;

  TennisLocationDetailsModel({
    this.isUserAuthenticated,
    this.tennisClubList,
    this.tennisLocation,
    this.isLoading = false,
  });
}
