import 'package:find_my_tennis/services/auth.dart';
import 'package:find_my_tennis/services/data/firestore_database.dart';
import 'package:find_my_tennis/ui/pages/tennis_location_details/tennis_location_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TennisLocationDetailsPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context);
    return Provider<TennisLocationDetailsBloc>(
      create: (_) => TennisLocationDetailsBloc(
        database: database,
        auth: auth,
      ),
      child: TennisLocationDetailsPage(),
    );
  }

  static const String id = 'tennis_location_details';

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
