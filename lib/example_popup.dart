import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

String status = 'Available';

class state extends StatefulWidget {
  @override
  _stateState createState() => _stateState();
}

class _stateState extends State<state> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ExamplePopup extends StatefulWidget {
  final Marker marker;

  ExamplePopup(this.marker, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExamplePopupState(this.marker);
}

class _ExamplePopupState extends State<ExamplePopup> {
  final Marker _marker;

  _ExamplePopupState(this._marker);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
            ),
            _cardDescription(context),
          ],
        ),
      ),
    );
  }
}

Widget _cardDescription(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
        constraints: BoxConstraints(minWidth: 200, maxWidth: 200),
        height: 120,
        child: Column(
        //  crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              "Status: $status",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 16, color: Colors.black)
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(child: Text ('Reserve', textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 16, color: Colors.white,), ),
                color: Color(0xffFF433FA8),
                height: 40,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                onPressed: () {
                  _BottomPopup(context);
                  print('button got pressed');
                  status = "You\'\ ve already reserved a place!";
                 }),
          ],
        )),
  );
}

void _BottomPopup(context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Text("Status: You\'\ ve successfully reserved a place!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 20, color: Colors.black)),
              SizedBox(
                height: 30,
              ),
              Icon(
                Icons.check,
                size: 120,
                color: Colors.green,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Details: Charging truck arrives in 9pm!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 20, color: Colors.black)
              ),
              // },
              const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, spreadRadius: 5),
          ],
        ),
        height: 500,
      );
    },
  );
}
