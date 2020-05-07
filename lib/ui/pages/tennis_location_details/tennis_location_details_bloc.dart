import 'package:find_my_tennis/services/auth.dart';
import 'package:find_my_tennis/services/data/firestore_database.dart';

class TennisLocationDetailsBloc {
  TennisLocationDetailsBloc({
    this.database,
    this.auth,
  });

  final Database database;
  final AuthBase auth;
}
