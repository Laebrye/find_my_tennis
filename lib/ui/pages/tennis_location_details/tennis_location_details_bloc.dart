import 'package:find_my_tennis/services/auth.dart';
import 'package:find_my_tennis/services/data/firestore_database.dart';
import 'package:find_my_tennis/services/data/models/tennis_club.dart';
import 'package:find_my_tennis/services/data/models/tennis_location.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class TennisLocationDetailsBloc {
  TennisLocationDetailsBloc({
    @required this.database,
    @required this.auth,
    @required this.tennisLocation,
  }) {
    _isUserAuthenticatedStream =
        auth.onAuthStateChanged.map((user) => user != null);
    _tennisClubListStream =
        database.tennisClubsListStream(tennisLocation: tennisLocation);
    Rx.combineLatest2(
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
