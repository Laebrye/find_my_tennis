import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewForm extends StatefulWidget {
  final String text;
  final Future<void> Function() onSubmit;

  const AddNewForm({
    Key key,
    @required this.text,
    @required this.onSubmit,
  }) : super(key: key);

  @override
  _AddNewFormState createState() => _AddNewFormState();
}

class _AddNewFormState extends State<AddNewForm> {
  final TextEditingController _controller = TextEditingController();
  bool _submitInProgress = false;

  Future<bool> show(BuildContext context) {
    return showModalBottomSheet(
        context: context, builder: (context) => this.widget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            widget.text,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextField(
            enabled: !_submitInProgress,
            controller: _controller,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter a name',
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: _submitInProgress
                    ? null
                    : () {
                        Navigator.of(context).pop(false);
                      },
              ),
              const SizedBox(
                width: 32.0,
              ),
              Expanded(
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: _submitInProgress
                      ? null
                      : () async {
                          setState(() {
                            _submitInProgress = true;
                          });
                          await widget.onSubmit();
                          setState(() {
                            _submitInProgress = false;
                          });
                          Navigator.of(context).pop(true);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 36,
                        height: 36,
                        child: _submitInProgress
                            ? CircularProgressIndicator()
                            : Container(),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Container(
                        width: 36,
                        height: 36,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
