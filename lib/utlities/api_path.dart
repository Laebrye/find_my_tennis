class APIPath {
  static String tennisLocations() => 'tennisLocations';
  static String tennisLocation(String id) => '${tennisLocations()}/$id';
  static String tennisClubs() => 'tennisClubs';
  static String tennisClub(String id) => '${tennisClubs()}/$id';
}
