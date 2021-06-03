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

// Google maps controller
class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  static final CameraPosition _dartIsland = CameraPosition(
    target: LatLng(-43.02528538509029, 147.8511571119575),
    zoom: 14.4746,
  );
   
   // Google maps configurations
   @override
   void initState() {
     // Move refresh inverval: 10000 (10 seconds) + accuracy (low)
     location.changeSettings(accuracy: LocationAccuracy.low, interval: 10000);
     super.initState();
     location.onLocationChanged.listen((value) {
       print("teste2");
       print(value.latitude);
       _setUserLocationOnMap(value.latitude, value.longitude);
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

  // Builds google map widget
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _dartIsland,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<void> _setUserLocationOnMap(double? latitude, double? longitude) async {
    print("Entrou");
    CameraPosition currentLocation;
    final GoogleMapController controller = await _controller.future;
    try {
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

  // Shows dialog on screen greeting user to nearest PUC Minas
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

// Call cloud function passing user current coordinates
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
