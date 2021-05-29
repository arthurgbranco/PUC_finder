import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class GoogleMapsDemo extends StatefulWidget {
  @override
  _GoogleMapsDemoState createState() => _GoogleMapsDemoState();
}

class _GoogleMapsDemoState extends State<GoogleMapsDemo> {
  GoogleMapController? mapController;
  Location location = Location();

  // ignore: invalid_use_of_visible_for_testing_member
  Marker marker = new Marker('', new MarkerOptions());

  @override
  void initState() {
    super.initState();
    location.onLocationChanged().listen((location) async {
      if(marker != null) {
        mapController?.removeMarker(marker);
      }
      marker = (await mapController?.addMarker(MarkerOptions(
        position: LatLng(location["latitude"]!, location["longitude"]!),
      )))!;
      mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              location["latitude"]!,
              location["longitude"]!,
            ),
            zoom: 20.0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              }, initialCameraPosition: CameraPosition(
            zoom: 20.0, target: LatLng(
              0,
              0,
            ),
          ),
            ),
          ),
        ],
      ),
    );
  }
}