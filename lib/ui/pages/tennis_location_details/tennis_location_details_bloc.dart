import 'package:find_my_tennis/services/auth.dart';
import 'package:find_my_tennis/services/data/firestore_database.dart';
import 'package:rxdart/rxdart.dart';

class TennisLocationDetailsBloc {
  TennisLocationDetailsBloc({
    this.database,
    this.auth,
  }) {
    _isUserAuthenticatedStream =
        auth.onAuthStateChanged.map((user) => user != null).shareValue();
  }

  final Database database;
  final AuthBase auth;

  Stream<bool> _isUserAuthenticatedStream;
  Stream<bool> get isUserAuthenticatedStream => _isUserAuthenticatedStream;
}
