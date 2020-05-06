import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  final GlobalKey<NavigatorState> navigatorKey;

  PermissionsService({this.navigatorKey});

  Future<bool> _requestPermission(Permission permission) async {
    PermissionStatus result = await permission.request();
    return (result == PermissionStatus.granted);
  }

  Future<bool> requestContactsPermission() async {
    bool granted = await _requestPermission(Permission.contacts);
    if (!granted) _onPermissionDenied(Permission.contacts, true);
    return granted;
  }

  Future<bool> requestLocationPermission() async {
    bool granted = await _requestPermission(Permission.locationWhenInUse);
    if (!granted) _onPermissionDenied(Permission.locationWhenInUse, false);
    return granted;
  }

  Future<bool> _hasPermission(Permission permission) async {
    PermissionStatus result = await permission.status;
    return (result == PermissionStatus.granted);
  }

  Future<bool> hasContactsPermission() async {
    bool granted = await _hasPermission(Permission.contacts);
    if (!granted) _onPermissionDenied(Permission.contacts, true);
    return granted;
  }

  Future<bool> hasLocationPermission() async {
    bool granted = await _hasPermission(Permission.locationWhenInUse);
    if (!granted) _onPermissionDenied(Permission.locationWhenInUse, false);
    return granted;
  }

  void _onPermissionDenied(
    Permission permission,
    bool isRequired,
  ) {
    // TODO: redefine how denied permissions are handled
  }
}
