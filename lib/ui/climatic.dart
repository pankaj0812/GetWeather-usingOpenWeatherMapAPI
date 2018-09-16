import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../util/utils.dart' as util;

class Climatic extends StatefulWidget {
  @override
  _ClimaticState createState() => _ClimaticState();
}

class _ClimaticState extends State<Climatic> {

  String _cityEntered;

  Future _gotToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){
        return new ChangeCity();
      })
    );

    if(results != null && results.containsKey('enter')){
//      print(results['enter'].toString());
    _cityEntered = results['enter'];
    }
  }

  void showStuff() async{
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Climatic'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu,
            color: Colors.white,
            ),
            onPressed: () {_gotToNextScreen(context);},
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',
            height: 1000.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text('${_cityEntered == null ? util.defaultCity: _cityEntered}',
            style: cityStyle(),),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),


          //Container having weather data
          new Container(
            margin: const EdgeInsets.fromLTRB(70.0, 350.0,0.0, 0.0),
            alignment: Alignment.center,
            child: updateTempWidget(_cityEntered),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async{
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.appId}&units=metric';

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city){
    return new FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity: city),
        builder: (BuildContext context, AsyncSnapshot <Map> snapshot){
          //here we get all json data, setup widgets here
          if(snapshot.hasData){
            Map content = snapshot.data;
            return new Container(
//              margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(content['main']['temp'].toString() + " C",
                    style: new TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 49.9,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity: ${content['main']['humidity'].toString()}\n"
                          "Min: ${content['main']['temp_min'].toString()} C\n"
                          "Max: ${content['main']['temp_max'].toString()} C",
                      style: extraData(),

                    ),
                  ),
                  )
                ],
              ),
            );
          } else{
            return new Container();
          }
        });
  }



}


class ChangeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
         new Center(
           child: new Image.asset('images/white_snow.png',
           width: 490.0,
             height: 1200.0,
             fit: BoxFit.fill,
           ),
         ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),

              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      if (_cityFieldController.text.isNotEmpty) {
                        Navigator.pop(context, {
                          'enter': _cityFieldController.text
                        });
                      }
                    },
                    textColor: Colors.white70,
                    color: Colors.redAccent,
                    child: new Text('Get Weather')),
              )
            ],
          )

        ],
      ),
    );
  }
}


TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic
  );
}

TextStyle tempStyle(){
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9
  );

}

TextStyle extraData(){
  return new TextStyle(
      color: Colors.white70,
      fontStyle: FontStyle.normal,
//      fontWeight: FontWeight.500,
      fontSize: 17.0
  );
}
