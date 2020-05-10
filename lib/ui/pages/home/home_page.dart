import 'dart:async';
import 'dart:io';

import 'package:find_my_tennis/services/auth.dart';
import 'package:find_my_tennis/services/data/firestore_database.dart';
import 'package:find_my_tennis/services/data/models/tennis_location.dart';
import 'package:find_my_tennis/services/data/tennis_places_repository.dart';
import 'package:find_my_tennis/services/marker_provider.dart';
import 'package:find_my_tennis/ui/pages/home/home_bloc.dart';
import 'package:find_my_tennis/ui/pages/home/tennis_location_card.dart';
import 'package:find_my_tennis/ui/pages/tennis_location_details/tennis_location_details_page.dart';
import 'package:find_my_tennis/utlities/app_secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final placesRepository =
        Provider.of<TennisPlacesRepository>(context, listen: false);
    final markerProvider = Provider.of<MarkerProvider>(context, listen: false);
    final auth = Provider.of<AuthBase>(context);
    return Provider<HomeBloc>(
      create: (_) => HomeBloc(
        database: database,
        placesRepository: placesRepository,
        markerProvider: markerProvider,
        auth: auth,
      ),
      child: HomePage(),
    );
  }

  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng _mapCentre;
  GoogleMapController _mapController;
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = [];
  List<Circle> _circles = [];
  GoogleMapsPlaces _locationPlaces = GoogleMapsPlaces(
    apiKey: AppSecrets.mapsWebApiKey,
  );
  ScrollController _scrollController = ScrollController();

  Future<void> _search() async {
    try {
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          apiKey: AppSecrets.mapsWebApiKey,
          mode: Mode.overlay,
          language: "en",
          location: _mapCentre == null
              ? null
              : Location(_mapCentre.latitude, _mapCentre.longitude),
          radius: _mapCentre == null ? null : 10000);

      PlacesDetailsResponse place =
          await _locationPlaces.getDetailsByPlaceId(p.placeId);

      LatLng centre = LatLng(place.result.geometry.location.lat,
          place.result.geometry.location.lng);
      print('changing centre on autocomplete');
      await _mapController.animateCamera(CameraUpdate.newLatLng(centre));
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> _animateToLocation(LatLng newLatLng) async {
    await _mapController.animateCamera(
      CameraUpdate.newLatLng(
        newLatLng,
      ),
    );
    await _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 2000),
      curve: Curves.ease,
    );
  }

  Future<void> _navigateToLocationDetails({
    @required BuildContext context,
    @required TennisLocation tennisLocation,
  }) async {
    await Navigator.of(context).pushNamed(
      TennisLocationDetailsPage.id,
      arguments: tennisLocation,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeBloc>(context);
    return Scaffold(
      body: StreamBuilder<HomePageState>(
        stream: bloc.homePageStateStream,
        initialData: HomePageState(isLoading: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            if (snapshot.data.isLoading == true) {
              return _buildLoading();
            }
            return _buildContent(
                context: context, bloc: bloc, homePageState: snapshot.data);
          }
          if (!snapshot.hasData) {
            return _buildEmpty();
          }
          if (snapshot.hasError) {
            return _buildError();
          }
          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildContent({
    BuildContext context,
    HomeBloc bloc,
    HomePageState homePageState,
  }) {
    final tennisLocationsList = homePageState.tennisLocationsList;
    final width = MediaQuery.of(context).size.width;

    _buildSelectedCircle(homePageState, context);

    _markers = _buildMarkers(tennisLocationsList, homePageState);

    return Column(
      children: <Widget>[
        const SizedBox(
          height: 24.0,
        ),
        _buildMap(width, bloc),
        Expanded(
          child: ListView.builder(
            itemCount: tennisLocationsList.length,
            itemBuilder: (BuildContext context, int index) {
              bool selected = (tennisLocationsList[index].id != null &&
                      tennisLocationsList[index].id ==
                          homePageState.selectedTennisLocation?.id) ||
                  (tennisLocationsList[index].placesId != null &&
                      tennisLocationsList[index].placesId ==
                          homePageState.selectedTennisLocation?.placesId);
              return TennisLocationCard(
                onLocationTapCallBack: _animateToLocation,
                tennisLocation: tennisLocationsList[index],
                isSelected: selected,
                onTapCallback: () => _navigateToLocationDetails(
                  context: context,
                  tennisLocation: tennisLocationsList[index],
                ),
              );
            },
            shrinkWrap: true,
            controller: _scrollController,
          ),
        ),
      ],
    );
  }

  void _buildSelectedCircle(HomePageState homePageState, BuildContext context) {
    _circles.clear();
    final selectedLocation = homePageState.selectedTennisLocation;
    if (selectedLocation != null) {
      _circles.add(
        Circle(
            circleId:
                CircleId(selectedLocation.id ?? selectedLocation.placesId),
            center: LatLng(selectedLocation.lat, selectedLocation.lng),
            radius: 20,
            fillColor: Theme.of(context).primaryColor,
            strokeColor: Theme.of(context).primaryColor),
      );
    }
  }

  List<Marker> _buildMarkers(
      List<TennisLocation> tennisLocationsList, HomePageState homePageState) {
    return tennisLocationsList.map((f) {
      return Marker(
        markerId: MarkerId(f.id ?? f.placesId),
//              infoWindow: InfoWindow(title: "${f.name}"),
        icon: homePageState.markerBitmap,
        position: LatLng(f.lat, f.lng),
        draggable: false,
        onTap: () => _animateToLocation(
          LatLng(f.lat, f.lng),
        ),
      );
    }).toList();
  }

  Stack _buildMap(double width, HomeBloc bloc) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(0, 0),
          child: Container(
            height: width,
            child: GoogleMap(
              onCameraMove: (CameraPosition position) {
                _mapCentre = position.target;
              },
              onCameraIdle: () async {
                bloc.updateMapCentre(_mapCentre);
              },
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: bloc.initialPosition,
                zoom: 13.0,
              ),
              circles: _circles != null ? Set.of(_circles) : null,
              markers: _markers != null ? Set.of(_markers) : null,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(13.0, 13.0),
            ),
          ),
        ),
        Align(
          alignment: Alignment(Platform.isIOS ? 1 : -1, -1),
          child: Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              right: Platform.isIOS ? 16.0 : 0,
              left: Platform.isIOS ? 0 : 16.0,
            ),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black87,
                size: 36.0,
              ),
              onPressed: _search,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Text(
          'oops! Something went wrong',
          style: TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
