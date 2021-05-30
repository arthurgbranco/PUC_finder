// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:location/location.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';


// class GoogleMapsDemo extends StatefulWidget {
//   @override
//   _GoogleMapsDemoState createState() => _GoogleMapsDemoState();
// }

// class _GoogleMapsDemoState extends State<GoogleMapsDemo> {
//   GoogleMapController? mapController;
//   Location location = Location();

//   // ignore: invalid_use_of_visible_for_testing_member
//   Marker marker = new Marker(markerId: new MarkerId(''));

//   @override
//   void initState() {
//     super.initState();
//     location.onLocationChanged.listen((location) async {
//       if(marker != null) {
//         mapController?.removeMarker(marker);
//       }
//       marker = (await mapController?.addMarker(MarkerOptions(
//         position: LatLng(location["latitude"]!, location["longitude"]!),
//       )))!;
//       mapController?.moveCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(
//               location["latitude"]!,
//               location["longitude"]!,
//             ),
//             zoom: 20.0,
//           ),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               }, initialCameraPosition: CameraPosition(
//             zoom: 20.0, target: LatLng(
//               0,
//               0,
//             ),
//           ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}