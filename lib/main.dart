import 'package:find_my_tennis/services/auth.dart';
import 'package:find_my_tennis/services/data/firestore_database.dart';
import 'package:find_my_tennis/services/data/models/tennis_location.dart';
import 'package:find_my_tennis/services/data/tennis_places_repository.dart';
import 'package:find_my_tennis/services/location_service.dart';
import 'package:find_my_tennis/services/marker_provider.dart';
import 'package:find_my_tennis/services/permissions_service.dart';
import 'package:find_my_tennis/ui/pages/home/home_page.dart';
import 'package:find_my_tennis/ui/pages/loading_page.dart';
import 'package:find_my_tennis/ui/pages/sign_in/sign_in_page.dart';
import 'package:find_my_tennis/ui/pages/tennis_location_details/tennis_location_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(
          create: (_) => Auth(),
        ),
        Provider<PermissionsService>(
          create: (context) => PermissionsService(),
        ),
        ProxyProvider<PermissionsService, LocationService>(
          create: (context) => LocationService(),
          update: (context, permissionsService, previous) {
            return (previous ?? LocationService())
              ..permissionsService = permissionsService;
          },
        ),
        Provider<MarkerProvider>(
          create: (context) => MarkerProvider.instance(context),
          lazy: false,
        ),
        Provider<Database>(
          create: (_) => FirestoreDatabase(),
        ),
        Provider<TennisPlacesRepository>(
          create: (BuildContext context) {
            return TennisPlacesRepository();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Find My Tennis',
        routes: {
          LoadingPage.id: (context) => LoadingPage(),
          HomePage.id: (context) => HomePage.create(context),
          SignInPage.id: (context) => SignInPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == TennisLocationDetailsPage.id) {
            // Cast the arguments to the correct type: ScreenArguments.
            final TennisLocation args = settings.arguments as TennisLocation;

            // Then, extract the required data from the arguments and
            // pass the data to the correct screen.
            return MaterialPageRoute<dynamic>(
              builder: (context) {
                return TennisLocationDetailsPage.create(
                  context,
                  tennisLocation: args,
                );
              },
            );
          }
          return null;
        },
        initialRoute: HomePage.id,
      ),
    );
  }
}
