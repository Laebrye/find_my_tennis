import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_webservice/places.dart';

class TennisLocation extends Equatable {
  static const latKey = 'lat';
  static const lngKey = 'lng';
  static const nameKey = 'name';
  static const numberOfClubsKey = 'numberOfClubs';
  static const isVisibleKey = 'isVisible';
  static const updatedByUserKey = 'updatedByUser';
  static const placesIdKey = 'placesId';

  final String id;
  final double lat;
  final double lng;
  final String name;
  final int numberOfClubs;
  final bool isVisible;
  final String updatedByUser;
  final String placesId;

  TennisLocation({
    this.id,
    @required this.lat,
    @required this.lng,
    @required this.name,
    this.numberOfClubs,
    this.isVisible,
    this.updatedByUser,
    this.placesId,
  });

  factory TennisLocation.fromMap({
    @required Map<String, dynamic> data,
    @required String id,
  }) {
    return TennisLocation(
      id: id,
      lat: data[latKey] as double,
      lng: data[lngKey] as double,
      name: data[nameKey] as String,
      numberOfClubs: data[numberOfClubsKey] as int,
      isVisible: data[isVisibleKey] as bool,
      updatedByUser: data[updatedByUserKey] as String,
      placesId: data[placesIdKey] as String,
    );
  }

  factory TennisLocation.fromPlacesSearchResult(PlacesSearchResult place) {
    return TennisLocation(
      lat: place.geometry.location.lat,
      lng: place.geometry.location.lng,
      name: place.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      latKey: lat,
      lngKey: lng,
      nameKey: name,
      if (numberOfClubs != null) numberOfClubsKey: numberOfClubs,
      if (isVisible != null) isVisibleKey: isVisible,
      if (updatedByUser != null) updatedByUserKey: updatedByUser,
      if (placesId != null) placesIdKey: placesId,
    };
  }

  @override
  String toString() {
    return 'TennisLocation{id: $id,'
        ' lat: $lat,'
        ' lng: $lng,'
        ' name: $name,'
        ' numberOfClubs: $numberOfClubs,'
        ' isVisible: $isVisible,'
        ' updatedByUser: $updatedByUser,'
        ' placesId: $placesId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TennisLocation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          lat == other.lat &&
          lng == other.lng &&
          name == other.name &&
          numberOfClubs == other.numberOfClubs &&
          isVisible == other.isVisible &&
          updatedByUser == other.updatedByUser &&
          placesId == other.placesId;

  @override
  int get hashCode =>
      id.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      name.hashCode ^
      numberOfClubs.hashCode ^
      isVisible.hashCode ^
      updatedByUser.hashCode ^
      placesId.hashCode;

  @override
  List<Object> get props => [
        id,
        lat,
        lng,
        name,
        numberOfClubs,
        isVisible,
        updatedByUser,
        placesId,
      ];
}
