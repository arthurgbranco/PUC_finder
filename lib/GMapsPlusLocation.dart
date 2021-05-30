import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  Location location = Location();
  


  static final CameraPosition _unidadePraca = CameraPosition(
    target: LatLng(-43.02528538509029, 147.8511571119575),
    zoom: 14.4746,
  );

   @override
   void initState() {
     location.changeSettings(accuracy: LocationAccuracy.low, interval: 10000);
     super.initState();
     location.onLocationChanged.listen((value) {
       print("teste2");
       print(value.latitude);
       sendUserLocation(value.latitude, value.longitude).then((value) => {
        if(value != '' && value != 'false') {
         showAlertDialog(context, value)
       }
       else {
         print(value)
       }
       });
     });
   }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _unidadePraca,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getLocation,
        label: Text('To user location!'),
        icon: Icon(Icons.person),
      ),
    );
  }

  Future<void> _getLocation() async {
    print("Entrou");
    CameraPosition currentLocation;
    LocationData currentLatLog;
    final GoogleMapController controller = await _controller.future;
    try {
       currentLatLog = await location.getLocation();
       double? latitude = currentLatLog.latitude;
       double? longitude = currentLatLog.longitude;
       currentLocation = new CameraPosition(target: LatLng(latitude!, longitude!), tilt: 59.440717697143555,
       zoom: 19.151926040649414);
      
       controller.animateCamera(CameraUpdate.newCameraPosition(currentLocation));
    } catch (e) {
      print(e);
    }
  }
}

showAlertDialog(BuildContext context, String text) {
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
            Navigator.of(context).pop();
          }
  );

  AlertDialog alert = AlertDialog(
    title: Text("Olá"),
    content: Text("Bem vindo à PUC Minas unidade " + text),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<String> sendUserLocation(double? latitude, double? longitude) async {
  var client = http.Client();
  final msg = jsonEncode({"coordinates": {
        "latitude": latitude,
        "longitude": longitude
      }});
  try {
    var uriResponse = await client.post(Uri.parse('https://southamerica-east1-nothingherem8.cloudfunctions.net/amICloseToPuc'),
    headers: {
      'Content-type': 'application/json'
    },
    body: msg,
    );
    print(uriResponse.body);
    return uriResponse.body;
  } catch(e) {
    print(e);
    return '';
  }
}
