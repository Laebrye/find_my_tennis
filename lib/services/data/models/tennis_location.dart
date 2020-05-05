class TennisLocation {
  final double lat;
  final double lng;
  final String name;
  final double numberOfClubs;

  TennisLocation(this.lat, this.lng, this.name, this.numberOfClubs);

  @override
  String toString() {
    return 'TennisLocation{lat: $lat, lng: $lng, name: $name, numberOfClubs: $numberOfClubs}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TennisLocation &&
          runtimeType == other.runtimeType &&
          lat == other.lat &&
          lng == other.lng &&
          name == other.name &&
          numberOfClubs == other.numberOfClubs;

  @override
  int get hashCode =>
      lat.hashCode ^ lng.hashCode ^ name.hashCode ^ numberOfClubs.hashCode;
}
