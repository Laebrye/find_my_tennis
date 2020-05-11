import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class TennisClub extends Equatable {
  static const nameKey = 'name';
  static const locationIdKey = 'locationId';

  final String id;
  final String name;
  final String locationId;

  TennisClub({
    this.id,
    @required this.name,
    @required this.locationId,
  });

  factory TennisClub.fromMap({
    @required Map<String, dynamic> data,
    @required String id,
  }) {
    return TennisClub(
      id: id,
      name: data[nameKey] as String,
      locationId: data[locationIdKey] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      nameKey: name,
      locationIdKey: locationId,
    };
  }

  @override
  String toString() {
    return 'TennisClub{id: $id, name: $name, locationId: $locationId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TennisClub &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          locationId == other.locationId;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ locationId.hashCode;

  @override
  List<Object> get props => [id, name, locationId];
}
