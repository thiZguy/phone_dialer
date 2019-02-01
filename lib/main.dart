import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  TextEditingController _c ;
  List<Map<String, dynamic>> buttonList = [
    {'value':'1'},
    {'value':'2'},
    {'value':'3'},
    {'value':'4'},
    {'value':'5'},
    {'value':'6'},
    {'value':'7'},
    {'value':'8'},
    {'value':'9'},
    {'value':'+'},
    {'value':'0'},
    {'value':'<'},
  ];

  @override
  void initState() {
      _c = new TextEditingController();
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      home: PhoneCallerWidget(buttonList, _c, updateText, makeCall)
    );
  }

  void updateText(val) {
    if(val=='<' && _c.text.length > 0 ) {
      deleteText();
    } else if(val!='<' && _c.text.length < 12) {
      setState((){ _c.text += val;});
    }
  }

  void deleteText() {
    setState((){ _c.text = _c.text.substring(0, _c.text.length-1);});
  }

  void makeCall() async {
    if (await canLaunch('tel: ' + _c.text)) {
      await launch('tel: ' + _c.text);
    } else {
      throw 'Could not launch '+('tel: ' + _c.text);
    }
  }

}

class PhoneCallerWidget extends StatelessWidget {
  
  final List<Map<String, dynamic>> buttonList;
  final TextEditingController controller;
  final Function updateText;
  final Function makeCall;
  
  PhoneCallerWidget(this.buttonList, this.controller, this.updateText, this.makeCall);


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 320) / 3;
    final double itemWidth = size.width / 3;

    return Scaffold(
        appBar: AppBar(
          title: Text('Phone Dialer'),
        ),
        body: Container(
          color: Colors.blueGrey[900],
          child: Column(
          children: <Widget>[
            GridView.count(
            crossAxisCount: 3,
            padding: EdgeInsets.only(top: 20.0),
            childAspectRatio: (itemWidth / itemHeight),
            controller: ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: buttonList.map((Map value) {  
              return InkWell(
                onTap: () {
                  updateText(value['value']);
                },
                child:
                  Container(
                    decoration: new BoxDecoration(
                    color: Colors.blueGrey[700],
                    borderRadius: new BorderRadius.all(Radius.circular(100.0)),
                    ),
                  margin: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      value['value'],
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              );
            }).toList(),
          ),
          Container(
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: controller,
              enabled: false,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.w300,
                decorationColor: Colors.redAccent,
              ),
              maxLength: 12,
            ),
          ),
          Container(
            color: Colors.green[400],
            child: FlatButton.icon(
              highlightColor: Colors.greenAccent,
              onPressed: () => makeCall(),
              icon: Icon(Icons.call, color: Colors.greenAccent),
              label: Text('Call',style: TextStyle(color: Colors.white),)),
          )
          ],
        ),
        )
      );
  }

}