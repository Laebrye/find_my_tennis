import 'package:find_my_tennis/services/data/models/tennis_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TennisLocationCard extends StatelessWidget {
  final Future<void> Function(LatLng) onLocationTapCallBack;
  final VoidCallback onTapCallback;
  final TennisLocation tennisLocation;
  final bool isSelected;

  const TennisLocationCard({
    Key key,
    @required this.onLocationTapCallBack,
    @required this.onTapCallback,
    @required this.tennisLocation,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: GestureDetector(
        onTap: () => onTapCallback(),
        child: Card(
          elevation: isSelected ? 6.0 : 3.0,
          shape: RoundedRectangleBorder(
              side: isSelected
                  ? BorderSide(
                      color: Theme.of(context).primaryColorDark, width: 3.0)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(25.0)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            height: 80.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                          color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      tennisLocation.numberOfClubs?.toString() ?? '0',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text('clubs'),
                  ],
                ),
                const SizedBox(
                  width: 6.0,
                ),
                IconButton(
                  icon: Icon(
                    Icons.my_location,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () => onLocationTapCallBack(
                    LatLng(
                      tennisLocation.lat,
                      tennisLocation.lng,
                    ),
                  ),
                  iconSize: 36.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
