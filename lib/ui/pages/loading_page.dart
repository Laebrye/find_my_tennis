import 'package:find_my_tennis/services/location_service.dart';
import 'package:find_my_tennis/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  static const String id = 'loading_page';

  @override
  Widget build(BuildContext context) {
    final locationService =
        Provider.of<LocationService>(context, listen: false);
    return Scaffold(
      body: FutureBuilder<Object>(
          future: locationService.getUserLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Navigator.of(context)
                  .pushNamed(HomePage.id, arguments: snapshot.data);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
