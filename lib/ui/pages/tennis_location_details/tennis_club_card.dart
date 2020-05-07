import 'package:find_my_tennis/services/data/models/tennis_club.dart';
import 'package:flutter/material.dart';

class TennisLocationCard extends StatelessWidget {
  final TennisClub tennisClub;

  const TennisLocationCard({
    Key key,
    @required this.tennisClub,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            side: BorderSide.none, borderRadius: BorderRadius.circular(25.0)),
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
                    tennisClub.name,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // TODO: implement a platform alert dialog to show when pressed for users to remove a club
                },
                iconSize: 36.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
