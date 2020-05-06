import 'package:find_my_tennis/services/data/firestore_database.dart';
import 'package:find_my_tennis/services/data/tennis_places_repository.dart';
import 'package:find_my_tennis/ui/pages/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final placesRepository =
        Provider.of<TennisPlacesRepository>(context, listen: false);
    return Provider<HomeBloc>(
      create: (_) => HomeBloc(
        database: database,
        placesRepository: placesRepository,
      ),
      child: HomePage(),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Container(),
    );
  }
}
