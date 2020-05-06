import 'package:find_my_tennis/services/data/models/tennis_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TennisLocationCard extends StatelessWidget {
  final Future<void> Function(LatLng) onTapCallBack;
  final TennisLocation tennisLocation;
  final bool isSelected;

  const TennisLocationCard({
    Key key,
    @required this.onTapCallBack,
    @required this.tennisLocation,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: GestureDetector(
        onTap: () => onTapCallBack(
          LatLng(
            tennisLocation.lat,
            tennisLocation.lng,
          ),
        ),
        child: Card(
          elevation: isSelected ? 6.0 : 3.0,
          shape: RoundedRectangleBorder(
              side: isSelected
                  ? BorderSide(color: Colors.blue.shade900, width: 3.0)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(25.0)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            height: 80.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment(-1, 0),
                    child: Text(
                      tennisLocation.name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Colors.blue.shade900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
