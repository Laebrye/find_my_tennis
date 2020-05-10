import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewForm extends StatefulWidget {
  final String text;

  const AddNewForm({Key key, this.text}) : super(key: key);

  @override
  _AddNewFormState createState() => _AddNewFormState();
}

class _AddNewFormState extends State<AddNewForm> {
  final TextEditingController _controller = TextEditingController();

  Future<bool> show(BuildContext context) {
    return showModalBottomSheet(
        context: context, builder: (context) => this.widget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // TODO: format this
          Text(widget.text),
          const SizedBox(
            height: 8.0,
          ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter a name',
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          RaisedButton(
            onPressed: () {
              //TODO: implement this callback
            },
            child: Text('SUBMIT'),
          ),
        ],
      ),
    );
  }
}
