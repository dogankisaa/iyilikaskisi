import 'dart:async';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  String adres;
  GoogleMapPage({this.adres});
  @override
  GoogleMapPageState createState() => GoogleMapPageState();
}

class GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  final Geolocator _geolocator = Geolocator();

// For storing the current position
  Position _currentPosition;
  double zoomVal = 5.0;
  MapType _currentMapType = MapType.normal;

  String _startAddress = '';
  String _destinationAddress = '';
  String _currentAddress;
  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _zoomMinusFunction(),
        ],
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition:
                CameraPosition(target: LatLng(38.9573415, 35.240741), zoom: 12),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {marker1},
          ),
        ),
      ],
    );
  }

  Widget _zoomMinusFunction() {
    return Align(
      alignment: Alignment.topRight,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 8.0),
            child: Row(
              children: [
                Spacer(),
                Column(
                  children: [
                    Container(
                      width: 55.0,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            zoomVal--;
                            _minus(zoomVal);
                          }),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 55.0,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            zoomVal++;
                            _plus(zoomVal);
                          }),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 55.0,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: IconButton(
                          icon: Icon(
                            Icons.my_location,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            _getCurrentLocation();
                          }),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 55.0,
                      height: 55.0,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                      ),
                      child: IconButton(
                          icon: Icon(
                            Icons.map,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _currentMapType =
                                  _currentMapType == MapType.normal
                                      ? MapType.satellite
                                      : MapType.normal;
                            });
                          }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    await _geolocator.getCurrentPosition().then((Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');

        // For moving the camera to current location
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });

   
    
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(38.9573415, 35.240741), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(38.9573415, 35.240741), zoom: zoomVal)));
  }
}

Marker marker1 = Marker(
  markerId: MarkerId('gramercy'),
  position: LatLng(38.9573415, 35.240741),
  infoWindow: InfoWindow(title: 'Gramercy Tavern'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);


